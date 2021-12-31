typedef struct{
  logic       SoP;
  logic       EoP;
  logic [31:0]Data;
  logic       Valid;
} DATA_PACKET;

typedef struct{
  logic       SoP;
  logic       EoP;
  logic [31:0]I;
  logic [31:0]Q;
  logic       Valid;
} IQ_PACKET;
//------------------------------------------------------------------------------

module RadarProcessor(
  input ipClk,
  input ipReset,

  output PROCESSOR_RD_REGISTERS opRdRegisters,
  input  PROCESSOR_WR_REGISTERS ipWrRegisters,

  input  PACKET ipPacket,

  input         ipSDRAM_Clk,

  input         ipSDRAM_WaitRequest,
  output [ 26:0]opSDRAM_Address,
  output [ 31:0]opSDRAM_ByteEnable,
  output [  7:0]opSDRAM_BurstCount,

  output [255:0]opSDRAM_WriteData,
  output        opSDRAM_Write,

  output        opSDRAM_Read,
  input  [255:0]ipSDRAM_ReadData,
  input         ipSDRAM_ReadValid,

  output PACKET      FIFO_Output,

  output DATA_PACKET RangeWindow_Output,
  output             RangeWindow_Ready,

  output IQ_PACKET   RangeFFT_Output,
  output             RangeFFT_Ready,

  output IQ_PACKET   CornerTurn_Output,
  output             CornerTurn_Ready,

  output IQ_PACKET   DopplerWindow_Output,
  output             DopplerWindow_Ready,

  output IQ_PACKET   DopplerFFT_Output,
  output             DopplerFFT_Ready,

  output             Filter_Ready
);
//------------------------------------------------------------------------------

FIFO #(14, 8192) Queue(
  .ipClk         (ipClk  ),
  .ipReset       (ipReset),

  .opNumItems    (opRdRegisters.Queue_NumItems),

  .ipInput_SoP   (ipPacket.SoP  ),
  .ipInput_EoP   (ipPacket.EoP  ),
  .ipInput_Data  (ipPacket.Data ),
  .ipInput_Valid (ipPacket.Valid),

  .opOutput_SoP  (FIFO_Output.SoP  ),
  .opOutput_EoP  (FIFO_Output.EoP  ),
  .opOutput_Data (FIFO_Output.Data ),
  .opOutput_Valid(FIFO_Output.Valid),
  .ipOutput_Ready(RangeWindow_Ready)
);
//------------------------------------------------------------------------------

Window #(
  .InWidth     (  14             ),
  .OutWidth    (  32             ),
  .Length      (2500             ),
  .Complex     (0                ),
  .DeviceFamily("Cyclone V"      ),
  .RamBlockType("M10K"           ),
  .MIF_File    ("RangeWindow.mif")

)RangeWindow(
  .ipClk         (ipClk  ),
  .ipReset       (ipReset),

  .ipInput_SoP   (FIFO_Output.SoP  ),
  .ipInput_EoP   (FIFO_Output.EoP  ),
  .ipInput_I     (FIFO_Output.Data ),
  .ipInput_Valid (FIFO_Output.Valid),
  .opInput_Ready (RangeWindow_Ready),

  .opOutput_SoP  (RangeWindow_Output.SoP  ),
  .opOutput_EoP  (RangeWindow_Output.EoP  ),
  .opOutput_I    (RangeWindow_Output.Data ),
  .opOutput_Valid(RangeWindow_Output.Valid),
  .ipOutput_Ready(RangeFFT_Ready          )
);
//------------------------------------------------------------------------------

RealFFT RangeFFT(
  .ipClk   (ipClk  ),
  .ipReset (ipReset),

  .ipInput (RangeWindow_Output),
  .opReady (RangeFFT_Ready    ),

  .opOutput(RangeFFT_Output ),
  .ipReady (CornerTurn_Ready)
);
//------------------------------------------------------------------------------

wire        CornerTurn_WaitRequest;
wire [ 26:0]CornerTurn_Address;
wire [ 31:0]CornerTurn_ByteEnable;
wire [  7:0]CornerTurn_BurstCount;

wire [255:0]CornerTurn_WriteData;
wire        CornerTurn_Write;

wire        CornerTurn_Read;
wire [255:0]CornerTurn_ReadData;
wire        CornerTurn_ReadValid;

Transpose CornerTurn(
  .ipClk   (ipClk  ),
  .ipReset (ipReset),

  .ipInput (RangeFFT_Output ),
  .opReady (CornerTurn_Ready),

  .opOutput(CornerTurn_Output  ),
  .ipReady (DopplerWindow_Ready),

  .ipSDRAM_WaitRequest(CornerTurn_WaitRequest),
  .opSDRAM_Address    (CornerTurn_Address    ),
  .opSDRAM_ByteEnable (CornerTurn_ByteEnable ),
  .opSDRAM_BurstCount (CornerTurn_BurstCount ),

  .opSDRAM_WriteData  (CornerTurn_WriteData  ),
  .opSDRAM_Write      (CornerTurn_Write      ),

  .opSDRAM_Read       (CornerTurn_Read       ),
  .ipSDRAM_ReadData   (CornerTurn_ReadData   ),
  .ipSDRAM_ReadValid  (CornerTurn_ReadValid  )
);
//------------------------------------------------------------------------------

