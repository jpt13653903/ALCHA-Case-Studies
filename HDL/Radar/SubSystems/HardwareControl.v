module HardwareControl(
  input ipClk,
  input ipReset,

  output HARDWARE_RD_REGISTERS opRdRegisters,
  input  HARDWARE_WR_REGISTERS ipWrRegisters,

  input  ipI2C_SClk,
  output opI2C_SClk,
  input  ipI2C_Data,
  output opI2C_Data,

  input  ipMasterTrigger,
  output opTxEnable
);
//------------------------------------------------------------------------------

typedef struct{
  logic Request;
  logic Grant;
  logic SClk;
  logic Data;
} I2C_BUS;

I2C_BUS I2C_TxBIM;
I2C_BUS I2C_RxBIM;

assign opI2C_SClk = I2C_TxBIM.SClk | I2C_RxBIM.SClk;
assign opI2C_Data = I2C_TxBIM.Data | I2C_RxBIM.Data;

MutEx #(2) I2C_MutEx(
  .ipClk  (ipClk  ),
  .ipReset(ipReset),

  .ipRequest({I2C_TxBIM.Request, I2C_RxBIM.Request}),
  .opGrant  ({I2C_TxBIM.Grant  , I2C_RxBIM.Grant  })
);
//------------------------------------------------------------------------------

LTC2991 #(
  .Clk_Frequency(2_500_000  ),
  .Baud_kHz     (   50      ),
  .Channel0     (Voltage    ),
  .Channel1     (Voltage    ),
  .Channel2     (Voltage    ),
  .Channel3     (Temperature)
)TxBIM(
  .ipClk       (ipClk      ),
  .ipReset     (ipReset    ),
  .ipQuiet     (~opTxEnable),

  .opRequest   (I2C_TxBIM.Request),
  .ipGrant     (I2C_TxBIM.Grant  ),

  .Error       (opRdRegisters.TxBIM.Error       ),
  .Vcc         (opRdRegisters.TxBIM.Vcc         ),
  .V           (opRdRegisters.TxBIM.V           ),
  .InternalTemp(opRdRegisters.TxBIM.InternalTemp),

  .ipI2C_SClk  (ipI2C_SClk    ),
  .opI2C_SClk  (I2C_TxBIM.SClk),
  .ipI2C_Data  (ipI2C_Data    ),
  .opI2C_Data  (I2C_TxBIM.Data)
);
//------------------------------------------------------------------------------

LTC2991 #(
  .Clk_Frequency(2_500_000   ),
  .Baud_kHz     (   50       ),
  .Channel0     (Voltage     ),
  .Channel1     (Differential),
  .Channel2     (Voltage     ),
  .Channel3     (Temperature )
)RxBIM(
  .ipClk       (ipClk      ),
  .ipReset     (ipReset    ),
  .ipQuiet     (~opTxEnable),

  .opRequest   (I2C_RxBIM.Request),
  .ipGrant     (I2C_RxBIM.Grant  ),

  .Error       (opRdRegisters.RxBIM.Error       ),
  .Vcc         (opRdRegisters.RxBIM.Vcc         ),
  .V           (opRdRegisters.RxBIM.V           ),
  .InternalTemp(opRdRegisters.RxBIM.InternalTemp),

  .ipI2C_SClk  (ipI2C_SClk    ),
  .opI2C_SClk  (I2C_RxBIM.SClk),
  .ipI2C_Data  (ipI2C_Data    ),
  .opI2C_Data  (I2C_RxBIM.Data)
);
//------------------------------------------------------------------------------

TriggerDelay TriggerDelay_PA(
  .ipClk    (ipClk  ),
  .ipReset  (ipReset),

  .ipEnable (ipWrRegisters.TriggerDelay.Enable),
  .ipDelay  (ipWrRegisters.TriggerDelay.Delay ),
  .ipLength (ipWrRegisters.TriggerDelay.Length),

  .ipTrigger(ipMasterTrigger),
  .opTrigger(opTxEnable     )
);
//------------------------------------------------------------------------------

endmodule
//------------------------------------------------------------------------------

