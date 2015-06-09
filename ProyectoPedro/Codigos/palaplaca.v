module palaplaca (input wire clk, input wire reset, enciendete, input wire[9:0] morse, input wire[2:0] op, output wire[6:0] display1, display2,display3,display4, output wire [9:0] pc_out, output wire audio_enable, short, long, output wire [7:0]s0,s1,s2,s3,
    input [1:0]   CLOCK_27,       //  27 MHz
    ////////////////////////    I2C     ////////////////////////////////
    inout               I2C_SDAT,               //  I2C Data
    output          I2C_SCLK,               //  I2C Clock
    ////////////////////    Audio CODEC     ////////////////////////////
    output          AUD_DACLRCK,            //  Audio CODEC DAC LR Clock
    output          AUD_DACDAT,             //  Audio CODEC DAC Data
    inout               AUD_BCLK,               //  Audio CODEC Bit-Stream Clock
    output          AUD_XCK             //  Audio CODEC Chip Clock
    );

reg [7:0] e0,e1,e2,e3;
reg [3:0] rellenooperando;
reg [4:0] rellenooperacion;
reg [3:0] a,b;
wire noreset;
assign noreset=!reset;

    always @(posedge clk or posedge noreset) begin
        if (noreset) begin
            rellenooperando<=3'b000;
            rellenooperacion<=5'b00000;
            e0<=8'b00000000;
            e1<=8'b00000000;
            e2<=8'b00000000;
            e3<=8'b00000000;
        end
        else begin
            e0 = {rellenooperando,morse[9:5]};
            e1 = {rellenooperando,morse[4:0]};
            e2 = {rellenooperacion,op};
				a = morse[9:6];
				b = morse[4:1];
        end
    end 

    monociclo mono(clk, noreset, enciendete, morse, e0,e1,e2,e3, s0,s1,s2,s3, pc_out, audio_enable, short, long, CLOCK_27, I2C_SDAT, I2C_SCLK, AUD_DACLRCK, AUD_DACDAT, AUD_BCLK, AUD_XCK);
    deco4a7 deco1(b, display1, display2); 
    deco4a7 deco2(a, display3, display4); 
    
endmodule