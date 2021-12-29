module I2C #(
  parameter Clk_Frequency,
  parameter Baud_kHz = 50
)(
  input  ipClk,
  input  ipReset,

  input  ipQuiet,
  output opError,

  input  [7:0]ipTxData,
  output [7:0]opRxData,
  input  [3:0]ipCommand, // Start | R_nW | Ack | Stop
  input       ipGo,
  output      opBusy,

  input  ipSClk,
  output opSClk,
  input  ipData,
  output opData
);
//------------------------------------------------------------------------------

localparam Baud_Cycles = Clk_Frequency / (Baud_kHz * 3);
localparam Baud_N      = $clog2(Baud_Cycles);

reg [Baud_N-1:0]Baud_Count;

always @(posedge ipClk) begin
  if(Baud_Count) Baud_Count <= Baud_Count  - 1;
  else           Baud_Count <= Baud_Cycles - 1;
end
wire Baud_Trigger = ~|Baud_Count;
//------------------------------------------------------------------------------

reg Reset;

reg [3:0]Command;
wire Start = Command[3];
wire R_nW  = Command[2];
wire Ack   = Command[1];
wire Stop  = Command[0];

reg [7:0]Data;
reg [2:0]Count;

enum {
  sIdle,
  sStart,
  sTransfer_0, sTransfer_1, sTransfer_2,
  sAck_0, sAck_1, sAck_2,
  sStop
} State;
//------------------------------------------------------------------------------

always @(posedge ipClk) begin
  Reset <= ipReset;

  if(Reset) begin
    opError  <= 0;
    opRxData <= 8'hX;
    opBusy   <= 0;
    opSClk   <= 1;
    opData   <= 1;

    Data    <= 8'hX;
    Command <= 4'hX;
    Count   <= 3'hX;

    State   <= sStart;
  //----------------------------------------------------------------------------

  // If ipSClk != opSClk it means that the slave is clock-stretching
  end else if(Baud_Trigger & (ipSClk == opSClk) & !ipQuiet) begin
    case(State)
      sIdle: begin
        Data    <= ipTxData;
        Command <= ipCommand;

        if(opBusy) begin
          if(~ipGo) opBusy <= 0;
        end else begin
          if(ipGo) begin
            opBusy <= 1;
            State  <= sStart;
          end
        end
      end
      //------------------------------------------------------------------------

      sStart: begin
        if(Start | opSClk) begin
          case({opSClk, opData})
            2'b00: opData <= 1;
            2'b01: opSClk <= 1;
            2'b11: opData <= 0;
            2'b10: begin
              opSClk <= 0;
              State  <= sTransfer_0;
            end
          endcase
        end
        Count <= 0;
      end
      //------------------------------------------------------------------------

      sTransfer_0: begin
        if(R_nW) opData <= 1;
        else     opData <= Data[7];
        
        State <= sTransfer_1;
      end
      //------------------------------------------------------------------------

      sTransfer_1: begin
        opSClk <= 1;
        State  <= sTransfer_2;
      end
      //------------------------------------------------------------------------

      sTransfer_2: begin
        opSClk <= 0;
        Data   <= {Data[6:0], ipData};

        if(Count == 7) State <= sAck_0;
        Count <= Count + 1;
      end
      //------------------------------------------------------------------------

      sAck_0: begin
        if(R_nW) begin
          opRxData <=  Data;
          opData   <= ~Ack;
        end else begin
          opData   <= 1;
        end
        State <= sAck_1;
      end
      //------------------------------------------------------------------------

      sAck_1: begin
        opSClk <= 1;
        State  <= sAck_2;
      end
      //------------------------------------------------------------------------

      sAck_2: begin
        if(R_nW) begin
          opSClk <= 0;
          State  <= sStop;
        end else begin
          if(ipData != Ack) begin
            if(~ipGo) opBusy <= 0;
            opError <= 1;
            State   <= sIdle;
          end else begin
            opSClk  <= 0;
            opError <= 0;
            State   <= sStop;
          end
        end
      end
      //------------------------------------------------------------------------

      sStop: begin
        if(Stop) begin
          case({opSClk, opData})
            2'b11: opSClk <= 0;
            2'b01: opData <= 0;
            2'b00: opSClk <= 1;
            2'b10: begin
              if(~ipGo) opBusy <= 0;
              opData <= 1;
              State  <= sIdle;
            end
          endcase
        end
      end
      //------------------------------------------------------------------------

      default:;
    endcase
  end
end
//------------------------------------------------------------------------------

endmodule
//------------------------------------------------------------------------------

