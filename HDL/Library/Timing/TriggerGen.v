module TriggerGen(
  input        ipClk,
  input        ipReset,

  input  [31:0]ipPeriod,
  output       opTrigger
);
//------------------------------------------------------------------------------

reg       Reset;
reg [31:0]Count;

always @(posedge ipClk) begin
  Reset <= ipReset;

  if(Reset) begin
    opTrigger <= 0;
    Count     <= 0;

  end else begin
    if(Count >= ipPeriod) begin
      Count     <= 1;
      opTrigger <= 1;
    end else begin
      Count     <= Count + 1;
      opTrigger <= 0;
    end
  end
end
//------------------------------------------------------------------------------

endmodule
//------------------------------------------------------------------------------

