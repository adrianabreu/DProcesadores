// --------------------------------------------------------------------
// Copyright (c) 2005 by Terasic Technologies Inc. 
// --------------------------------------------------------------------
//
// Permission:
//
//   Terasic grants permission to use and modify this code for use
//   in synthesis for all Terasic Development Boards and Altera Development 
//   Kits made by Terasic.  Other use of this code, including the selling 
//   ,duplication, or modification of any portion is strictly prohibited.
//
// Disclaimer:
//
//   This VHDL/Verilog or C/C++ source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  Terasic provides no warranty regarding the use 
//   or functionality of this code.
//
// --------------------------------------------------------------------
//           
//                     Terasic Technologies Inc
//                     356 Fu-Shin E. Rd Sec. 1. JhuBei City,
//                     HsinChu County, Taiwan
//                     302
//
//                     web: http://www.terasic.com/
//                     email: support@terasic.com
//
// --------------------------------------------------------------------
//
// Major Functions:	DE1 Default Code
//
// --------------------------------------------------------------------
//
// Revision History :
// --------------------------------------------------------------------
//   Ver  :| Author            :| Mod. Date :| Changes Made:
//   V1.0 :| Joe Yang          :| 10/25/2006  :| Initial Revision
// --------------------------------------------------------------------


/////////////////////////////////////////////
////     2Channel-Music-Synthesizer     /////
/////////////////////////////////////////////
/*******************************************/
/*             KEY & SW List               */
/* KEY[0]: I2C reset                       */
/* KEY[1]: Demo Sound repeat               */
/* KEY[2]: Keyboard code Reset             */
/* KEY[3]: Keyboard system Reset           */
/* SW[0] : 0 Brass wave ,1 String wave     */
/* SW[1] : 0 CH1_ON ,1 CH1_OFF             */
/* SW[2] : 0 CH2_ON ,1 CH2_OFF             */
/* SW[9] : 0 DEMO Sound ,1 KeyBoard Play   */
/*******************************************/


