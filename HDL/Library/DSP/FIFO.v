module FIFO #(
  parameter Width,
  parameter Length
)(
  input  ipClk,
  input  ipReset,

  output [$clog2(Length)-1:0]opNumItems,

  input                 ipInput_SoP,
  input                 ipInput_EoP,
  input      [Width-1:0]ipInput_Data,
  input                 ipInput_Valid,

  output reg            opOutput_SoP,
  output reg            opOutput_EoP,
  output reg [Width-1:0]opOutput_Data,
  output reg            opOutput_Valid,
  input                 ipOutput_Ready
);
//------------------------------------------------------------------------------

localparam AddressWidth = $clog2(Length);
//------------------------------------------------------------------------------

reg  [AddressWidth-1:0]WrAddress;
reg  [AddressWidth-1:0]RdAddress;
wire [       Width-1:0]RdData;

DualPortRAM #(
  .Width       (Width+2    ),
  .Depth       (Length     ),
  .DeviceFamily("Cyclone V"),
  .RamBlockType("M10K"     )
)RAM(
  .ipClk      (ipClk         ),
  .ipReset    (ipReset       ),

  .ipWrAddress(WrAddress     ),
  .ipWrData   ({ipInput_SoP, ipInput_EoP, ipInput_Data}),
  .ipWrEnable (ipInput_Valid ),

  .ipRdAddress(RdAddress     ),
  .ipRdEnable (ipOutput_Ready),
  .opRdData   (RdData        )
);
//------------------------------------------------------------------------------

reg Reset;
reg Valid;

assign opNumItems = WrAddress - RdAddress;

always @(posedge ipClk) begin
  Reset <= ipReset;
  //----------------------------------------------------------------------------

  if(Reset) begin
    opOutput_SoP   <= 1'hX;
    opOutput_EoP   <= 1'hX;
    opOutput_Data  <=  'hX;
    opOutput_Valid <= 1'h0;

    WrAddress      <= 0;
    RdAddress      <= 0;
    Valid          <= 0;
  //----------------------------------------------------------------------------

  end else begin
    if(ipInput_Valid) WrAddress <= WrAddress + 1;
    //--------------------------------------------------------------------------

    if(ipOutput_Ready) begin
      {opOutput_SoP, opOutput_EoP, opOutput_Data} <= RdData;
      opOutput_Valid <= Valid;

      if(opNumItems != 0) begin
        Valid     <= 1;
        RdAddress <= RdAddress + 1;
      end else begin
        Valid     <= 0;
      end
    end
  end
end
//------------------------------------------------------------------------------

endmodule
//------------------------------------------------------------------------------

