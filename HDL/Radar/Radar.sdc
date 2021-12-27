#-------------------------------------------------------------------------------

create_clock -name Clock1 -period 20 [get_ports Clock1]
create_clock -name Clock2 -period 20 [get_ports Clock2]
create_clock -name Clock3 -period 20 [get_ports Clock3]

create_clock -name HPS_I2C_Clock     -period 1000   [get_ports HPS_I2C_Clock]
create_clock -name HPS_LTC_I2C_Clock -period 1000   [get_ports HPS_LTC_I2C_Clock]
create_clock -name HPS_USB_ClockOut  -period 16.666 [get_ports HPS_USB_ClockOut]

create_clock -name {altera_reserved_tck} -period 40 {altera_reserved_tck}

set_clock_groups -asynchronous                \
                 -group {Clock1 Clock3}       \
                 -group {Clock2}              \
                 -group {altera_reserved_tck} \
                 -group {HPS_I2C_Clock}       \
                 -group {HPS_LTC_I2C_Clock}   \
                 -group {HPS_USB_ClockOut}

derive_pll_clocks -create_base_clocks -use_net_name             
derive_clock_uncertainty     
#-------------------------------------------------------------------------------

set_input_delay  -clock altera_reserved_tck -clock_fall 3 [get_ports altera_reserved_tdi]
set_input_delay  -clock altera_reserved_tck -clock_fall 3 [get_ports altera_reserved_tms]
set_output_delay -clock altera_reserved_tck             3 [get_ports altera_reserved_tdo]
#-------------------------------------------------------------------------------

set_false_path -to * -from [get_ports Switches*]
set_false_path -to * -from [get_ports Keys*]
set_false_path -from * -to [get_ports LEDs*]

set_false_path -to * -from [get_ports GPIO*]
set_false_path -from * -to [get_ports GPIO*]

set_false_path -to * -from [get_ports Arduino_nReset]
set_false_path -to * -from [get_ports Arduino_IO*]
set_false_path -from * -to [get_ports Arduino_IO*]

set_false_path -from * -to [get_ports ADC_ConvStart]
set_false_path -from * -to [get_ports ADC_Clock]
set_false_path -from * -to [get_ports ADC_DataIn]
set_false_path -to * -from [get_ports ADC_DataOut]

set_false_path -from * -to [get_ports HPS*]
set_false_path -to * -from [get_ports HPS*]
#-------------------------------------------------------------------------------

