module AD9915(
  input        ipClk,
  input        ipReset,

  input  [31:0]ipFreqLowerLimit,
  input  [31:0]ipFreqUpperLimit,
  input  [31:0]ipStepUp,
  input  [31:0]ipStepDown,
  input  [15:0]ipSlopeUp,
  input  [15:0]ipSlopeDown,

  input        ipUpdate,
  output       opBusy,

  output       opSClk,
  output       opnCS,
  output       opSDIO,
  output       opSyncIO,
  output       opIO_Update,

  input        ipTrigger,
  output       opDR_Control,
  output       opDR_Hold,
  input        ipDR_Over
);
//------------------------------------------------------------------------------

localparam TRANSACTION_LENGTH = 41;
//------------------------------------------------------------------------------

reg       Reset;
reg [14:0]CalCount;
//------------------------------------------------------------------------------

reg [39:0]Data;
reg [ 5:0]BitCount;
reg       RegsChanged;
//------------------------------------------------------------------------------

reg [31:0]FreqLowerLimit;
reg [31:0]FreqUpperLimit;
reg [31:0]StepUp;
reg [31:0]StepDown;
reg [15:0]SlopeUp;
reg [15:0]SlopeDown;
//------------------------------------------------------------------------------

typedef enum {
  SetCRF1, SetCRF2,
  DoDAC_Calibrate, ClearDAC_Calibrate,
  Idle,
  SetRampLowerLimit, SetRampUpperLimit,
  SetRisingStepSize, SetFallingStepSize, SetRampRate,

  CreateUpdatePulse,

  Send_SPI
} STATE;

STATE State;
STATE RetState;
//------------------------------------------------------------------------------

assign opnCS  = 0;
assign opSDIO = Data[39];
//------------------------------------------------------------------------------

