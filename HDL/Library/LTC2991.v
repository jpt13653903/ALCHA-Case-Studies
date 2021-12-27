module LTC2991 #(
  parameter    Config
)(
  input        ipClk,
  input        ipReset,

  output       opRequest,
  input        ipGrant,

  output       Error,
  output [15:0]Vcc,
  output [15:0]V[7:0],
  output [15:0]InternalTemp,

  input  ipI2C_SClk,
  output opI2C_SClk,
  input  ipI2C_Data,
  output opI2C_Data
);
//------------------------------------------------------------------------------

endmodule
//------------------------------------------------------------------------------

