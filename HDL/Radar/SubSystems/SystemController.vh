wire        HPS_Clk;

wire        LightWeigtBus_WaitRequest = 0;
wire [ 31:0]LightWeigtBus_ReadData;
wire        LightWeigtBus_ReadValid;
wire [  0:0]LightWeigtBus_BurstCount;
wire [ 31:0]LightWeigtBus_WriteData;
wire [ 15:0]LightWeigtBus_Address;
wire        LightWeigtBus_Write;
wire        LightWeigtBus_Read;
wire [  3:0]LightWeigtBus_ByteEnable;
wire        LightWeigtBus_DebugAccess;

wire [ 26:0]SDRAM_Address;
wire [  7:0]SDRAM_BurstCount;
wire        SDRAM_WaitRequest;
wire [255:0]SDRAM_ReadData;
wire        SDRAM_ReadValid;
wire        SDRAM_Read;
wire [255:0]SDRAM_WriteData;
wire [ 31:0]SDRAM_ByteEnable;
wire        SDRAM_Write;

wire [ 12:0]StreamBuffer_Address;
wire        StreamBuffer_Write;
wire [ 15:0]StreamBuffer_ReadData;
wire [ 15:0]StreamBuffer_WriteData;
wire        StreamBuffer_ReadValid = 1;
//------------------------------------------------------------------------------

