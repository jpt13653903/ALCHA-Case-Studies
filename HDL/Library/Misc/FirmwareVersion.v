/*------------------------------------------------------------------------------

Autogenerated by FirmwareVersion.tcl
------------------------------------------------------------------------------*/

module FirmwareVersion #(
  parameter Major,
  parameter Minor
)(
  output [31:0]opVersion,
  output [31:0]opDate,
  output [23:0]opTime,
  output [31:0]opGitHash
);
//------------------------------------------------------------------------------

assign opVersion[31:16] = Major;
assign opVersion[15: 0] = Minor;

assign opDate    = 32'h_2021_12_30;
assign opTime    = 24'h_12_51_32;
assign opGitHash = 32'h_5160e616;
//------------------------------------------------------------------------------

endmodule
//------------------------------------------------------------------------------
