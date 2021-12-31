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

ADF4159 #(
  .Clk_Frequency(2_500_000),
  .Baud_kHz     (    1_000)
)SynthInst(
  .ipClk              (ipClk  ),
  .ipReset            (ipReset),

  .ipCP_CurrentSetting(ipWrRegisters.CP_CurrentSetting),
  .ipRampOn           (ipWrRegisters.RampOn           ),

  .ipInteger          (ipWrRegisters.Integer ),
  .ipFraction         (ipWrRegisters.Fraction),

  .ipDeviationWord_0  (ipWrRegisters.DeviationWord_0  ),
  .ipDeviationOffset_0(ipWrRegisters.DeviationOffset_0),
  .ipStepWord_0       (ipWrRegisters.StepWord_0       ),
                                                      
  .ipDeviationWord_1  (ipWrRegisters.DeviationWord_1  ),
  .ipDeviationOffset_1(ipWrRegisters.DeviationOffset_1),
  .ipStepWord_1       (ipWrRegisters.StepWord_1       ),

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

