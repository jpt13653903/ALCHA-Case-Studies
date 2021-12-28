module AvalonArbiter #(
  parameter Width,
  parameter AddressWidth
)(
  input                   ipClk,
  input                   ipReset,

  output                  opMaster1_WaitRequest,
  input [AddressWidth-1:0]ipMaster1_Address,
  input [(Width/8)   -1:0]ipMaster1_ByteEnable,
  input [             7:0]ipMaster1_BurstCount,
                            
  input [Width       -1:0]ipMaster1_WriteData,
  input                   ipMaster1_Write,
                            
  input                   ipMaster1_Read,
  output[Width       -1:0]opMaster1_ReadData,
  output                  opMaster1_ReadValid,

  output                  opMaster2_WaitRequest,
  input [AddressWidth-1:0]ipMaster2_Address,
  input [(Width/8)   -1:0]ipMaster2_ByteEnable,
  input [             7:0]ipMaster2_BurstCount,
                            
  input [Width       -1:0]ipMaster2_WriteData,
  input                   ipMaster2_Write,
                            
  input                   ipMaster2_Read,
  output[Width       -1:0]opMaster2_ReadData,
  output                  opMaster2_ReadValid,

  input                   ipAvalon_WaitRequest,
  output[AddressWidth-1:0]opAvalon_Address,
  output[(Width/8)   -1:0]opAvalon_ByteEnable,
  output[             7:0]opAvalon_BurstCount,
                          
  output[Width       -1:0]opAvalon_WriteData,
  output                  opAvalon_Write,
                          
  output                  opAvalon_Read,
  input [Width       -1:0]ipAvalon_ReadData,
  input                   ipAvalon_ReadValid
);
//------------------------------------------------------------------------------

endmodule
//------------------------------------------------------------------------------

