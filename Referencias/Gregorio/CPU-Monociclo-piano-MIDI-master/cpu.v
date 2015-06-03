module cpu(input wire clk, 
							reset, 
							input wire [7:0]d0_e,
							d1_e,
							d2_e,
							d_audio,//corresponde con el dispositivo 3 de entrada
							output wire [7:0]d0_s,
							d1_s,
							d2_s,
							d3_s,
							/////////////////////////////////////////////
							input	[1:0]		CLOCK_24,				//	24 MHz
							input	[1:0]		CLOCK_27,				//	27 MHz
							input				CLOCK_50,				//	50 MHz
							input [3:0]			KEY,
							input [9:0]			SW,
							////////////////////////	I2C		////////////////////////////////
							inout				I2C_SDAT,				//	I2C Data
							output			I2C_SCLK,				//	I2C Clock
							////////////////////	Audio CODEC		////////////////////////////
							output			AUD_DACLRCK,			//	Audio CODEC DAC LR Clock
							output			AUD_DACDAT,				//	Audio CODEC DAC Data
							inout				AUD_BCLK,				//	Audio CODEC Bit-Stream Clock
							output			AUD_XCK				//	Audio CODEC Chip Clock
							);

  wire s_inc, s_inm,s_e,s_s,s_mem_rd2, we3, z;
  wire [2:0] op;
  wire [5:0] opcode;
  
	assign	I2C_SDAT	=	1'bz;
	//	Audio
	assign	AUD_ADCLRCK	=	AUD_DACLRCK;
	assign	AUD_XCK		=	AUD_CTRL_CLK;
	wire			AUD_CTRL_CLK;
	wire			VGA_CTRL_CLK;
	
	
	wire [51:0] NEW_RATE;
	
	wire audio_enable;
  
  microc micro1(CLOCK_50, reset, s_inc, s_inm, we3, s_mem_rd2, s_e, s_s,
	d0_e,d1_e,d2_e,d_audio,
	op, z,
	d0_s,d1_s,d2_s,d3_s,
	opcode);
	
  uc uc1(CLOCK_50, reset, z, opcode, s_inc, s_inm, s_e, s_s, s_mem_rd2, we3, op);

//AUDIO CONTROLLER  
VGA_Audio_PLL 		u3	(	.inclk0(CLOCK_27[0]),.c0(VGA_CTRL_CLK),.c1(AUD_CTRL_CLK)	);

I2C_AV_Config 		u7	(	//	Host Side
							.iCLK(CLOCK_50),
							.iRST_N(audio_enable),
							//	I2C Side
							.I2C_SCLK(I2C_SCLK),
							.I2C_SDAT(I2C_SDAT)	);
							
							
AUDIO_DAC 			u8	(	//	Audio Side
							.oAUD_BCK(AUD_BCLK),
							.oAUD_DATA(AUD_DACDAT),
							.oAUD_LRCK(AUD_DACLRCK),
							//	Control Signals
				         .iCLK_18_4(AUD_CTRL_CLK),
							.iRate(NEW_RATE),
							.iRST_N(audio_enable)	);
							
//generador de frecuencias dependiendo de la salida del CPU
Clk_generator Generator(.clk(CLOCK_50),
							.reset(reset),
							.enable(audio_enable),
							.port(d_audio),
							.sol_rate(NEW_RATE)
							);							
 endmodule
