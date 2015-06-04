module palaplaca (input wire clk, input wire reset, input wire[3:0] a, b, input wire[2:0] op, output wire[6:0] display1, display2,display3,display4, output wire [9:0] pc_out, output wire [7:0]s0,s1,s2,s3);

reg [7:0] e0,e1,e2,e3;
reg [3:0] rellenooperando;
reg [4:0] rellenooperacion;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            rellenooperando<=4'b0000;
            rellenooperacion<=5'b00000;
            e0<=8'b00000000;
            e1<=8'b00000000;
            e2<=8'b00000000;
            e3<=8'b00000000;
        end
        else begin
            e0 = {rellenooperando,a};
            e1 = {rellenooperando,b};
            e2 = {rellenooperacion,op};
        end
    end 

    monociclo mono(clk, reset, e0,e1,e2,e3, s0,s1,s2,s3, pc_out);
    deco4a7 deco1(b, display1, display2); 
    deco4a7 deco2(a, display3, display4);
    //AUDIO CONTROLLER  
    VGA_Audio_PLL       u3  (   .inclk0(CLOCK_27[0]),.c0(VGA_CTRL_CLK),.c1(AUD_CTRL_CLK)    );

    I2C_AV_Config       u7  (   //  Host Side
                                .iCLK(CLOCK_50),
                                .iRST_N(audio_enable),
                                //  I2C Side
                                .I2C_SCLK(I2C_SCLK),
                                .I2C_SDAT(I2C_SDAT) );
                                
                                
    AUDIO_DAC           u8  (   //  Audio Side
                                .oAUD_BCK(AUD_BCLK),
                                .oAUD_DATA(AUD_DACDAT),
                                .oAUD_LRCK(AUD_DACLRCK),
                                //  Control Signals
                             .iCLK_18_4(AUD_CTRL_CLK),
                                .iRate(NEW_RATE),
                                .iRST_N(audio_enable)   );
                                
    //generador de frecuencias dependiendo de la salida del CPU
    Clk_generator Generator(.clk(CLOCK_50),
                                .reset(reset),
                                .enable(audio_enable),
                                .port(d_audio),
                                .sol_rate(NEW_RATE)
                                );   
    
endmodule