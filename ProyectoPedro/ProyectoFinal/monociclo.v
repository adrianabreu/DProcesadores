module monociclo(input wire clk, reset, input wire [7:0]e0,e1,e2,e3, output wire [7:0]s0,s1,s2,s3, output wire [9:0] pc_out);

  wire s_inc, s_inm, selentrada, selsalida, we3, z;
  wire s_rel, enablebackup, s_ret;
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
   
endmodule
