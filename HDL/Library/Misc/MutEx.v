module MutEx #(parameter N)(
  input  ipClk,
  input  ipReset,

  input  [N-1:0]ipRequest,
  output [N-1:0]opGrant
);
//------------------------------------------------------------------------------

reg        Reset;
reg [N-1:0]Device;

always @(posedge ipClk) begin
  Reset <= ipReset;

  if(Reset) begin
    opGrant <= 0;
    Device  <= 1;
  
  end else begin
    if(ipRequest & Device) begin
      opGrant <= Device;
    end else begin
      opGrant <= 0;
      Device  <= {Device[N-2:0], Device[N-1]};
    end
  end
end
//------------------------------------------------------------------------------

endmodule
//------------------------------------------------------------------------------

