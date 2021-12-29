module ADS7056(
  input        ipClk,
  input        ipReset,

  output       opSClk,
  output       opnCS,
  input        ipData,

  output [13:0]opData,
  output       opValid
);
//------------------------------------------------------------------------------

reg Reset;

reg [13:0] Shift;
reg [ 5:0] Count;

always @(posedge ipClk) begin
  Reset <= ipReset;

  if(Reset) begin
    opnCS   <= 1;
    opSClk  <= 0;
    opValid <= 0;

    Shift   <= 'hX;
    Count   <= 0;

  end else begin
    if(Count == 47) Count <= 0;
    else            Count <= Count + 1;

    if     (Count ==  0) opnCS  <= 0;
    else if(Count <= 36) opSClk <= ~opSClk;
    else if(Count == 37) opnCS  <= 1;
    else                 opSClk <= 0;

    if(opSClk == 0) Shift <= {Shift[12:0], ipData};

    if(Count == 32) begin
      opData  <= Shift;
      opValid <= 1;
    end else begin
      opValid <= 0;
    end
  end
end
//------------------------------------------------------------------------------

endmodule
//------------------------------------------------------------------------------