always @(posedge ipClk) begin
  Reset <= ipReset;
  //----------------------------------------------------------------------------

  if(Reset) begin
    opBusy         <= 1;

    opSClk         <= 0;
    opSyncIO       <= 0;
    opIO_Update    <= 0;

    CalCount       <= 'hX;
    Data           <= 'hX;
    BitCount       <= 'hX;
    RegsChanged    <= 'hX;

    FreqLowerLimit <= ~ipFreqLowerLimit;
    FreqUpperLimit <= ~ipFreqUpperLimit;
    StepUp         <= ~ipStepUp;
    StepDown       <= ~ipStepDown;
    SlopeUp        <= ~ipSlopeUp;
    SlopeDown      <= ~ipSlopeDown;

    State          <= SetCRF1;
  //----------------------------------------------------------------------------

  end else begin
    case(State)
      SetCRF1: begin
        Data      <= 40'h000001000A;
        BitCount  <= TRANSACTION_LENGTH;
        State     <= Send_SPI;
        RetState  <= SetCRF2;
      end
      //--------------------------------------------------------------------

      SetCRF2: begin
        Data      <= 40'h0100082900; // Enable DRG Over output and digital ramp
        BitCount  <= TRANSACTION_LENGTH;
        State     <= Send_SPI;
        RetState  <= DoDAC_Calibrate;
      end
      //--------------------------------------------------------------------

      DoDAC_Calibrate: begin
        CalCount  <= ~0;
        Data      <= 40'h0301052120; // DAC Calibrate
        BitCount  <= TRANSACTION_LENGTH;
        State     <= Send_SPI;
        RetState  <= ClearDAC_Calibrate;
      end
      //--------------------------------------------------------------------

      ClearDAC_Calibrate: begin
        if(&CalCount) begin
          opIO_Update <= 1;
        end else begin
          opIO_Update <= 0;
          if(CalCount == 0) begin
            Data      <= 40'h0300052120;
            BitCount  <= TRANSACTION_LENGTH;
            State     <= Send_SPI;
            RetState  <= SetRampLowerLimit;
          end
        end
        CalCount <= CalCount - 1;
      end
      //--------------------------------------------------------------------

      Idle: begin
        RegsChanged <= 0;

        if(opBusy) begin
          opBusy <= ipUpdate;

        end else if(ipUpdate) begin
          opBusy <= 1;
          State  <= SetRampLowerLimit;
        end
      end
      //--------------------------------------------------------------------

      SetRampLowerLimit: begin
        if(ipFreqLowerLimit != FreqLowerLimit) begin
          FreqLowerLimit <= ipFreqLowerLimit;
          Data           <= {8'h04, ipFreqLowerLimit};
          BitCount       <= TRANSACTION_LENGTH;
          State          <= Send_SPI;
          RetState       <= SetRampUpperLimit;
        end else begin
          State          <= SetRampUpperLimit;
        end
      end
      //--------------------------------------------------------------------

      SetRampUpperLimit: begin
        if(ipFreqUpperLimit != FreqUpperLimit) begin
          FreqUpperLimit <= ipFreqUpperLimit;
          Data           <= {8'h05, ipFreqUpperLimit};
          BitCount       <= TRANSACTION_LENGTH;
          State          <= Send_SPI;
          RetState       <= SetRisingStepSize;
        end else begin
          State          <= SetRisingStepSize;
        end
      end
      //--------------------------------------------------------------------

      SetRisingStepSize: begin
        if(ipStepUp != StepUp) begin
          StepUp    <= ipStepUp;
          Data      <= {8'h06, ipStepUp};
          BitCount  <= TRANSACTION_LENGTH;
          State     <= Send_SPI;
          RetState  <= SetFallingStepSize;
        end else begin
          State     <= SetFallingStepSize;
        end
      end
      //--------------------------------------------------------------------

      SetFallingStepSize: begin
        if(ipStepDown != StepDown) begin
          StepDown  <= ipStepDown;
          Data      <= {8'h07, ipStepDown};
          BitCount  <= TRANSACTION_LENGTH;
          State     <= Send_SPI;
          RetState  <= SetRampRate;
        end else begin
          State     <= SetRampRate;
        end
      end
      //--------------------------------------------------------------------

      SetRampRate: begin
        if((ipSlopeUp != SlopeUp) || (ipSlopeDown != SlopeDown)) begin
          SlopeUp   <= ipSlopeUp;
          SlopeDown <= ipSlopeDown;
          Data      <= {8'h08, ipSlopeDown, ipSlopeUp};
          BitCount  <= TRANSACTION_LENGTH;
          State     <= Send_SPI;
          RetState  <= CreateUpdatePulse;
        end else begin
          State     <= CreateUpdatePulse;
        end
      end
      //--------------------------------------------------------------------

      CreateUpdatePulse: begin
        if(RegsChanged) begin
          if(opIO_Update) begin
            opIO_Update <= 0;
            State       <= Idle;
          end else begin
            opIO_Update <= 1;
          end
        end else begin
          State <= Idle;
        end
      end
      //--------------------------------------------------------------------

      Send_SPI: begin
        RegsChanged <= 1;

        case(BitCount)
          TRANSACTION_LENGTH:
            if(~opSyncIO) begin
              opSyncIO <= 1;
            end else begin
              opSyncIO <= 0;
              BitCount <= BitCount - 1;
            end

          6'd0:
            State     <= RetState;

          default:
            if(~opSClk) begin
              opSClk   <= 1;
            end else begin
              opSClk   <= 0;
              Data     <= {Data[38:0], 1'b0};
              BitCount <= BitCount - 1;
            end
        endcase
      end
      //--------------------------------------------------------------------

      default:;
    endcase
  end
end
//------------------------------------------------------------------------------

reg [1:0]Trigger;
reg [1:0]DR_Over;

assign opDR_Hold = 0;
//------------------------------------------------------------------------------

always @(posedge ipClk) begin
  Trigger <= {Trigger[0], ipTrigger};
  DR_Over <= {DR_Over[0], ipDR_Over};
  //------------------------------------------------------------------------

  if(Reset) begin
    opDR_Control <= 0;
  //------------------------------------------------------------------------

  end else begin
    if(DR_Over == 2'b01) begin
      if(Trigger[0]) opDR_Control <= ~opDR_Control; // Continuous operation
      else           opDR_Control <= 0;             // Return to idle

    end else if((DR_Over[0] == 1) && (Trigger == 2'b01)) begin
      opDR_Control <= ~opDR_Control // Prevent dead-lock
                   && ~opBusy;      // Ignore trigger when reg update busy
    end
  end
end
//------------------------------------------------------------------------------

endmodule
//------------------------------------------------------------------------------

