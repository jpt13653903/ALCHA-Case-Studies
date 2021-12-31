module WaveformGenerator(
  input  ipClk,
  input  ipReset,

  output WAVEFORM_RD_REGISTERS opRdRegisters,
  input  WAVEFORM_WR_REGISTERS ipWrRegisters,

  input  ipMasterTrigger,

  output opSClk,
  output opnCS,
  output opSDIO,
  output opSyncIO,
  output opIO_Update,

  output opDR_Control,
  output opDR_Hold,
  input  ipDR_Over
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

AD9915 SynthInst(
  .ipClk           (ipClk  ),
  .ipReset         (ipReset),

  .ipFreqLowerLimit(ipWrRegisters.FreqLowerLimit),
  .ipFreqUpperLimit(ipWrRegisters.FreqUpperLimit),
  .ipStepUp        (ipWrRegisters.StepUp        ),
  .ipStepDown      (ipWrRegisters.StepDown      ),
  .ipSlopeUp       (1                           ),
  .ipSlopeDown     (1                           ),

  .ipUpdate        (ipWrRegisters.Update),
  .opBusy          (opRdRegisters.Busy  ),

  .opSClk          (opSClk     ),
  .opnCS           (opnCS      ),
  .opSDIO          (opSDIO     ),
  .opSyncIO        (opSyncIO   ),
  .opIO_Update     (opIO_Update),

  .ipTrigger       (SynthTrigger_Output),
  .opDR_Control    (opDR_Control       ),
  .opDR_Hold       (opDR_Hold          ),
  .ipDR_Over       (ipDR_Over          )
);
//------------------------------------------------------------------------------

endmodule
//------------------------------------------------------------------------------

