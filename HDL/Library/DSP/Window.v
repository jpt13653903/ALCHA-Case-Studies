/*------------------------------------------------------------------------------

For real data, don't connect the _Q ports.  The compiler will remove the 
resulting dangling circuits.
------------------------------------------------------------------------------*/

module Window #(
  parameter InWidth,
  parameter OutWidth,
  parameter Length,
  parameter Complex,
  parameter DeviceFamily = "Cyclone V",
  parameter RamBlockType = "M10K",
  parameter MIF_File
)(
  input                ipClk,
  input                ipReset,

  input                ipInput_SoP,
  input                ipInput_EoP,
  input  [InWidth -1:0]ipInput_I,
  input  [InWidth -1:0]ipInput_Q,
  input                ipInput_Valid,
  output               opInput_Ready,

  output               opOutput_SoP,
  output               opOutput_EoP,
  output [OutWidth-1:0]opOutput_I,
  output [OutWidth-1:0]opOutput_Q,
  output               opOutput_Valid,
  input                ipOutput_Ready
);
//------------------------------------------------------------------------------

localparam AddressWidth = $clog2(Length);
//------------------------------------------------------------------------------

reg        WaitForROM;
wire       Ready = ~WaitForROM;
wire [17:0]Coefficient;
//------------------------------------------------------------------------------

reg [AddressWidth-1:0]Address;

DualPortROM #(
  .Width       (18          ),
  .Depth       (Length      ),
  .DeviceFamily(DeviceFamily),
  .RamBlockType(RamBlockType),
  .MIF_File    (MIF_File    )
)ROM(
  .ipClk        (ipClk  ),
  .ipReset      (ipReset),

  .ipClkEnable_A((ipOutput_Ready & ipInput_Valid) | WaitForROM),
  .ipAddress_A  (Address    ),
  .opData_A     (Coefficient)
);
//------------------------------------------------------------------------------

wire signed [InWidth+18:0]Product_I = $signed(ipInput_I) * $signed({1'b0, Coefficient});
wire signed [InWidth+18:0]Product_Q;

always @(*) begin
  if(Complex) Product_Q <= $signed(ipInput_Q) * $signed({1'b0, Coefficient});
  else        Product_Q <= 0;
end
//------------------------------------------------------------------------------

reg Reset;

assign opInput_Ready = ipOutput_Ready & Ready;

always @(posedge ipClk) begin
  Reset <= ipReset;

  if(Reset) begin
    opOutput_SoP   <= 1'hX;
    opOutput_EoP   <= 1'hX;
    opOutput_I     <=  'hX;
    opOutput_Q     <=  'hX;
    opOutput_Valid <= 1'h0;

    Product_I      <=  'hX;
    Product_Q      <=  'hX;

    WaitForROM     <= 1;

  end else if(ipOutput_Ready) begin
    if(Ready) begin
      opOutput_SoP   <= ipInput_SoP;
      opOutput_EoP   <= ipInput_EoP;
      opOutput_Valid <= ipInput_Valid;
      opOutput_I     <= Product_I[InWidth+17 -: OutWidth];
      opOutput_Q     <= Product_Q[InWidth+17 -: OutWidth];
    end
    
    if(WaitForROM) begin
      Address    <= Address + 1;
      WaitForROM <= 0;
    end else begin
      if(ipInput_Valid) begin
        if(ipInput_EoP) begin
          Address    <= 0;
          WaitForROM <= 1;
        end else begin
          Address    <= Address + 1;
        end
      end
    end
  end
end
//------------------------------------------------------------------------------

endmodule
//------------------------------------------------------------------------------

