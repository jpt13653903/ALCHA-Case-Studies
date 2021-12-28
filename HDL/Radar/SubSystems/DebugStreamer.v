module DebugStreamer(
  input  ipClk,
  input  ipReset,

  input PACKET ipPacket,

  output reg [12:0]opAddress, // Live buffer address
  output reg [15:0]opWriteData,
  output reg       opWrite,

  output reg [12:0]opWrAddress // Write pointer to the ARM
);
//------------------------------------------------------------------------------

reg Reset;

enum {Idle, Streaming} State;

always @(posedge ipClk) begin
  Reset <= ipReset;
  //----------------------------------------------------------------------------

  if(Reset) begin
    opAddress    <= 13'hX;
    opWriteData  <= 16'hX;
    opWrite      <= 0;
    opWrAddress  <= 0;

    State        <= Idle;
  //----------------------------------------------------------------------------

  end else begin
    case(State)
      Idle: begin
        if(opWrite) opAddress   <= opAddress + 1;
        else        opWrAddress <= opAddress;

        opWriteData <= {ipPacket.Data, 2'b0};

        if(ipPacket.Valid & ipPacket.SoP) begin
          opWrite <= 1;
          State   <= Streaming;
        end else begin
          opWrite <= 0;
        end
      end
      //------------------------------------------------------------------------

      Streaming: begin
        opWriteData <= {ipPacket.Data, 2'b0};
        opWrite     <=  ipPacket.Valid;
        if(ipPacket.Valid) begin
          opAddress <= opAddress + 1;
          if(ipPacket.EoP) State <= Idle;
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

