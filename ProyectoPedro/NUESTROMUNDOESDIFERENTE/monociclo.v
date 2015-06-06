module monociclo(input wire clk, reset, 
                input wire [9:0] entrada_sonido,
                output wire [7:0] leds_verdes, 
                /////////////////////////////////////////////
                input [1:0]   CLOCK_24,       //  24 MHz
                input [1:0]   CLOCK_27,       //  27 MHz
                input       CLOCK_50,       //  50 MHz
                input [3:0]     KEY,
                input [9:0]     SW,
                ////////////////////////  I2C   ////////////////////////////////
                inout       I2C_SDAT,       //  I2C Data
                output      I2C_SCLK,       //  I2C Clock
                ////////////////////  Audio CODEC   ////////////////////////////
                output      AUD_DACLRCK,      //  Audio CODEC DAC LR Clock
                output      AUD_DACDAT,       //  Audio CODEC DAC Data
                inout       AUD_BCLK,       //  Audio CODEC Bit-Stream Clock
                output      AUD_XCK       //  Audio CODEC Chip Clock);
  
  assign  I2C_SDAT  = 1'bz;
  //  Audio
  assign  AUD_ADCLRCK = AUD_DACLRCK;
  assign  AUD_XCK   = AUD_CTRL_CLK;
  wire      AUD_CTRL_CLK;
  wire      VGA_CTRL_CLK;
  
  wire [51:0] sonido;
  
  wire audio_enable;

  //================================================
  wire s_inc, s_inm, selentrada, selsalida, we3, z;
  wire s_rel, enablebackup, s_ret;
  wire clock;
  wire [2:0] op;
  wire [5:0] opcode;
  wire [1:0] puerto1,puerto2;
  wire enable0, enable1, enable2,enable3;
  
  microc micro1(clk, reset, enable0, enable1, enable2, enable3,
                enablebackup, s_inc, s_inm, we3, selsalida,
                selentrada, s_rel, s_ret, e0,e1,e2,e3, opcode,op,puerto1,puerto2,s0,s1,s2,s3,pc_out,z);
  
  uc uc1(clk, reset, z, opcode, s_inc, s_inm, selentrada, selsalida,
         enablebackup, s_rel, s_ret, we3, enable0, enable1, enable2,
         enable3, puerto1,puerto2, op);

  retrasado pll(clk, reset, clock);
   
  ModuloSonido modsonido(clock,
                audio_enable,
                reset, short, long,
                sonido
                );

//AUDIO CONTROLLER  
VGA_Audio_PLL     u3  ( .inclk0(CLOCK_27[0]),.c0(VGA_CTRL_CLK),.c1(AUD_CTRL_CLK)  );

I2C_AV_Config     u7  ( //  Host Side
              .iCLK(CLOCK_50),
              .iRST_N(audio_enable),
              //  I2C Side
              .I2C_SCLK(I2C_SCLK),
              .I2C_SDAT(I2C_SDAT) );
              
              
AUDIO_DAC       u8  ( //  Audio Side
              .oAUD_BCK(AUD_BCLK),
              .oAUD_DATA(AUD_DACDAT),
              .oAUD_LRCK(AUD_DACLRCK),
              //  Control Signals
                 .iCLK_18_4(AUD_CTRL_CLK),
              .iRate(sonido),
              .iRST_N(audio_enable) );
                           
endmodule

