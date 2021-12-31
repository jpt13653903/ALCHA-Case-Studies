typedef struct{
  logic [31:0] Version;
  logic [31:0] Date;
  logic [23:0] Time;
  logic [31:0] GitHash;
} VERSION_RD_REGISTERS;
//------------------------------------------------------------------------------

typedef struct{
  logic [31:0]Period;
} MASTERTRIGGER_WR_REGISTERS;
//------------------------------------------------------------------------------

typedef struct{
  logic       Error;
  logic [15:0]Vcc;
  logic [15:0]V[7:0];
  logic [15:0]InternalTemp;
} BIM_RD_REGISTERS;

typedef struct{
  BIM_RD_REGISTERS TxBIM;
  BIM_RD_REGISTERS RxBIM;
} HARDWARE_RD_REGISTERS;

typedef struct{
  logic       Enable;
  logic [31:0]Delay;
  logic [31:0]Length;
} TRIGGERDELAY_WR_REGISTERS;

typedef struct{
  TRIGGERDELAY_WR_REGISTERS TriggerDelay;
} HARDWARE_WR_REGISTERS;
//------------------------------------------------------------------------------

typedef struct{
  TRIGGERDELAY_WR_REGISTERS SynthTrigger;
  logic [ 3:0]CP_CurrentSetting;
  logic       RampOn;
  logic       Update;
  logic [11:0]Integer;
  logic [24:0]Fraction;
  logic [15:0]DeviationWord_0; // 150 MHz in 1 ms
  logic [ 3:0]DeviationOffset_0;
  logic [19:0]StepWord_0;
  logic [15:0]DeviationWord_1; // 150 MHz in 50 μs
  logic [ 3:0]DeviationOffset_1;
  logic [19:0]StepWord_1;
} WAVEFORM_WR_REGISTERS;

typedef struct{
  logic Busy;
} WAVEFORM_RD_REGISTERS;
//------------------------------------------------------------------------------

typedef struct{
  TRIGGERDELAY_WR_REGISTERS PacketTrigger;
} RECEIVER_WR_REGISTERS;

typedef struct{
  logic [12:0]DebugWrAddress;
} RECEIVER_RD_REGISTERS;
//------------------------------------------------------------------------------

typedef struct{
  logic [12:0]Queue_NumItems;
  logic [31:0]Filter_WrAddress;
} PROCESSOR_RD_REGISTERS;

typedef struct{
  logic [17:0]Filter_Alpha;
} PROCESSOR_WR_REGISTERS;
//------------------------------------------------------------------------------

typedef struct{
  VERSION_RD_REGISTERS   Version;
  HARDWARE_RD_REGISTERS  Hardware;
  WAVEFORM_RD_REGISTERS  Waveform;
  RECEIVER_RD_REGISTERS  Receiver;
  PROCESSOR_RD_REGISTERS Processor;
} RD_REGISTERS;

typedef struct{
  MASTERTRIGGER_WR_REGISTERS MasterTrigger;
  HARDWARE_WR_REGISTERS      Hardware;
  WAVEFORM_WR_REGISTERS      Waveform;
  RECEIVER_WR_REGISTERS      Receiver;
  PROCESSOR_WR_REGISTERS     Processor;
} WR_REGISTERS;
//------------------------------------------------------------------------------

module RegistersDecoder #(
  parameter           Page
)(
  input               ipClk,
  input               ipReset,

  input  RD_REGISTERS ipRdRegisters,
  output WR_REGISTERS opWrRegisters,

  input  [15:0]       ipAddress,
  input  [ 3:0]       ipByteEnable,

  input  [31:0]       ipWriteData,
  input               ipWrite,

  input               ipRead,
  output [31:0]       opReadData,
  output              opReadValid
);
//------------------------------------------------------------------------------

wire AddressValid = (ipAddress[15:12] == Page);
wire Write = AddressValid & ipWrite;
wire Read  = AddressValid & ipRead;
//------------------------------------------------------------------------------

reg Reset;