SoC_System SystemController(
  .hps_warm_reset_req_reset_n     (~HPS_Reset                     ), // input 
  .hps_cold_reset_req_reset_n     (~HPS_Reset                     ), // input 
  .hps_debug_reset_req_reset_n    (~HPS_Reset                     ), // input 

  .hps_clk_out_clk                (HPS_Clk                        ), // output
  .hps_reset_out_reset            (HPS_FPGA_Reset                 ), // output

  .hps_io_hps_io_emac1_inst_TX_CLK(HPS_Ethernet_Tx_Clock          ), // output
  .hps_io_hps_io_emac1_inst_TXD0  (HPS_Ethernet_Tx_Data[0]        ), // output
  .hps_io_hps_io_emac1_inst_TXD1  (HPS_Ethernet_Tx_Data[1]        ), // output
  .hps_io_hps_io_emac1_inst_TXD2  (HPS_Ethernet_Tx_Data[2]        ), // output
  .hps_io_hps_io_emac1_inst_TXD3  (HPS_Ethernet_Tx_Data[3]        ), // output
  .hps_io_hps_io_emac1_inst_TX_CTL(HPS_Ethernet_Tx_Enable         ), // output
  .hps_io_hps_io_emac1_inst_RX_CLK(HPS_Ethernet_Rx_Clock          ), // input 
  .hps_io_hps_io_emac1_inst_RXD0  (HPS_Ethernet_Rx_Data[0]        ), // input 
  .hps_io_hps_io_emac1_inst_RXD1  (HPS_Ethernet_Rx_Data[1]        ), // input 
  .hps_io_hps_io_emac1_inst_RXD2  (HPS_Ethernet_Rx_Data[2]        ), // input 
  .hps_io_hps_io_emac1_inst_RXD3  (HPS_Ethernet_Rx_Data[3]        ), // input 
  .hps_io_hps_io_emac1_inst_RX_CTL(HPS_Ethernet_Rx_Valid          ), // input 
  .hps_io_hps_io_emac1_inst_MDIO  (HPS_Ethernet_MDIO              ), // inout 
  .hps_io_hps_io_emac1_inst_MDC   (HPS_Ethernet_MDC               ), // output
  .hps_io_hps_io_gpio_inst_GPIO35 (HPS_Ethernet_nInterrupt        ), // inout 

  .hps_io_hps_io_sdio_inst_CLK    (HPS_SD_Clock                   ), // output
  .hps_io_hps_io_sdio_inst_CMD    (HPS_SD_Command                 ), // inout 
  .hps_io_hps_io_sdio_inst_D0     (HPS_SD_Data[0]                 ), // inout 
  .hps_io_hps_io_sdio_inst_D1     (HPS_SD_Data[1]                 ), // inout 
  .hps_io_hps_io_sdio_inst_D2     (HPS_SD_Data[2]                 ), // inout 
  .hps_io_hps_io_sdio_inst_D3     (HPS_SD_Data[3]                 ), // inout 

  .hps_io_hps_io_usb1_inst_D0     (HPS_USB_Data[0]                ), // inout 
  .hps_io_hps_io_usb1_inst_D1     (HPS_USB_Data[1]                ), // inout 
  .hps_io_hps_io_usb1_inst_D2     (HPS_USB_Data[2]                ), // inout 
  .hps_io_hps_io_usb1_inst_D3     (HPS_USB_Data[3]                ), // inout 
  .hps_io_hps_io_usb1_inst_D4     (HPS_USB_Data[4]                ), // inout 
  .hps_io_hps_io_usb1_inst_D5     (HPS_USB_Data[5]                ), // inout 
  .hps_io_hps_io_usb1_inst_D6     (HPS_USB_Data[6]                ), // inout 
  .hps_io_hps_io_usb1_inst_D7     (HPS_USB_Data[7]                ), // inout 
  .hps_io_hps_io_usb1_inst_CLK    (HPS_USB_ClockOut               ), // input 
  .hps_io_hps_io_usb1_inst_STP    (HPS_USB_Step                   ), // output
  .hps_io_hps_io_usb1_inst_DIR    (HPS_USB_Direction              ), // input 
  .hps_io_hps_io_usb1_inst_NXT    (HPS_USB_Next                   ), // input 

  .hps_io_hps_io_gpio_inst_GPIO40 (HPS_LTC_GPIO                   ), // inout 
  .hps_io_hps_io_i2c1_inst_SCL    (HPS_LTC_I2C_Clock              ), // inout 
  .hps_io_hps_io_i2c1_inst_SDA    (HPS_LTC_I2C_Data               ), // inout 
  .hps_io_hps_io_spim1_inst_CLK   (HPS_LTC_SPI_Clock              ), // output
  .hps_io_hps_io_spim1_inst_MOSI  (HPS_LTC_SPI_MOSI               ), // output
  .hps_io_hps_io_spim1_inst_MISO  (HPS_LTC_SPI_MISO               ), // input 
  .hps_io_hps_io_spim1_inst_SS0   (HPS_LTC_SPI_SlaveSelect        ), // output

  .hps_io_hps_io_uart0_inst_RX    (HPS_UART_Rx                    ), // input 
  .hps_io_hps_io_uart0_inst_TX    (HPS_UART_Tx                    ), // output
  .hps_io_hps_io_gpio_inst_GPIO09 (HPS_UART_nConvUSB              ), // inout 

  .hps_io_hps_io_i2c0_inst_SDA    (HPS_I2C_Data                   ), // inout 
  .hps_io_hps_io_i2c0_inst_SCL    (HPS_I2C_Clock                  ), // inout 

  .hps_io_hps_io_gpio_inst_GPIO53 (HPS_LED                        ), // inout 
  .hps_io_hps_io_gpio_inst_GPIO54 (HPS_Key                        ), // inout 
  .hps_io_hps_io_gpio_inst_GPIO61 (HPS_G_Sensor_Interrupt         ), // inout 

  .memory_mem_reset_n             (opHPS_DDR3_nReset              ), // output
  .memory_mem_ck                  (opHPS_DDR3_Clock               ), // output
  .memory_mem_ck_n                (opHPS_DDR3_Clock_N             ), // output
  .memory_mem_cke                 (opHPS_DDR3_ClockEnable         ), // output
  .memory_mem_cs_n                (opHPS_DDR3_nChipSelect         ), // output
  .memory_mem_ba                  (opHPS_DDR3_Bank                ), // output
  .memory_mem_a                   (opHPS_DDR3_Address             ), // output
  .memory_mem_dm                  (opHPS_DDR3_DataMask            ), // output
  .memory_mem_ras_n               (opHPS_DDR3_nRowAddressStrobe   ), // output
  .memory_mem_cas_n               (opHPS_DDR3_nColumnAddressStrobe), // output
  .memory_mem_we_n                (opHPS_DDR3_nWriteEnable        ), // output
  .memory_mem_dq                  (bpHPS_DDR3_Data                ), // inout 
  .memory_mem_dqs                 (bpHPS_DDR3_DataStrobe          ), // inout 
  .memory_mem_dqs_n               (bpHPS_DDR3_DataStrobe_N        ), // inout 
  .memory_mem_odt                 (opHPS_DDR3_OnDieTermination    ), // output
  .memory_oct_rzqin               (ipHPS_DDR3_RZQ                 ), // input 

  .light_weight_bus_clk_clk       (ControllerClock                ), // input 
  .light_weight_bus_reset_reset   (MasterReset                    ), // input 
  .light_weight_bus_waitrequest   (LightWeigtBus_WaitRequest      ), // input 
  .light_weight_bus_readdata      (LightWeigtBus_ReadData         ), // input 
  .light_weight_bus_readdatavalid (LightWeigtBus_ReadValid        ), // input 
  .light_weight_bus_burstcount    (LightWeigtBus_BurstCount       ), // output
  .light_weight_bus_writedata     (LightWeigtBus_WriteData        ), // output
  .light_weight_bus_address       (LightWeigtBus_Address          ), // output
  .light_weight_bus_write         (LightWeigtBus_Write            ), // output
  .light_weight_bus_read          (LightWeigtBus_Read             ), // output
  .light_weight_bus_byteenable    (LightWeigtBus_ByteEnable       ), // output
  .light_weight_bus_debugaccess   (LightWeigtBus_DebugAccess      ), // output

  .sdram_address                  (SDRAM_Address                  ), // input 
  .sdram_burstcount               (SDRAM_BurstCount               ), // input 
  .sdram_waitrequest              (SDRAM_WaitRequest              ), // output
  .sdram_readdata                 (SDRAM_ReadData                 ), // output
  .sdram_readdatavalid            (SDRAM_ReadValid                ), // output
  .sdram_read                     (SDRAM_Read                     ), // input 
  .sdram_writedata                (SDRAM_WriteData                ), // input 
  .sdram_byteenable               (SDRAM_ByteEnable               ), // input 
  .sdram_write                    (SDRAM_Write                    ), // input 

  .streambuffer_clk_clk           (DspClock                       ), // input 
  .streambuffer_reset_reset       (MasterReset                    ), // input 
  .streambuffer_address           (StreamBuffer_Address           ), // input 
  .streambuffer_chipselect        (1'b1                           ), // input 
  .streambuffer_clken             (1'b1                           ), // input 
  .streambuffer_write             (StreamBuffer_Write             ), // input 
  .streambuffer_readdata          (StreamBuffer_ReadData          ), // output
  .streambuffer_writedata         (StreamBuffer_WriteData         ), // input 
  .streambuffer_byteenable        (2'b11                          )  // input 
);
//------------------------------------------------------------------------------

