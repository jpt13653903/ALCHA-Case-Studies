typedef enum {Voltage, Differential, Temperature} LTC2991_TYPE;
//------------------------------------------------------------------------------

module LTC2991 #(
  parameter Clk_Frequency,
  parameter Baud_kHz = 50,
  parameter LTC2991_TYPE Channel0 = Voltage,
  parameter LTC2991_TYPE Channel1 = Voltage,
  parameter LTC2991_TYPE Channel2 = Voltage,
  parameter LTC2991_TYPE Channel3 = Voltage
)(
  input        ipClk,
  input        ipReset,
  input        ipQuiet,

  output       opRequest,
  input        ipGrant,

  output       Error,
  output [15:0]Vcc,
  output [15:0]V[7:0],
  output [15:0]InternalTemp,

  input  ipI2C_SClk,
  output opI2C_SClk,
  input  ipI2C_Data,
  output opI2C_Data
);
//------------------------------------------------------------------------------

wire [31:0]Config;

always @(*) begin
  case(Channel0)
    Differential: Config[ 3: 0] <= 1;
    Temperature : Config[ 3: 0] <= 2;
    default     : Config[ 3: 0] <= 0;
  endcase
  case(Channel1)
    Differential: Config[ 7: 4] <= 1;
    Temperature : Config[ 7: 4] <= 2;
    default     : Config[ 7: 4] <= 0;
  endcase
  case(Channel2)
    Differential: Config[11: 8] <= 1;
    Temperature : Config[11: 8] <= 2;
    default     : Config[11: 8] <= 0;
  endcase
  case(Channel3)
    Differential: Config[15:12] <= 1;
    Temperature : Config[15:12] <= 2;
    default     : Config[15:12] <= 0;
  endcase
  Config[31:16] <= 0;
end
//------------------------------------------------------------------------------

// OR these together to get the command
localparam Start = 4'b1000;
localparam R_nW  = 4'b0100;
localparam Ack   = 4'b0010;
localparam Stop  = 4'b0001;

reg [3:0]Command;
reg [7:0]TxData;
reg [7:0]RxData;

reg I2C_Go;
reg I2C_Busy;

I2C #(
  .Clk_Frequency(Clk_Frequency),
  .Baud_kHz     (Baud_kHz     )
)I2C_Inst(
  .ipClk    (ipClk     ),
  .ipReset  (ipReset   ),

  .ipQuiet  (ipQuiet   ),
  .opError  (Error     ),

  .ipTxData (TxData    ),
  .opRxData (RxData    ),
  .ipCommand(Command   ),
  .ipGo     (I2C_Go    ),
  .opBusy   (I2C_Busy  ),

  .ipSClk   (ipI2C_SClk),
  .opSClk   (opI2C_SClk),
  .ipData   (ipI2C_Data),
  .opData   (opI2C_Data)
);
//------------------------------------------------------------------------------

// TODO Implement using the I2C module

endmodule
//------------------------------------------------------------------------------

