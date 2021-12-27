module DelayedReset #(
  parameter integer Clk_Frequency, 
  parameter integer Delay_ms
)(
  input  ipClk,
  input  ipReset,
  output opResult
);
//------------------------------------------------------------------------------

localparam Delay_cycles = Clk_Frequency * Delay_ms / 1000;
localparam N            = $clog2(Delay_cycles + 1);

reg        Reset;
reg [N-1:0]Count;

always @(posedge ipClk) begin
  Reset <= ipReset;

  if(Reset) begin
    Count    <= 0;
    opResult <= 1;

  end else begin
    if(Count != Delay_cycles) Count++;
    else opResult <= 0;
  end
end
//------------------------------------------------------------------------------

endmodule
//------------------------------------------------------------------------------

