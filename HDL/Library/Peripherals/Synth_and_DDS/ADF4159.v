module ADF4159 #(
  parameter Clk_Frequency,
  parameter Baud_kHz = 1000
)(
  input       ipClk,
  input       ipReset,

  input [ 3:0]ipCP_CurrentSetting,
  input       ipRampOn,

  input [11:0]ipInteger,
  input [24:0]ipFraction,

  input [15:0]ipDeviationWord_0,
  input [ 3:0]ipDeviationOffset_0,
  input [19:0]ipStepWord_0,

  input [15:0]ipDeviationWord_1,
  input [ 3:0]ipDeviationOffset_1,
  input [19:0]ipStepWord_1,

  input       ipUseRefMul2,
  input [ 4:0]ipRefCounter,
  input       ipUseRefDiv2,

  input [11:0]ipClk1Divider,
  input [11:0]ipClk2Divider_0,
  input [11:0]ipClk2Divider_1,

  input       ipUpdate,
  output      opBusy,

  input       ipTrigger,

  output      opSPI_SClk,
  output      opSPI_Data,
  output      opSPI_Latch,
  output      opTrigger,
  input       ipMuxOut
);
//------------------------------------------------------------------------------

// Constants we generally don't want to change...  Move to ports as required
wire [ 3:0]ipMuxOutControl      = 4'hF;
wire       ipPhaseAdjust        = 0;
wire [11:0]ipPhaseValue         = 0;
wire       ipCSR_Enable         = 0;
wire       ipPrescaler          = 0;
wire [ 2:0]ipNegBleedCurrent    = 4;
wire       ipNegBleedEnable     = 0;
wire       ipLossOfLock         = 0;
wire       ipNSel               = 0;
wire       ipSD_Reset           = 0;
wire [ 1:0]ipRampMode           = 3;
wire       ipPSK                = 0;
wire       ipFSK                = 0;
wire       ipLDP                = 1;
wire       ipPDPolarity         = 0;
wire       ipPowerDown          = 0;
wire       ipCP_ThreeState      = 0;
wire       ipCounterReset       = 0;
wire       ipLE_Select          = 0;
wire [ 4:0]ipSD_ModulatorMode   = 0;
wire [ 4:0]ipRampStatus         = 3;
wire [ 1:0]ipClkDivMode         = 3;
wire       ipTxDataInvert       = 0;
wire       ipTxDataRampClk      = 0;
wire       ipParabolicRamp      = 0;
wire [ 1:0]ipInterrupt          = 0;
wire       ipFSK_Ramp           = 0;
wire       ipDualRamp           = 0;
wire       ipTxDataTriggerDelay = 0;
wire       ipTriDelay           = 0;
wire       ipSingleFullTriangle = 1;
wire       ipTxDataTrigger      = 1;
wire       ipFastRamp           = 1;
wire       ipRampDelayFastLock  = 0;
wire       ipRampDelay          = 0;
wire       ipDelClkSel          = 0;
wire       ipDelStartEn         = 0;
wire [11:0]ipDelayStartWord     = 0;
//------------------------------------------------------------------------------

