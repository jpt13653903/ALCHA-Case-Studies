module FIFO #(
  parameter Length
)(
  input  ipClk,
  input  ipReset,

  output [$clog2(Length)-1:0]opNumItems,

  input  PACKET ipInput,
  output opReady,

  output PACKET opOutput,
  input  ipReady
);
//------------------------------------------------------------------------------

endmodule
//------------------------------------------------------------------------------

