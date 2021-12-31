module Radar(
  `include "../Library/Platforms/DE0-Nano-SoC.vh"
);
//------------------------------------------------------------------------------

wire [3:0]DipSwitch = Switches;
//------------------------------------------------------------------------------

wire Synth_SPI_SClk     ; assign Arduino_IO[ 0] = Synth_SPI_SClk;
wire Synth_SPI_nCS      ; assign Arduino_IO[ 1] = Synth_SPI_nCS;
wire Synth_SPI_SDIO     ; assign Arduino_IO[ 2] = Synth_SPI_SDIO;
wire Synth_SPI_SyncIO   ; assign Arduino_IO[ 3] = Synth_SPI_SyncIO;
wire Synth_SPI_IO_Update; assign Arduino_IO[ 4] = Synth_SPI_IO_Update;

wire Synth_DR_Control   ; assign Arduino_IO[ 9] = Synth_DR_Control;
wire Synth_DR_Hold      ; assign Arduino_IO[10] = Synth_DR_Hold;
wire Synth_DR_Over      =        Arduino_IO[11];
//------------------------------------------------------------------------------

wire ADC_nCS  ; assign Arduino_IO[5] = ADC_nCS;
wire ADC_SClk ; assign Arduino_IO[6] = ADC_SClk;
wire ADC_Data =        Arduino_IO[7];
//------------------------------------------------------------------------------

wire TxEnable; assign Arduino_IO[8] = TxEnable;
//------------------------------------------------------------------------------

wire [35:0]Debug; assign GPIO[0] = Debug;
//------------------------------------------------------------------------------

wire I2C_SClk_enable = ~Hardware_I2C_SClk;
wire I2C_Data_enable = ~Hardware_I2C_Data;

wire I2C_SClk = Arduino_IO[15];
wire I2C_Data = Arduino_IO[14];

assign Arduino_IO[15] = I2C_SClk_enable ? 1'b0 : 1'bZ;
assign Arduino_IO[14] = I2C_Data_enable ? 1'b0 : 1'bZ;
//------------------------------------------------------------------------------

wire ResetKey = ~Keys[0];
//------------------------------------------------------------------------------

wire DspClock;
wire ControlClock;

localparam DspClock_Frequency     = 120e6;
localparam ControlClock_Frequency = 2.5e6;

wire PLL_Locked;

PLL_CycloneV #(
  .Frequency0("120.0 MHz"),
  .Frequency1("2.5 MHz"  )
)PLL(
  .Clk   (Clock1      ),
  .Reset (ResetKey    ),
  .Locked(PLL_Locked  ),
  .Out0  (DspClock    ),
  .Out1  (ControlClock)
);
//------------------------------------------------------------------------------

wire HPS_Reset;

DelayedReset #(ControlClock_Frequency, 1) HPS_Reset_Inst(
  ControlClock,
  ResetKey | ~PLL_Locked,
  HPS_Reset
);
//------------------------------------------------------------------------------

wire HPS_FPGA_Reset;
wire MasterReset;

DelayedReset #(ControlClock_Frequency, 100) MasterReset_Inst(
  ControlClock,
  HPS_FPGA_Reset | ResetKey | ~PLL_Locked,
  MasterReset
);
//------------------------------------------------------------------------------

