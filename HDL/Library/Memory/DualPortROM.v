module DualPortROM #(
  parameter Width,
  parameter Depth,
  parameter DeviceFamily = "Cyclone V",
  parameter RamBlockType = "M10K",
  parameter MIF_File     = "DualPortROM.mif"
)(
  input  ipClk,
  input  ipReset,

  input                      ipClkEnable_A,
  input  [$clog2(Depth)-1:0] ipAddress_A,
  output [       Width -1:0] opData_A,

  input                      ipClkEnable_B,
  input  [$clog2(Depth)-1:0] ipAddress_B,
  output [       Width -1:0] opData_B
);
//------------------------------------------------------------------------------

localparam AddressWidth = $clog2(Depth);
//------------------------------------------------------------------------------

altsyncram #(
  .address_aclr_b                    ("NONE"           ),
  .address_reg_b                     ("CLOCK1"         ),
  .clock_enable_input_a              ("NORMAL"         ),
  .clock_enable_input_b              ("NORMAL"         ),
  .clock_enable_output_a             ("BYPASS"         ),
  .clock_enable_output_b             ("BYPASS"         ),
  .indata_reg_b                      ("CLOCK1"         ),
  .init_file                         (MIF_File         ),
  .intended_device_family            (DeviceFamily     ),
  .lpm_type                          ("altsyncram"     ),
  .maximum_depth                     (1024             ),
  .numwords_a                        (Depth            ),
  .numwords_b                        (Depth            ),
  .operation_mode                    ("BIDIR_DUAL_PORT"),
  .outdata_aclr_a                    ("NONE"           ),
  .outdata_aclr_b                    ("NONE"           ),
  .outdata_reg_a                     ("UNREGISTERED"   ),
  .outdata_reg_b                     ("UNREGISTERED"   ),
  .power_up_uninitialized            ("FALSE"          ),
  .ram_block_type                    (RamBlockType     ),
  .read_during_write_mode_mixed_ports("DONT_CARE"      ),
  .widthad_a                         (AddressWidth     ),
  .widthad_b                         (AddressWidth     ),
  .width_a                           (Width            ),
  .width_b                           (Width            ),
  .width_byteena_a                   (1                ),
  .width_byteena_b                   (1                ),
  .wrcontrol_wraddress_reg_b         ("CLOCK1"         )
)ROM(
  .clock0   (ipClk        ),
  .clocken0 (ipClkEnable_A),
  .address_a(ipAddress_A  ),
  .q_a      (opData_A     ),

  .clock1   (ipClk        ),
  .clocken1 (ipClkEnable_B),
  .address_b(ipAddress_B  ),
  .q_b      (opData_B     )
);
//------------------------------------------------------------------------------

endmodule
//------------------------------------------------------------------------------

