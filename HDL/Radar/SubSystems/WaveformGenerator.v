module WaveformGenerator(
  input  ipClk,
  input  ipReset,

  output WAVEFORM_RD_REGISTERS opRdRegisters,
  input  WAVEFORM_WR_REGISTERS ipWrRegisters,

  input  ipMasterTrigger,

  output opSPI_SClk,
  output opSPI_Data,
  output opSPI_Latch,
  output opTrigger,
  input  ipMuxOut
);
//------------------------------------------------------------------------------

wire SynthTrigger_Output;

TriggerDelay SynthTrigger(
  .ipClk    (ipClk  ),
  .ipReset  (ipReset),

  .ipEnable (ipWrRegisters.SynthTrigger.Enable),
  .ipDelay  (ipWrRegisters.SynthTrigger.Delay ),
  .ipLength (ipWrRegisters.SynthTrigger.Length),

  .ipTrigger(ipMasterTrigger    ),
  .opTrigger(SynthTrigger_Output)
);
//------------------------------------------------------------------------------

ADF4159 SynthInst(
  .ipClk              (ipClk  ),
  .ipReset            (ipReset),

  .ipCP_CurrentSetting(ipWrRegisters.CP_CurrentSetting),
  .ipRampOn           (ipWrRegisters.RampOn           ),

  .ipInteger          (47           ), // 9.5 GHz
  .ipFraction         (25'h_100_0000),

  .ipDeviationWord_0  ( 1007), // 150 MHz in 1 ms
  .ipDeviationOffset_0(    0),
  .ipStepWord_0       (50000),

  .ipDeviationWord_1  (20133), // 150 MHz in 50 μs
  .ipDeviationOffset_1(    0),
  .ipStepWord_1       ( 2500),

  .ipUseRefMul2       (    0),
  .ipRefCounter       (    1),
  .ipUseRefDiv2       (    0),

  .ipClk1Divider      (    1),
  .ipClk2Divider_0    (    2),
  .ipClk2Divider_1    (    2),

  .ipUpdate           (ipWrRegisters.Update),
  .opBusy             (opRdRegisters.Busy  ),

  .ipTrigger          (SynthTrigger_Output),

  .opSPI_SClk         (opSPI_SClk ),
  .opSPI_Data         (opSPI_Data ),
  .opSPI_Latch        (opSPI_Latch),
  .opTrigger          (opTrigger  ),
  .ipMuxOut           (ipMuxOut   )
);
//------------------------------------------------------------------------------

endmodule
//------------------------------------------------------------------------------

