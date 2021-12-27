module PLL_CycloneV #(
  parameter Frequency0,
  parameter Frequency1
)(
  input  Clk,
  input  Reset,
  output Locked,

  output Out0,
  output Out1
);
//------------------------------------------------------------------------------

altera_pll #(
  .fractional_vco_multiplier("false"   ),
  .reference_clock_frequency("50.0 MHz"),
  .operation_mode           ("direct"  ),
  .number_of_clocks         (2         ),
  .output_clock_frequency0  (Frequency0),
  .phase_shift0             ("0 ps"    ),
  .duty_cycle0              (50        ),
  .output_clock_frequency1  (Frequency1),
  .phase_shift1             ("0 ps"    ),
  .duty_cycle1              (50        ),
  .output_clock_frequency2  ("0 MHz"   ),
  .phase_shift2             ("0 ps"    ),
  .duty_cycle2              (50        ),
  .output_clock_frequency3  ("0 MHz"   ),
  .phase_shift3             ("0 ps"    ),
  .duty_cycle3              (50        ),
  .output_clock_frequency4  ("0 MHz"   ),
  .phase_shift4             ("0 ps"    ),
  .duty_cycle4              (50        ),
  .output_clock_frequency5  ("0 MHz"   ),
  .phase_shift5             ("0 ps"    ),
  .duty_cycle5              (50        ),
  .output_clock_frequency6  ("0 MHz"   ),
  .phase_shift6             ("0 ps"    ),
  .duty_cycle6              (50        ),
  .output_clock_frequency7  ("0 MHz"   ),
  .phase_shift7             ("0 ps"    ),
  .duty_cycle7              (50        ),
  .output_clock_frequency8  ("0 MHz"   ),
  .phase_shift8             ("0 ps"    ),
  .duty_cycle8              (50        ),
  .output_clock_frequency9  ("0 MHz"   ),
  .phase_shift9             ("0 ps"    ),
  .duty_cycle9              (50        ),
  .output_clock_frequency10 ("0 MHz"   ),
  .phase_shift10            ("0 ps"    ),
  .duty_cycle10             (50        ),
  .output_clock_frequency11 ("0 MHz"   ),
  .phase_shift11            ("0 ps"    ),
  .duty_cycle11             (50        ),
  .output_clock_frequency12 ("0 MHz"   ),
  .phase_shift12            ("0 ps"    ),
  .duty_cycle12             (50        ),
  .output_clock_frequency13 ("0 MHz"   ),
  .phase_shift13            ("0 ps"    ),
  .duty_cycle13             (50        ),
  .output_clock_frequency14 ("0 MHz"   ),
  .phase_shift14            ("0 ps"    ),
  .duty_cycle14             (50        ),
  .output_clock_frequency15 ("0 MHz"   ),
  .phase_shift15            ("0 ps"    ),
  .duty_cycle15             (50        ),
  .output_clock_frequency16 ("0 MHz"   ),
  .phase_shift16            ("0 ps"    ),
  .duty_cycle16             (50        ),
  .output_clock_frequency17 ("0 MHz"   ),
  .phase_shift17            ("0 ps"    ),
  .duty_cycle17             (50        ),
  .pll_type                 ("General" ),
  .pll_subtype              ("General" )

)PLL(
  .refclk(Clk         ),
  .rst   (Reset       ),
  .locked(Locked      ),

  .outclk({Out1, Out0}),

  .fbclk (1'b0        )
);
//------------------------------------------------------------------------------

endmodule
//------------------------------------------------------------------------------

