typedef struct{
  logic       SoP;
  logic       EoP;
  logic [13:0]Data;
  logic       Valid;
} PACKET;
//------------------------------------------------------------------------------

module ReceiverAbstraction(
  input  ipDspClk,
  input  ipControlClk,
  input  ipReset,

  output RECEIVER_RD_REGISTERS opRdRegisters,
  input  RECEIVER_WR_REGISTERS ipWrRegisters,

  input  ipMasterTrigger,

  output PACKET opPacket,

  output opSClk,
  output opnCS,
  input  ipData,

  output [12:0]opDebug_Address,
  output [15:0]opDebug_WriteData,
  output       opDebug_Write,

  output PacketTrigger_Output
);
//------------------------------------------------------------------------------

wire [13:0]ADC_Data;
wire       ADC_Valid;

ADS7056 ADC(
  .ipClk  (ipDspClk ),
  .ipReset(ipReset  ),

  .opSClk (opSClk   ),
  .opnCS  (opnCS    ),
  .ipData (ipData   ),

  .opData (ADC_Data ),
  .opValid(ADC_Valid)
);
//------------------------------------------------------------------------------

TriggerDelay PacketTrigger(
  .ipClk    (ipControlClk),
  .ipReset  (ipReset     ),

  .ipEnable (ipWrRegisters.PacketTrigger.Enable),
  .ipDelay  (ipWrRegisters.PacketTrigger.Delay ),
  .ipLength (ipWrRegisters.PacketTrigger.Length),

  .ipTrigger(ipMasterTrigger     ),
  .opTrigger(PacketTrigger_Output)
);
//------------------------------------------------------------------------------

reg PacketTrigger_DSP;

always @(posedge ipDspClk) PacketTrigger_DSP <= PacketTrigger_Output;
//------------------------------------------------------------------------------

localparam N = 2500;

reg Reset;
reg [11:0]n;

enum {Idle, Sampling} State;

always @(posedge ipDspClk) begin
  Reset <= ipReset;
  //----------------------------------------------------------------------------

  if(Reset) begin
    opPacket.Valid <= 0;

    n     <= 12'hX;
    State <= Idle;
  //----------------------------------------------------------------------------

  end else begin
    case(State)
      Idle: begin
        n <= 0;
        opPacket.Valid <= 0;
        if(PacketTrigger_DSP) State <= Sampling;
      end
      //------------------------------------------------------------------------

      Sampling: begin
        if(n < N) begin
          opPacket.SoP   <= (n == 0);
          opPacket.EoP   <= (n == N-1);
          opPacket.Data  <= {~ADC_Data[13], ADC_Data[12:0]};
          opPacket.Valid <= ADC_Valid;
        end else begin
          State <= Idle;
        end

        if(ADC_Valid) n <= n + 1;
      end
      //------------------------------------------------------------------------

      default:;
    endcase
  end
end
//------------------------------------------------------------------------------

DebugStreamer DebugStreamer_Inst(
  .ipClk      (ipDspClk),
  .ipReset    (ipReset ),

  .ipPacket   (opPacket),

  .opAddress  (opDebug_Address  ),
  .opWriteData(opDebug_WriteData),
  .opWrite    (opDebug_Write    ),

  .opWrAddress(opRdRegisters.DebugWrAddress)
);
//------------------------------------------------------------------------------

endmodule
//------------------------------------------------------------------------------

