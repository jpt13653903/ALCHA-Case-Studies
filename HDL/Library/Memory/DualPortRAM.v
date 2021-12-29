module DualPortRAM #(
  parameter Width,
  parameter Depth,
  parameter DeviceFamily = "Cyclone V",
  parameter RamBlockType = "M10K"
)(
  input  ipClk,
  input  ipReset,

  input  [$clog2(Depth)-1:0]ipWrAddress,
  input  [       Width -1:0]ipWrData,
  input                     ipWrEnable,

  input  [$clog2(Depth)-1:0]ipRdAddress,
  input                     ipRdEnable,
  output [       Width -1:0]opRdData
);
//------------------------------------------------------------------------------

localparam AddressWidth = $clog2(Depth);
//------------------------------------------------------------------------------

altsyncram #(
  .address_aclr_b                    ("NONE"        ),
  .address_reg_b                     ("CLOCK1"      ),
  .clock_enable_input_a              ("NORMAL"      ),
  .clock_enable_input_b              ("NORMAL"      ),
  .clock_enable_output_a             ("BYPASS"      ),
  .clock_enable_output_b             ("BYPASS"      ),
  .indata_reg_b                      ("CLOCK1"      ),
  .intended_device_family            (DeviceFamily  ),
  .lpm_type                          ("altsyncram"  ),
  .maximum_depth                     (1024          ),
  .numwords_a                        (Depth         ),
  .numwords_b                        (Depth         ),
  .operation_mode                    ("DUAL_PORT"   ),
  .outdata_aclr_b                    ("NONE"        ),
  .outdata_reg_b                     ("UNREGISTERED"),
  .power_up_uninitialized            ("FALSE"       ),
  .ram_block_type                    (RamBlockType  ),
  .read_during_write_mode_mixed_ports("DONT_CARE"   ),
  .widthad_a                         (AddressWidth  ),
  .widthad_b                         (AddressWidth  ),
  .width_a                           (Width         ),
  .width_b                           (Width         ),
  .width_byteena_a                   (1             ),
  .width_byteena_b                   (1             )
)RAM(
  .clock0   (ipClk    ),
  .clocken0 (1        ),
  .address_a(WrAddress),
  .data_a   (WrData   ),
  .wren_a   (WrEnable ),

  .clock1   (ipClk    ),
  .clocken1 (RdEnable ),
  .address_b(RdAddress),
  .q_b      (RdData   )
);
//------------------------------------------------------------------------------

endmodule
//------------------------------------------------------------------------------

