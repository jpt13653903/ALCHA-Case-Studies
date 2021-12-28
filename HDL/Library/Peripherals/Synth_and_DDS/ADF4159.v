module ADF4159(
  input       ipClk,
  input       ipReset,

  input [ 3:0]ipCP_CurrentSetting,
  input       ipRampOn,

  input [11:0]ipInteger,
  input [24:0]ipFraction,

  input [15:0]ipDeviationWord_0,
  input [ 3:0]ipDeviationOffset_0,
  input [19:0]ipStepWord_0,

  input [15:0]ipDeviationWord_1,
  input [ 3:0]ipDeviationOffset_1,
  input [19:0]ipStepWord_1,

  input       ipUseRefMul2,
  input [ 4:0]ipRefCounter,
  input       ipUseRefDiv2,

  input [11:0]ipClk1Divider,
  input [11:0]ipClk2Divider_0,
  input [11:0]ipClk2Divider_1,

  input       ipUpdate,
  output      opBusy,

  input       ipTrigger,

  output      opSPI_SClk,
  output      opSPI_Data,
  output      opSPI_Latch,
  output      opTrigger,
  input       ipMuxOut
);
//------------------------------------------------------------------------------

endmodule
//------------------------------------------------------------------------------

