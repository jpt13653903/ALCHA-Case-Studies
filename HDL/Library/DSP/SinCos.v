module SinCos #(parameter N = 20)( // Number of iterations, max 20
  input            ipClk,
  input      [20:0]ipPhase, // (-π, π)
  output reg [18:0]opSin,   // (-1, 1)
  output reg [18:0]opCos    // (-1, 1)
);
//------------------------------------------------------------------------------

// Slightly smaller than "prod(cos(atan(2.^(-(0:19))))) * 2^20" to ensure
// that the answer is never full-scale negative
localparam K = 21'd_636_743;
//------------------------------------------------------------------------------

reg [20:0]x[0:N]; reg [20:0]y[0:N];
reg [21:0]a[0:N]; reg [21:0]A[0:N];
//------------------------------------------------------------------------------

always @(posedge ipClk) begin
  case(ipPhase[20:19])
    2'b00: begin x[0] <=  K; y[0] <=  0; a[0] <= 22'h_00_0000; end //   0
    2'b01: begin x[0] <=  0; y[0] <=  K; a[0] <= 22'h_08_0000; end //  pi/2
    2'b10: begin x[0] <= -K; y[0] <=  0; a[0] <= 22'h_30_0000; end // -pi
    2'b11: begin x[0] <=  0; y[0] <= -K; a[0] <= 22'h_38_0000; end // -pi/2
  endcase

  A[0] <= {ipPhase[20], ipPhase};
end
//------------------------------------------------------------------------------

// round(atan(2^(-(0:19))) / pi * (2^20))
integer T[0:19];
assign  T[ 0] = 262144;
assign  T[ 1] = 154753;
assign  T[ 2] =  81767;
assign  T[ 3] =  41506;
assign  T[ 4] =  20834;
assign  T[ 5] =  10427;
assign  T[ 6] =   5215;
assign  T[ 7] =   2608;
assign  T[ 8] =   1304;
assign  T[ 9] =    652;
assign  T[10] =    326;
assign  T[11] =    163;
assign  T[12] =     81;
assign  T[13] =     41;
assign  T[14] =     20;
assign  T[15] =     10;
assign  T[16] =      5;
assign  T[17] =      3;
assign  T[18] =      1;
assign  T[19] =      1;
//------------------------------------------------------------------------------

genvar n;

generate
  for(n = 0; n < N; n++) begin: Gen_Iterations
    always @(posedge ipClk) begin
      if($signed(A[n]) >= $signed(a[n])) begin
        x[n+1] <= x[n] - {{n{y[n][20]}}, y[n][20:n]};
        y[n+1] <= y[n] + {{n{x[n][20]}}, x[n][20:n]};
        a[n+1] <= a[n] + T[n];

      end else begin
        x[n+1] <= x[n] + {{n{y[n][20]}}, y[n][20:n]};
        y[n+1] <= y[n] - {{n{x[n][20]}}, x[n][20:n]};
        a[n+1] <= a[n] - T[n];
      end

      A[n+1] <= A[n];
    end
  end
endgenerate

assign opSin = y[N][20:2];
assign opCos = x[N][20:2];
//------------------------------------------------------------------------------

endmodule
//------------------------------------------------------------------------------