wire [31:0]R0   = {ipRampOn,
                   ipMuxOutControl,
                   ipInteger,
                   ipFraction[24:13],
                   3'd0};

wire [31:0]R1   = {3'd0,
                   ipPhaseAdjust,
                   ipFraction[12:0],
                   ipPhaseValue,
                   3'd1};

wire [31:0]R2   = {3'd0,
                   ipCSR_Enable,
                   ipCP_CurrentSetting,
                   1'd0,
                   ipPrescaler,
                   ipUseRefDiv2,
                   ipUseRefMul2,
                   ipRefCounter,
                   ipClk1Divider,
                   3'd2};

wire [31:0]R3   = {7'd0,
                   ipNegBleedCurrent,
                   ipNegBleedEnable,
                   4'd1,
                   ipLossOfLock,
                   ipNSel,
                   ipSD_Reset,
                   2'd0,
                   ipRampMode,
                   ipPSK,
                   ipFSK,
                   ipLDP,
                   ipPDPolarity,
                   ipPowerDown,
                   ipCP_ThreeState,
                   ipCounterReset,
                   3'd3};

wire [31:0]R4_0 = {ipLE_Select,
                   ipSD_ModulatorMode,
                   ipRampStatus,
                   ipClkDivMode,
                   ipClk2Divider_0,
                   1'd0,
                   3'd0,
                   3'd4};

wire [31:0]R4_1 = {ipLE_Select,
                   ipSD_ModulatorMode,
                   ipRampStatus,
                   ipClkDivMode,
                   ipClk2Divider_1,
                   1'd1,
                   3'd0,
                   3'd4};

wire [31:0]R5_0 = {1'd0,
                   ipTxDataInvert,
                   ipTxDataRampClk,
                   ipParabolicRamp,
                   ipInterrupt,
                   ipFSK_Ramp,
                   ipDualRamp,
                   1'd0,
                   ipDeviationOffset_0,
                   ipDeviationWord_0,
                   3'd5};

wire [31:0]R5_1 = {1'd0,
                   ipTxDataInvert,
                   ipTxDataRampClk,
                   ipParabolicRamp,
                   ipInterrupt,
                   ipFSK_Ramp,
                   ipDualRamp,
                   1'd1,
                   ipDeviationOffset_1,
                   ipDeviationWord_1,
                   3'd5};

wire [31:0]R6_0 = {9'd0,
                   ipStepWord_0,
                   3'd6};

wire [31:0]R6_1 = {9'd1,
                   ipStepWord_1,
                   3'd6};

wire [31:0]R7   = {8'd0,
                   ipTxDataTriggerDelay,
                   ipTriDelay,
                   ipSingleFullTriangle,
                   ipTxDataTrigger,
                   ipFastRamp,
                   ipRampDelayFastLock,
                   ipRampDelay,
                   ipDelClkSel,
                   ipDelStartEn,
                   ipDelayStartWord,
                   3'd7};
//------------------------------------------------------------------------------

localparam Baud_Cycles = Clk_Frequency / (Baud_kHz*2);
localparam Baud_N      = $clog2(Baud_Cycles);

reg [Baud_N-1:0] Baud_Count;

always @(posedge ipClk) begin
  if(Baud_Count) Baud_Count <= Baud_Count  - 1;
  else           Baud_Count <= Baud_Cycles - 1;
end

wire Baud_Trigger = ~|Baud_Count;
//------------------------------------------------------------------------------

reg       Reset;
reg [31:0]Register;
reg [ 4:0]Count;

assign opSPI_Data = Register[31];

typedef enum {
  Idle,
  Send_R7,
  Send_R6_1, Send_R6_0,
  Send_R5_1, Send_R5_0,
  Send_R4_1, Send_R4_0,
  Send_R3,
  Send_R2,
  Send_R1,
  Send_R0,
  Done,

  SendSPI,
  SendSPI_1,
  SendSPI_2
} STATE;

STATE State;
STATE RetState;

always @(posedge ipClk) begin
  Reset <= ipReset;

  if(Reset) begin
    opSPI_SClk  <= 0;
    opSPI_Latch <= 1;
    opBusy      <= 1;

    State    <= Idle;
    RetState <= Idle;

  end else if(Baud_Trigger) begin
    case(State)
      Idle: begin
        opBusy <= 0;
        if(ipUpdate) State <= Send_R7;
      end

      Send_R7: begin
        opBusy   <= 1;
        Register <= R7;
        RetState <= Send_R6_1;
        State    <= SendSPI;
      end

      Send_R6_1: begin
        Register <= R6_1;
        RetState <= Send_R6_0;
        State    <= SendSPI;
      end

      Send_R6_0: begin
        Register <= R6_0;
        RetState <= Send_R5_1;
        State    <= SendSPI;
      end

      Send_R5_1: begin
        Register <= R5_1;
        RetState <= Send_R5_0;
        State    <= SendSPI;
      end

      Send_R5_0: begin
        Register <= R5_0;
        RetState <= Send_R4_1;
        State    <= SendSPI;
      end

      Send_R4_1: begin
        Register <= R4_1;
        RetState <= Send_R4_0;
        State    <= SendSPI;
      end

      Send_R4_0: begin
        Register <= R4_0;
        RetState <= Send_R3;
        State    <= SendSPI;
      end

      Send_R3: begin
        Register <= R3;
        RetState <= Send_R2;
        State    <= SendSPI;
      end

      Send_R2: begin
        Register <= R2;
        RetState <= Send_R1;
        State    <= SendSPI;
      end

      Send_R1: begin
        Register <= R1;
        RetState <= Send_R0;
        State    <= SendSPI;
      end

      Send_R0: begin
        Register <= R0;
        RetState <= Done;
        State    <= SendSPI;
      end

      Done: begin
        if(!ipUpdate) begin
          opBusy <= 0;
          State  <= Idle;
        end
      end
      //------------------------------------------------------------------------

      SendSPI: begin
        opSPI_Latch <= 0;
        Count       <= 0;
        State       <= SendSPI_1;
      end

      SendSPI_1: begin
        if(opSPI_SClk == 0) begin
          opSPI_SClk <= 1;

        end else begin
          opSPI_SClk <= 0;
          Register   <= {Register[30:0], 1'b0};

          if(Count == 31) State <= SendSPI_2;
          Count <= Count + 1;
        end
      end

      SendSPI_2: begin
        opSPI_Latch <= 1;
        State       <= RetState;
      end
      //------------------------------------------------------------------------

      default:;
    endcase
  end
end
//------------------------------------------------------------------------------

endmodule
//------------------------------------------------------------------------------