always @(posedge ipClk) begin
  Reset <= ipReset;
  //----------------------------------------------------------------------------

  case(ipAddress[11:0])
    12'h000: opReadData <= ipRdRegisters.Version.Version;
    12'h001: opReadData <= ipRdRegisters.Version.Date;
    12'h002: opReadData <= ipRdRegisters.Version.Time;
    12'h003: opReadData <= ipRdRegisters.Version.GitHash;

    12'h010: opReadData <= opWrRegisters.MasterTrigger.Period;

    12'h020: opReadData <= ipRdRegisters.Hardware.TxBIM.Error;
    12'h021: opReadData <= ipRdRegisters.Hardware.TxBIM.Vcc;
    12'h022: opReadData <= ipRdRegisters.Hardware.TxBIM.V[0];
    12'h023: opReadData <= ipRdRegisters.Hardware.TxBIM.V[1];
    12'h024: opReadData <= ipRdRegisters.Hardware.TxBIM.V[2];
    12'h025: opReadData <= ipRdRegisters.Hardware.TxBIM.V[3];
    12'h026: opReadData <= ipRdRegisters.Hardware.TxBIM.V[4];
    12'h027: opReadData <= ipRdRegisters.Hardware.TxBIM.V[5];
    12'h028: opReadData <= ipRdRegisters.Hardware.TxBIM.V[6];
    12'h029: opReadData <= ipRdRegisters.Hardware.TxBIM.V[7];
    12'h02A: opReadData <= ipRdRegisters.Hardware.TxBIM.InternalTemp;

    12'h030: opReadData <= ipRdRegisters.Hardware.RxBIM.Error;
    12'h031: opReadData <= ipRdRegisters.Hardware.RxBIM.Vcc;
    12'h032: opReadData <= ipRdRegisters.Hardware.RxBIM.V[0];
    12'h033: opReadData <= ipRdRegisters.Hardware.RxBIM.V[1];
    12'h034: opReadData <= ipRdRegisters.Hardware.RxBIM.V[2];
    12'h035: opReadData <= ipRdRegisters.Hardware.RxBIM.V[3];
    12'h036: opReadData <= ipRdRegisters.Hardware.RxBIM.V[4];
    12'h037: opReadData <= ipRdRegisters.Hardware.RxBIM.V[5];
    12'h038: opReadData <= ipRdRegisters.Hardware.RxBIM.V[6];
    12'h039: opReadData <= ipRdRegisters.Hardware.RxBIM.V[7];
    12'h03A: opReadData <= ipRdRegisters.Hardware.RxBIM.InternalTemp;

    12'h040: opReadData <= opWrRegisters.Hardware.TriggerDelay.Enable;
    12'h041: opReadData <= opWrRegisters.Hardware.TriggerDelay.Delay;
    12'h042: opReadData <= opWrRegisters.Hardware.TriggerDelay.Length;

    12'h050: opReadData <= opWrRegisters.Waveform.SynthTrigger.Enable;
    12'h051: opReadData <= opWrRegisters.Waveform.SynthTrigger.Delay;
    12'h052: opReadData <= opWrRegisters.Waveform.SynthTrigger.Length;

    12'h060: opReadData <= opWrRegisters.Waveform.CP_CurrentSetting;
    12'h061: opReadData <= opWrRegisters.Waveform.RampOn;
    12'h062: opReadData <= opWrRegisters.Waveform.Update;
    12'h063: opReadData <= ipRdRegisters.Waveform.Busy;
    12'h064: opReadData <= opWrRegisters.Waveform.Integer;
    12'h065: opReadData <= opWrRegisters.Waveform.Fraction;
    12'h066: opReadData <= opWrRegisters.Waveform.DeviationWord_0;
    12'h067: opReadData <= opWrRegisters.Waveform.DeviationOffset_0;
    12'h068: opReadData <= opWrRegisters.Waveform.StepWord_0;
    12'h069: opReadData <= opWrRegisters.Waveform.DeviationWord_1;
    12'h06A: opReadData <= opWrRegisters.Waveform.DeviationOffset_1;
    12'h06B: opReadData <= opWrRegisters.Waveform.StepWord_1;

    12'h070: opReadData <= opWrRegisters.Receiver.PacketTrigger.Enable;
    12'h071: opReadData <= opWrRegisters.Receiver.PacketTrigger.Delay;
    12'h072: opReadData <= opWrRegisters.Receiver.PacketTrigger.Length;
    12'h073: opReadData <= ipRdRegisters.Receiver.DebugWrAddress;

    12'h080: opReadData <= ipRdRegisters.Processor.Queue_NumItems;
    12'h081: opReadData <= opWrRegisters.Processor.Filter_Alpha;
    12'h082: opReadData <= ipRdRegisters.Processor.Filter_WrAddress;

    default: opReadData <= 32'hX;
  endcase

  opReadValid <= Read;
  //----------------------------------------------------------------------------

  if(Reset) begin
    opWrRegisters.MasterTrigger.Period          <= 0;

    opWrRegisters.Hardware.TriggerDelay.Enable  <= 0;
    opWrRegisters.Hardware.TriggerDelay.Delay   <= 0;
    opWrRegisters.Hardware.TriggerDelay.Length  <= 0;

    opWrRegisters.Waveform.SynthTrigger.Enable  <= 0;
    opWrRegisters.Waveform.SynthTrigger.Delay   <= 0;
    opWrRegisters.Waveform.SynthTrigger.Length  <= 0;

    opWrRegisters.Waveform.CP_CurrentSetting    <= 7;
    opWrRegisters.Waveform.RampOn               <= 0;
    opWrRegisters.Waveform.Update               <= 0;
    opWrRegisters.Waveform.Integer              <= 47; // 9.5 GHz
    opWrRegisters.Waveform.Fraction             <= 25'h_100_0000;
    opWrRegisters.Waveform.DeviationWord_0      <=  1007; // 150 MHz in 1 ms
    opWrRegisters.Waveform.DeviationOffset_0    <=     0;
    opWrRegisters.Waveform.StepWord_0           <= 50000;
    opWrRegisters.Waveform.DeviationWord_1      <= 20133; // 150 MHz in 50 μs
    opWrRegisters.Waveform.DeviationOffset_1    <=     0;
    opWrRegisters.Waveform.StepWord_1           <=  2500;

    opWrRegisters.Receiver.PacketTrigger.Enable <= 0;
    opWrRegisters.Receiver.PacketTrigger.Delay  <= 0;
    opWrRegisters.Receiver.PacketTrigger.Length <= 0;

    opWrRegisters.Processor.Filter_Alpha        <= 0;
  //----------------------------------------------------------------------------

  end else if(Write) case(ipAddress[11:0])
    12'h010: opWrRegisters.MasterTrigger.Period          <= ipWriteData;

    12'h040: opWrRegisters.Hardware.TriggerDelay.Enable  <= ipWriteData;
    12'h041: opWrRegisters.Hardware.TriggerDelay.Delay   <= ipWriteData;
    12'h042: opWrRegisters.Hardware.TriggerDelay.Length  <= ipWriteData;

    12'h050: opWrRegisters.Waveform.SynthTrigger.Enable  <= ipWriteData;
    12'h051: opWrRegisters.Waveform.SynthTrigger.Delay   <= ipWriteData;
    12'h052: opWrRegisters.Waveform.SynthTrigger.Length  <= ipWriteData;

    12'h060: opWrRegisters.Waveform.CP_CurrentSetting    <= ipWriteData;
    12'h061: opWrRegisters.Waveform.RampOn               <= ipWriteData;
    12'h062: opWrRegisters.Waveform.Update               <= ipWriteData;
    12'h064: opWrRegisters.Waveform.Integer              <= ipWriteData;
    12'h065: opWrRegisters.Waveform.Fraction             <= ipWriteData;
    12'h066: opWrRegisters.Waveform.DeviationWord_0      <= ipWriteData;
    12'h067: opWrRegisters.Waveform.DeviationOffset_0    <= ipWriteData;
    12'h068: opWrRegisters.Waveform.StepWord_0           <= ipWriteData;
    12'h069: opWrRegisters.Waveform.DeviationWord_1      <= ipWriteData;
    12'h06A: opWrRegisters.Waveform.DeviationOffset_1    <= ipWriteData;
    12'h06B: opWrRegisters.Waveform.StepWord_1           <= ipWriteData;

    12'h070: opWrRegisters.Receiver.PacketTrigger.Enable <= ipWriteData;
    12'h071: opWrRegisters.Receiver.PacketTrigger.Delay  <= ipWriteData;
    12'h072: opWrRegisters.Receiver.PacketTrigger.Length <= ipWriteData;

    12'h081: opWrRegisters.Processor.Filter_Alpha        <= ipWriteData;

    default:;
  endcase
end
//------------------------------------------------------------------------------

endmodule
//------------------------------------------------------------------------------

