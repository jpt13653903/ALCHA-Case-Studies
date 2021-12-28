module TriggerDelay(
  input       ipClk,
  input       ipReset,

  input       ipEnable,
  input [31:0]ipDelay,
  input [31:0]ipLength,

  input       ipTrigger,
  output      opTrigger
);
//------------------------------------------------------------------------------

reg Reset;

reg [31:0]DelayCount;
reg [31:0]LengthCount;
reg       Trigger_1;
//------------------------------------------------------------------------------

always @(posedge ipClk) begin
  Reset     <= ipReset;
  Trigger_1 <= ipTrigger;
  //----------------------------------------------------------------------------

  if(Reset) begin
    opTrigger   <= 0;
    DelayCount  <= 0;
    LengthCount <= 0;
  //----------------------------------------------------------------------------

  end else begin
    if( {Trigger_1, ipTrigger} == 1'b01) DelayCount <= ipDelay;
    else if(DelayCount > 0)              DelayCount <= DelayCount - 1;

    if(opTrigger) begin
      if(LengthCount == 1) opTrigger <= 0;
      LengthCount <= LengthCount - 1;

    end else if(DelayCount == 1) begin
      opTrigger   <= ipEnable;
      LengthCount <= ipLength;
    end
  end
end
//------------------------------------------------------------------------------

endmodule
//------------------------------------------------------------------------------

