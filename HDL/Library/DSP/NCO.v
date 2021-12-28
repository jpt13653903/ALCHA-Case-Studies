module NCO(
  input  ipClk,
  input  ipReset,

  input  [31:0]ipFrequency,
  output [18:0]opSin,
  output [18:0]opCos
);
//------------------------------------------------------------------------------

reg Reset;
reg [31:0]Phase;

always @(posedge ipClk) begin
  Reset <= ipReset;

  if(Reset) Phase <= 0;
  else      Phase <= Phase + ipFrequency;
end
//------------------------------------------------------------------------------

SinCos #(20) SinCos_Inst(
  .ipClk  (ipClk),
  .ipPhase(Phase[31:11]),
  .opSin  (opSin),
  .opCos  (opCos)
);
//------------------------------------------------------------------------------

endmodule
//------------------------------------------------------------------------------