Window #(
  .InWidth     ( 32                ),
  .OutWidth    ( 32                ),
  .Length      (128                ),
  .Complex     (1                  ),
  .DeviceFamily("Cyclone V"        ),
  .RamBlockType("M10K"             ),
  .MIF_File    ("DopplerWindow.mif")

)DopplerWindow(
  .ipClk         (ipClk  ),
  .ipReset       (ipReset),

  .ipInput_SoP   (CornerTurn_Output.SoP  ),
  .ipInput_EoP   (CornerTurn_Output.EoP  ),
  .ipInput_I     (CornerTurn_Output.I    ),
  .ipInput_Q     (CornerTurn_Output.Q    ),
  .ipInput_Valid (CornerTurn_Output.Valid),
  .opInput_Ready (DopplerWindow_Ready    ),

  .opOutput_SoP  (DopplerWindow_Output.SoP  ),
  .opOutput_EoP  (DopplerWindow_Output.EoP  ),
  .opOutput_I    (DopplerWindow_Output.I    ),
  .opOutput_Q    (DopplerWindow_Output.Q    ),
  .opOutput_Valid(DopplerWindow_Output.Valid),
  .ipOutput_Ready(DopplerFFT_Ready          )
);
//------------------------------------------------------------------------------

FFT DopplerFFT(
  .ipClk   (ipClk  ),
  .ipReset (ipReset),

  .ipInput (DopplerWindow_Output),
  .opReady (DopplerFFT_Ready    ),

  .opOutput(DopplerFFT_Output),
  .ipReady (Filter_Ready     )
);
//------------------------------------------------------------------------------

wire        Filter_WaitRequest;
wire [ 26:0]Filter_Address;
wire [ 31:0]Filter_ByteEnable;
wire [  7:0]Filter_BurstCount;

wire [255:0]Filter_WriteData;
wire        Filter_Write;

wire        Filter_Read;
wire [255:0]Filter_ReadData;
wire        Filter_ReadValid;

AlphaFilter Filter(
  .ipClk              (ipClk                         ),
  .ipReset            (ipReset                       ),

  .ipAlpha            (ipWrRegisters.Filter_Alpha    ),
  .opWrAddress        (opRdRegisters.Filter_WrAddress),

  .ipInput            (DopplerFFT_Output             ),
  .opReady            (Filter_Ready                  ),

  .ipSDRAM_WaitRequest(Filter_WaitRequest            ),
  .opSDRAM_Address    (Filter_Address                ),
  .opSDRAM_ByteEnable (Filter_ByteEnable             ),
  .opSDRAM_BurstCount (Filter_BurstCount             ),

  .opSDRAM_WriteData  (Filter_WriteData              ),
  .opSDRAM_Write      (Filter_Write                  ),

  .opSDRAM_Read       (Filter_Read                   ),
  .ipSDRAM_ReadData   (Filter_ReadData               ),
  .ipSDRAM_ReadValid  (Filter_ReadValid              )
);
//------------------------------------------------------------------------------

AvalonArbiter #(256, 27) SDRAM_Arbiter(
  .ipClk                (ipSDRAM_Clk           ),
  .ipReset              (ipReset               ),

  .opMaster1_WaitRequest(CornerTurn_WaitRequest),
  .ipMaster1_Address    (CornerTurn_Address    ),
  .ipMaster1_ByteEnable (CornerTurn_ByteEnable ),
  .ipMaster1_BurstCount (CornerTurn_BurstCount ),

  .ipMaster1_WriteData  (CornerTurn_WriteData  ),
  .ipMaster1_Write      (CornerTurn_Write      ),

  .ipMaster1_Read       (CornerTurn_Read       ),
  .opMaster1_ReadData   (CornerTurn_ReadData   ),
  .opMaster1_ReadValid  (CornerTurn_ReadValid  ),

  .opMaster2_WaitRequest(Filter_WaitRequest    ),
  .ipMaster2_Address    (Filter_Address        ),
  .ipMaster2_ByteEnable (Filter_ByteEnable     ),
  .ipMaster2_BurstCount (Filter_BurstCount     ),

  .ipMaster2_WriteData  (Filter_WriteData      ),
  .ipMaster2_Write      (Filter_Write          ),

  .ipMaster2_Read       (Filter_Read           ),
  .opMaster2_ReadData   (Filter_ReadData       ),
  .opMaster2_ReadValid  (Filter_ReadValid      ),

  .ipAvalon_WaitRequest (ipSDRAM_WaitRequest   ),
  .opAvalon_Address     (opSDRAM_Address       ),
  .opAvalon_ByteEnable  (opSDRAM_ByteEnable    ),
  .opAvalon_BurstCount  (opSDRAM_BurstCount    ),

  .opAvalon_WriteData   (opSDRAM_WriteData     ),
  .opAvalon_Write       (opSDRAM_Write         ),

  .opAvalon_Read        (opSDRAM_Read          ),
  .ipAvalon_ReadData    (ipSDRAM_ReadData      ),
  .ipAvalon_ReadValid   (ipSDRAM_ReadValid     )
);
//------------------------------------------------------------------------------

endmodule
//------------------------------------------------------------------------------

