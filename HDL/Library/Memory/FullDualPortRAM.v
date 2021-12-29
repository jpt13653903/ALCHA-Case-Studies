module FullDualPortRAM #(
  parameter Width,
  parameter Depth,
  parameter DeviceFamily = "Cyclone V",
  parameter RamBlockType = "M10K"
)(
  input  ipClk,
  input  ipReset,

  input                      ClkEnable_A,
  input  [$clog2(Depth)-1:0] Address_A,
  input  [       Width -1:0] WrData_A,
  input                      WrEnable_A,
  output [       Width -1:0] RdData_A,

  input                      ClkEnable_B,
  input  [$clog2(Depth)-1:0] Address_B,
  input  [       Width -1:0] WrData_B,
  input                      WrEnable_B,
  output [       Width -1:0] RdData_B
);
//------------------------------------------------------------------------------

localparam AddressWidth = $clog2(Depth);
//------------------------------------------------------------------------------

altsyncram #(
  .address_aclr_b                    ("NONE"                ),
  .address_reg_b                     ("CLOCK1"              ),
  .clock_enable_input_a              ("NORMAL"              ),
  .clock_enable_input_b              ("NORMAL"              ),
  .clock_enable_output_a             ("BYPASS"              ),
  .clock_enable_output_b             ("BYPASS"              ),
  .indata_reg_b                      ("CLOCK1"              ),
  .intended_device_family            (DeviceFamily          ),
  .lpm_type                          ("altsyncram"          ),
  .maximum_depth                     (1024                  ),
  .numwords_a                        (Depth                 ),
  .numwords_b                        (Depth                 ),
  .operation_mode                    ("BIDIR_DUAL_PORT"     ),
  .outdata_aclr_a                    ("NONE"                ),
  .outdata_aclr_b                    ("NONE"                ),
  .outdata_reg_a                     ("UNREGISTERED"        ),
  .outdata_reg_b                     ("UNREGISTERED"        ),
  .power_up_uninitialized            ("FALSE"               ),
  .ram_block_type                    (RamBlockType          ),
  .read_during_write_mode_mixed_ports("DONT_CARE"           ),
  .read_during_write_mode_port_a     ("NEW_DATA_NO_NBE_READ"),
  .read_during_write_mode_port_b     ("NEW_DATA_NO_NBE_READ"),
  .widthad_a                         (AddressWidth          ),
  .widthad_b                         (AddressWidth          ),
  .width_a                           (Width                 ),
  .width_b                           (Width                 ),
  .width_byteena_a                   (1                     ),
  .width_byteena_b                   (1                     ),
  .wrcontrol_wraddress_reg_b         ("CLOCK1"              )
)RAM(
  .clock0   (ipClk      ),
  .clocken0 (ClkEnable_A),
  .address_a(Address_A  ),
  .data_a   (WrData_A   ),
  .wren_a   (WrEnable_A ),
  .q_a      (RdData_A   ),

  .clock1   (ipClk      ),
  .clocken1 (ClkEnable_B),
  .address_b(Address_B  ),
  .data_b   (WrData_B   ),
  .wren_b   (WrEnable_B ),
  .q_b      (RdData_B   )
);
//------------------------------------------------------------------------------

endmodule
//------------------------------------------------------------------------------

