`include "Platform/Platform.vh"
//------------------------------------------------------------------------------

`include "SubSystems/SystemController.vh"
//------------------------------------------------------------------------------

RD_REGISTERS RdRegisters;
WR_REGISTERS WrRegisters;

RegistersDecoder #(0) Registers(
  .ipClk        (ControllerClock         ),
  .ipReset      (MasterReset             ),

  .ipRdRegisters(RdRegisters             ),
  .opWrRegisters(WrRegisters             ),

  .ipAddress    (LightWeigtBus_Address   ),
  .ipByteEnable (LightWeigtBus_ByteEnable),

  .ipWriteData  (LightWeigtBus_WriteData ),
  .ipWrite      (LightWeigtBus_Write     ),

  .ipRead       (LightWeigtBus_Read      ),
  .opReadData   (LightWeigtBus_ReadData  ),
  .opReadValid  (LightWeigtBus_ReadValid )
);
//------------------------------------------------------------------------------

FirmwareVersion #(1, 0) Version(
  .opVersion(RdRegisters.Version.Version),
  .opDate   (RdRegisters.Version.Date   ),
  .opTime   (RdRegisters.Version.Time   ),
  .opGitHash(RdRegisters.Version.GitHash)
);
//------------------------------------------------------------------------------

wire MasterTrigger;

TriggerGen MasterTriggerGen(
  .ipClk    (ControlClock                    ),
  .ipReset  (MasterReset                     ),

  .ipPeriod (WrRegisters.MasterTrigger.Period),
  .opTrigger(MasterTrigger                   )
);
//------------------------------------------------------------------------------

wire Hardware_I2C_SClk;
wire Hardware_I2C_Data;

HardwareControl Hardware(
  .ipClk          (ControlClock        ),
  .ipReset        (MasterReset         ),

  .opRdRegisters  (RdRegisters.Hardware),
  .ipWrRegisters  (WrRegisters.Hardware),

  .ipI2C_SClk     (I2C_SClk            ),
  .opI2C_SClk     (Hardware_I2C_SClk   ),
  .ipI2C_Data     (I2C_Data            ),
  .opI2C_Data     (Hardware_I2C_Data   ),

  .ipMasterTrigger(MasterTrigger       ),
  .opTxEnable     (TxEnable            )
);
//------------------------------------------------------------------------------

WaveformGenerator Waveform(
  .ipClk          (ControlClock        ),
  .ipReset        (MasterReset         ),

  .opRdRegisters  (RdRegisters.Waveform),
  .ipWrRegisters  (WrRegisters.Waveform),

  .ipMasterTrigger(MasterTrigger       ),

  .opSClk         (Synth_SPI_SClk      ),
  .opnCS          (Synth_SPI_nCS       ),
  .opSDIO         (Synth_SPI_SDIO      ),
  .opSyncIO       (Synth_SPI_SyncIO    ),
  .opIO_Update    (Synth_SPI_IO_Update ),

  .opDR_Control   (Synth_DR_Control    ),
  .opDR_Hold      (Synth_DR_Hold       ),
  .ipDR_Over      (Synth_DR_Over       )
);
//------------------------------------------------------------------------------

PACKET Receiver_Packet;

ReceiverAbstraction Receiver(
  .ipDspClk         (DspClock              ),
  .ipControlClk     (ControlClock          ),
  .ipReset          (MasterReset           ),

  .opRdRegisters    (RdRegisters.Receiver  ),
  .ipWrRegisters    (WrRegisters.Receiver  ),

  .ipMasterTrigger  (MasterTrigger         ),

  .opPacket         (Receiver_Packet       ),

  .opSClk           (ADC_SClk              ),
  .opnCS            (ADC_nCS               ),
  .ipData           (ADC_Data              ),

  .opDebug_Address  (StreamBuffer_Address  ),
  .opDebug_WriteData(StreamBuffer_WriteData),
  .opDebug_Write    (StreamBuffer_Write    )
);
//------------------------------------------------------------------------------

RadarProcessor Processor(
  .ipClk              (DspClock             ),
  .ipReset            (MasterReset          ),

  .opRdRegisters      (RdRegisters.Processor),
  .ipWrRegisters      (WrRegisters.Processor),

  .ipPacket           (Receiver_Packet      ),

  .ipSDRAM_Clk        (HPS_Clk              ),

  .ipSDRAM_WaitRequest(SDRAM_WaitRequest    ),
  .opSDRAM_Address    (SDRAM_Address        ),
  .opSDRAM_ByteEnable (SDRAM_ByteEnable     ),
  .opSDRAM_BurstCount (SDRAM_BurstCount     ),

  .opSDRAM_WriteData  (SDRAM_WriteData      ),
  .opSDRAM_Write      (SDRAM_Write          ),

  .opSDRAM_Read       (SDRAM_Read           ),
  .ipSDRAM_ReadData   (SDRAM_ReadData       ),
  .ipSDRAM_ReadValid  (SDRAM_ReadValid      )
);
//------------------------------------------------------------------------------

endmodule
//------------------------------------------------------------------------------