module DE1_synthesizer (

////////////////////////	Clock Input	 	////////////////////////
input	[1:0]	CLOCK_24,				//	24 MHz
input	[1:0]	CLOCK_27,				//	27 MHz
input			CLOCK_50,				//	50 MHz
input			EXT_CLOCK,				//	External Clock
////////////////////////	Push Button		////////////////////////
input	[3:0]	KEY,					//	Pushbutton[3:0]
////////////////////////	DPDT Switch		////////////////////////
input	[9:0]	SW,						//	Toggle Switch[9:0]
////////////////////////	7-SEG Dispaly	////////////////////////
output	[6:0]	HEX0,					//	Seven Segment Digit 0
output	[6:0]	HEX1,					//	Seven Segment Digit 1
output	[6:0]	HEX2,					//	Seven Segment Digit 2
output	[6:0]	HEX3,					//	Seven Segment Digit 3
////////////////////////////	LED		////////////////////////////
output	[7:0]	LEDG,					//	LED Green[7:0]
output	[9:0]	LEDR,					//	LED Red[9:0]
////////////////////////////	UART	////////////////////////////
output			UART_TXD,				//	UART Transmitter
input			UART_RXD,				//	UART Receiver
///////////////////////		SDRAM Interface	////////////////////////
inout	[15:0]	DRAM_DQ,				//	SDRAM Data bus 16 Bits
output	[11:0]	DRAM_ADDR,				//	SDRAM Address bus 12 Bits
output			DRAM_LDQM,				//	SDRAM Low-byte Data Mask 
output			DRAM_UDQM,				//	SDRAM High-byte Data Mask
output			DRAM_WE_N,				//	SDRAM Write Enable
output			DRAM_CAS_N,				//	SDRAM Column Address Strobe
output			DRAM_RAS_N,				//	SDRAM Row Address Strobe
output			DRAM_CS_N,				//	SDRAM Chip Select
output			DRAM_BA_0,				//	SDRAM Bank Address 0
output			DRAM_BA_1,				//	SDRAM Bank Address 0
output			DRAM_CLK,				//	SDRAM Clock
output			DRAM_CKE,				//	SDRAM Clock Enable
////////////////////////	Flash Interface	////////////////////////
inout	[7:0]	FL_DQ,					//	FLASH Data bus 8 Bits
output	[21:0]	FL_ADDR,				//	FLASH Address bus 22 Bits
output			FL_WE_N,				//	FLASH Write Enable
output			FL_RST_N,				//	FLASH Reset
output			FL_OE_N,				//	FLASH Output Enable
output			FL_CE_N,				//	FLASH Chip Enable
////////////////////////	SRAM Interface	////////////////////////
inout	[15:0]	SRAM_DQ,				//	SRAM Data bus 16 Bits
output	[17:0]	SRAM_ADDR,				//	SRAM Address bus 18 Bits
output			SRAM_UB_N,				//	SRAM High-byte Data Mask 
output			SRAM_LB_N,				//	SRAM Low-byte Data Mask 
output			SRAM_WE_N,				//	SRAM Write Enable
output			SRAM_CE_N,				//	SRAM Chip Enable
output			SRAM_OE_N,				//	SRAM Output Enable
////////////////////	SD Card Interface	////////////////////////
inout			SD_DAT,					//	SD Card Data
inout			SD_DAT3,				//	SD Card Data 3
inout			SD_CMD,					//	SD Card Command Signal
output			SD_CLK,					//	SD Card Clock
////////////////////////	I2C		////////////////////////////////
inout			I2C_SDAT,				//	I2C Data
output			I2C_SCLK,				//	I2C Clock
////////////////////////	PS2		////////////////////////////////
inout		 	PS2_DAT,				//	PS2 Data
input			PS2_CLK,				//	PS2 Clock
////////////////////	USB JTAG link	////////////////////////////
input  			TDI,					// CPLD -> FPGA (data in)
input  			TCK,					// CPLD -> FPGA (clk)
input  			TCS,					// CPLD -> FPGA (CS)
output 			TDO,					// FPGA -> CPLD (data out)
////////////////////////	VGA			////////////////////////////
output			VGA_HS,					//	VGA H_SYNC
output			VGA_VS,					//	VGA V_SYNC
output	[3:0]	VGA_R,   				//	VGA Red[3:0]
output	[3:0]	VGA_G,	 				//	VGA Green[3:0]
output	[3:0]	VGA_B,   				//	VGA Blue[3:0]
////////////////////	Audio CODEC		////////////////////////////
output			AUD_ADCLRCK,			//	Audio CODEC ADC LR Clock
input			AUD_ADCDAT,				//	Audio CODEC ADC Data
output			AUD_DACLRCK,			//	Audio CODEC DAC LR Clock
output			AUD_DACDAT,				//	Audio CODEC DAC Data
inout			AUD_BCLK,				//	Audio CODEC Bit-Stream Clock
output			AUD_XCK,				//	Audio CODEC Chip Clock
////////////////////////	GPIO	////////////////////////////////
inout	[35:0]	GPIO_0,					//	GPIO Connection 0
inout	[35:0]	GPIO_1				//	GPIO Connection 1
////////////////////////////////////////////////////////////////////
	);

//	All inout port turn to tri-state
	assign	DRAM_DQ		=	16'hzzzz;
	assign	FL_DQ		=	8'hzz;
	assign	SRAM_DQ		=	16'hzzzz;
	assign	SD_DAT		=	1'bz;
	assign	I2C_SDAT	=	1'bz;
	assign	GPIO_1		=	36'hzzzzzzzzz;
	assign	GPIO_0		=	36'hzzzzzzzzz;	
