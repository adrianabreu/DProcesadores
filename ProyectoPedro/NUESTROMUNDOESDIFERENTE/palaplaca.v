module palaplaca (input wire clk, input wire reset, input wire[9:0] morse, input wire[2:0] op, output wire[6:0] display1, display2,display3,display4, output wire [9:0] pc_out, output wire [7:0]s0,s1,s2,s3);

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
    
endmodule