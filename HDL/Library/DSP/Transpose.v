module Transpose(
  input  ipClk,
  input  ipReset,

  input  IQ_PACKET ipInput,
  output opReady,

  output IQ_PACKET opOutput,
  input  ipReady,

  input         ipSDRAM_Clk,

  input         ipSDRAM_WaitRequest,
  output [ 26:0]opSDRAM_Address,
  output [ 31:0]opSDRAM_ByteEnable,
  output [  7:0]opSDRAM_BurstCount,

  output [255:0]opSDRAM_WriteData,
  output        opSDRAM_Write,

  output        opSDRAM_Read,
  input  [255:0]ipSDRAM_ReadData,
  input         ipSDRAM_ReadValid
);
//------------------------------------------------------------------------------

endmodule
//------------------------------------------------------------------------------

