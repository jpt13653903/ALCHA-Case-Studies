module DelayedReset #(
  parameter integer Clk_Frequency, 
  parameter integer Delay_ms
)(
  input  ipClk,
  input  ipReset,
  output opResult
);
//------------------------------------------------------------------------------

localparam Delay_cycles = (Clk_Frequency / 1000) * Delay_ms;
localparam N            = $clog2(Delay_cycles + 1);

reg        Reset;
reg [N-1:0]Count;

always @(posedge ipClk) begin
  Reset <= ipReset;

  if(Reset) begin
    Count    <= 0;
    opResult <= 1;

  end else begin
    if(Count != Delay_cycles) Count <= Count + 1;
    else opResult <= 0;
  end
end
//------------------------------------------------------------------------------

endmodule
//------------------------------------------------------------------------------

