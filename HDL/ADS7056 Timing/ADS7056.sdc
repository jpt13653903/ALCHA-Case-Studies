#-------------------------------------------------------------------------------

create_clock -name ipClk -period  8.333 [get_ports ipClk]
create_generated_clock -name opSClk_Reg -source [get_ports ipClk] -master_clock ipClk -divide_by 2 [get_registers opSClk~reg0]
create_generated_clock -name opSClk -source [get_registers opSClk~reg0] -divide_by 1 [get_ports opSClk]

derive_pll_clocks -create_base_clocks -use_net_name             
derive_clock_uncertainty     
#-------------------------------------------------------------------------------

set_false_path -to * -from [get_ports ipReset]
#-------------------------------------------------------------------------------

set_output_delay -min -clock opSClk -3 [get_ports opnCS]
set_output_delay -max -clock opSClk  0 [get_ports opnCS]

set_input_delay -min -clock opSClk  2.5 [get_ports ipSDO]
set_input_delay -max -clock opSClk 10.0 [get_ports ipSDO]

set_multicycle_path -from [get_ports ipSDO] -to * -setup 2
set_multicycle_path -from [get_ports ipSDO] -to * -hold  1
#-------------------------------------------------------------------------------

set_false_path -from * -to [get_ports opData*]
set_false_path -from * -to [get_ports opValid]
#-------------------------------------------------------------------------------

