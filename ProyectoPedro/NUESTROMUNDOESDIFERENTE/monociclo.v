module monociclo(input wire clk, reset, enciendete,
                input wire [9:0] morse,
                input wire [7:0]e0,e1,e2,e3, 
                output wire [7:0]s0,s1,s2,s3,
					 output wire [9:0] pc_out,
					 output wire audio_enable, short, long,
                /////////////////////////////////////////////
                input [1:0]   CLOCK_27,       //  27 MHz
                ////////////////////////  I2C   ////////////////////////////////
                inout       I2C_SDAT,       //  I2C Data
                output      I2C_SCLK,       //  I2C Clock
                ////////////////////  Audio CODEC   ////////////////////////////
                output      AUD_DACLRCK,      //  Audio CODEC DAC LR Clock
                output      AUD_DACDAT,       //  Audio CODEC DAC Data
                inout       AUD_BCLK,       //  Audio CODEC Bit-Stream Clock
                output      AUD_XCK);       //  Audio CODEC Chip Clock);
  
  wire      AUD_CTRL_CLK;
  wire      VGA_CTRL_CLK;
  wire		AUD_ADCLRCK;
  wire [51:0] sonido;
  //wire audio_enable;
  
  wire s_inc, s_inm, selentrada, selsalida, we3, z;
  wire s_rel, enablebackup, s_ret;
  wire clock;
  wire [2:0] op;
  wire [5:0] opcode;
  wire [1:0] puerto1, puerto2;
  wire enable0, enable1, enable2, enable3;
  wire audioreg, audioact;
<<<<<<< HEAD
  //wire short, long;
=======
  wire short, long;
>>>>>>> origin/master
  wire [9:0] audiofromregtomodulo;
  assign  I2C_SDAT  = 1'bz;
  assign  AUD_ADCLRCK = AUD_DACLRCK;
  assign  AUD_XCK   = AUD_CTRL_CLK;
 
  
  microc micro1(clk, reset, enable0, enable1, enable2, enable3,
                enablebackup, s_inc, s_inm, we3, selsalida,
                selentrada, s_rel, s_ret, e0,e1,e2,e3, opcode,op,puerto1,puerto2,s0,s1,s2,s3,pc_out,z);
  
  uc uc1(clk, reset, z, opcode, s_inc, s_inm, selentrada, selsalida,
         enablebackup, s_rel, s_ret, we3, enable0, enable1, enable2,
         enable3, audioreg, audioact, puerto1,puerto2, op);

					
  registro10 salvaaudio(clk, reset, audioreg, morse, audiofromregtomodulo);
  
  descompose descomponer(clk, reset, audioact, morse, short, long, clock);
  
  ModuloSonido modsonido(clock,audioact,
                audio_enable,
                short, long,
                sonido
                );

//PARTE RELATIVA AL MODULO DE AUDIO
<<<<<<< HEAD

VGA_Audio_PLL aud1  ( .inclk0(CLOCK_27[0]),
                          .c0(VGA_CTRL_CLK),
                          .c1(AUD_CTRL_CLK));

I2C_AV_Config aud2(.iCLK(AUD_CTRL_CLK),
=======
VGA_Audio_PLL aud1  ( .inclk0(CLOCK_27[0]),
                          .c0(VGA_CTRL_CLK),
                          .c1(AUD_CTRL_CLK));

I2C_AV_Config aud2(.iCLK(CLOCK_50),
>>>>>>> origin/master
                   .iRST_N(audio_enable),
                   .I2C_SCLK(I2C_SCLK),
                   .I2C_SDAT(I2C_SDAT) );

adio_codec   aud3 (.oAUD_BCK(AUD_BCLK),
                  .oAUD_DATA(AUD_DACDAT),
                  .oAUD_LRCK(AUD_DACLRCK),
                  .iCLK_18_4(AUD_CTRL_CLK),
                  .iRate(sonido),
                  .iRST_N(audio_enable) );
<<<<<<< HEAD
                                          
=======
                           
>>>>>>> origin/master
endmodule