//	Audio
	wire    AUD_CTRL_CLK;
	assign	AUD_ADCLRCK	=	AUD_DACLRCK;
	assign	AUD_XCK		=	AUD_CTRL_CLK;

	SEG7_LUT_4 			u0	(	HEX0,HEX1,HEX2,HEX3,16'h1112 );

	VGA_Audio_PLL 		u1	(	.inclk0(CLOCK_27),
								//.c0(VGA_CTRL_CLK),
								.c1(AUD_CTRL_CLK)	);
														
	I2C_AV_Config 		u7	(	//	Host Side
								.iCLK(CLOCK_50),
								.iRST_N(KEY[0]),
								//	I2C Side
								.I2C_SCLK(I2C_SCLK),
								.I2C_SDAT(I2C_SDAT)	);

///////////////////////Music-Synthesizer Block////////////
//////Timing or Clock generater///////////////////////
	reg    [31:0]VGA_CLK_o;
	wire   keyboard_sysclk=VGA_CLK_o[11];
	wire   demo_clock     =VGA_CLK_o[18];
	assign VGA_CLK        =VGA_CLK_o[0];
	always @(posedge CLOCK_50) VGA_CLK_o=VGA_CLK_o+1;

//////////DEMO Sound///////////////////////////////////
//////demo-sound-CH1//////
	wire [7:0]demo_code1;
	demo_sound1	dd1(
		.clock(demo_clock),
		.key_code(demo_code1),
		.k_tr(KEY[1])
	);
//////demo-sound-CH2///////
	wire [7:0]demo_code2;
	demo_sound2	dd2(
		.clock(demo_clock),
		.key_code(demo_code2),
		.k_tr(KEY[1])
	);

//////////////////KeyBoard Scan//////////////////////
	wire [7:0]scan_code;
	wire get_gate;
	wire key1_on;
	wire key2_on;
	wire [7:0]key1_code;
	wire [7:0]key2_code;
	PS2_KEYBOARD keyboard(
		.ps2_dat  (PS2_DAT),		//ps2bus data  				inout
		.ps2_clk  (PS2_CLK),		//ps2bus clk      			inout
		.sys_clk  (keyboard_sysclk),//system clock		input
		.reset    (KEY[3]), 		//system reset				input
    	.reset1   (KEY[2]),			//keyboard reset			input
    	.scandata (scan_code),		//scan code    			output
    	.key1_on(key1_on),			//key1 triger
    	.key2_on(key2_on),			//key2 triger
    	.key1_code(key1_code),		//key1 code
    	.key2_code(key2_code) 		//key2 code
	);
	
////////////Sound Select/////////////	
	wire [15:0]sound1;
	wire [15:0]sound2;
	wire [15:0]sound3;
	wire [15:0]sound4;
	wire sound_off1;
	wire sound_off2;
	wire sound_off3;
	wire sound_off4;
	wire [7:0]sound_code1=(!SW[9])?demo_code1:key1_code;//SW[9]=0 is DEMO SOUND,otherwise key
	wire [7:0]sound_code2=(!SW[9])?demo_code2:key2_code;//SW[9]=0 is DEMO SOUND,otherwise key
	wire [7:0]sound_code3=8'hf0;
	wire [7:0]sound_code4=8'hf0;

/////////Staff Display & Sound Output///////
	wire   VGA_R1,VGA_G1,VGA_B1;
	wire   VGA_R2,VGA_G2,VGA_B2;
	assign VGA_R[3]=VGA_R1;
	assign VGA_G[3]=VGA_G1;
	assign VGA_B[3]=VGA_B1;
	staff st1(
		.VGA_CLK(VGA_CLK),   
		//vga out//
		.vga_h_sync(VGA_HS), 
		.vga_v_sync(VGA_VS), 
		.vga_R(VGA_R1), 
		.vga_G(VGA_G1), 
		.vga_B(VGA_B1),
		//key code-in//
		.scan_code1(sound_code1),
		.scan_code2(sound_code2),
		.scan_code3(sound_code3),//off
		.scan_code4(sound_code4),//off
		//sound-out to audio generater//
		.sound1(sound1),
		.sound2(sound2),
		.sound3(sound3),//off
		.sound4(sound4),//off
		.sound_off1(sound_off1),
		.sound_off2(sound_off2),
		.sound_off3(sound_off3),//off
		.sound_off4(sound_off4)	//off
	);

///////LED display////////
	assign LEDR[9:6]={sound_off4,sound_off3,sound_off2,sound_off1};
	assign LEDG[7:0]=scan_code;
						
///////2CH Audio SoundOut----Audio Generater////////
	adio_codec ad1	(	        
		.oAUD_BCK (AUD_BCLK),
		.oAUD_DATA(AUD_DACDAT),
		.oAUD_LRCK(AUD_DACLRCK),																
		.iSrc_Select(2'b00),
		.iCLK_18_4(AUD_CTRL_CLK),
		.iRST_N(KEY[0]),							
		//sound control//							
		.key1_on(~SW[1] & sound_off1),//CH1 on/off
		.key2_on(~SW[2] & sound_off2),//CH2 on/off
		.key3_on(1'b0),//off
    	.key4_on(1'b0),//off							
		.sound1(sound1),//CH1 freq
		.sound2(sound2),//CH2 freq
		.sound3(sound3),//off,CH3 freq
		.sound4(sound4),//off,CH4 freq							
		.instru(SW[0])//instruction select
	);
							
endmodule
