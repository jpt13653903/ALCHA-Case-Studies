module WhatchDog #(
  parameter Clk_Frequency,
  parameter Timeout_ms,
  parameter EdgeSensitive // Boolean
)(
  input      ipClk,
  input      ipReset,

  input      ipKick,
  output reg opError
);
//------------------------------------------------------------------------------

localparam Timeout_Cycles = Clk_Frequency * Timeout_ms / 1000;
localparam N = $clog2(Timeout_Cycles);

reg        Reset;
reg [N-1:0]Count;
reg [  1:0]KickEdge;

always @(posedge ipClk) begin
  KickEdge <= {KickEdge[0], ipKick};
  if(EdgeSensitive) Reset <= (KickEdge == 2'b01);
  else              Reset <= ipKick;

  if(Reset) begin
    Count   <= Timeout_Cycles - 1;
    opError <= 0;

  end else begin
    if(|Count) Count <= Count - 1;
    else       opError <= 1;
  end
end
//------------------------------------------------------------------------------

endmodule
//------------------------------------------------------------------------------

