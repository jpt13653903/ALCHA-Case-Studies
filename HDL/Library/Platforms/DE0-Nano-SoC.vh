input        Clock1,
input        Clock2,
input        Clock3,
//------------------------------------------------------------------------------

input  [ 3:0]Switches,
input  [ 1:0]Keys,
output [ 7:0]LEDs,
//------------------------------------------------------------------------------

inout  [35:0]GPIO[1:0],

input        Arduino_nReset,
inout  [15:0]Arduino_IO,
//------------------------------------------------------------------------------

output       ADC_ConvStart,
output       ADC_Clock,
output       ADC_DataIn,
input        ADC_DataOut,
//------------------------------------------------------------------------------

input        HPS_Clock1,
input        HPS_Clock2,
//------------------------------------------------------------------------------

inout        HPS_Key,
inout        HPS_LED,
//------------------------------------------------------------------------------

output       HPS_Ethernet_Tx_Clock,
output [ 3:0]HPS_Ethernet_Tx_Data,
output       HPS_Ethernet_Tx_Enable,

input        HPS_Ethernet_Rx_Clock,
input  [ 3:0]HPS_Ethernet_Rx_Data,
input        HPS_Ethernet_Rx_Valid,

inout        HPS_Ethernet_MDIO,
output       HPS_Ethernet_MDC,
inout        HPS_Ethernet_nInterrupt,
//------------------------------------------------------------------------------

input        HPS_UART_Rx,
output       HPS_UART_Tx,
inout        HPS_UART_nConvUSB,
//------------------------------------------------------------------------------

output [14:0]opHPS_DDR3_Address,
output [ 2:0]opHPS_DDR3_Bank,
output [ 3:0]opHPS_DDR3_DataMask,
inout  [31:0]bpHPS_DDR3_Data,

output       opHPS_DDR3_Clock,
output       opHPS_DDR3_Clock_N,
inout  [ 3:0]bpHPS_DDR3_DataStrobe,
inout  [ 3:0]bpHPS_DDR3_DataStrobe_N,

output       opHPS_DDR3_nColumnAddressStrobe,
output       opHPS_DDR3_ClockEnable,
output       opHPS_DDR3_nChipSelect,
output       opHPS_DDR3_OnDieTermination,
output       opHPS_DDR3_nRowAddressStrobe,
output       opHPS_DDR3_nReset,
output       opHPS_DDR3_nWriteEnable,
input        ipHPS_DDR3_RZQ,
//------------------------------------------------------------------------------

output       HPS_SD_Clock,
inout        HPS_SD_Command,
inout  [ 3:0]HPS_SD_Data,
//------------------------------------------------------------------------------

input        HPS_USB_ClockOut,
inout        HPS_USB_Reset,
inout  [ 7:0]HPS_USB_Data,
input        HPS_USB_Direction,
input        HPS_USB_Next,
output       HPS_USB_Step,
//------------------------------------------------------------------------------

inout        HPS_I2C_Clock,
inout        HPS_I2C_Data,
//------------------------------------------------------------------------------

inout        HPS_G_Sensor_Interrupt,
//------------------------------------------------------------------------------

inout        HPS_LTC_GPIO,
inout        HPS_LTC_I2C_Clock,
inout        HPS_LTC_I2C_Data,
output       HPS_LTC_SPI_Clock,
input        HPS_LTC_SPI_MISO,
output       HPS_LTC_SPI_MOSI,
output       HPS_LTC_SPI_SlaveSelect
//------------------------------------------------------------------------------

