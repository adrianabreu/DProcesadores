//Microcontrolador sin memoria de datos de un solo ciclo
module microc(input wire clk, reset, s_inc, s_inm, we3, s_mem_rd2, s_e,s_s,
				input wire[7:0]d0_e,d1_e,d2_e,d3_e, input wire [2:0] op,
				output wire zero, output wire [7:0]d0_s,d1_s,d2_s,d3_s, output wire [5:0] opcode);

wire [9:0] pc_out, mux_pc; //cable sumador, pc y memprog; cable mux_inc y pc
wire [9:0] sum_mux;
wire [7:0] alu_mux, mux_reg, mux_mux, puerto_mux;
wire [7:0] rd1_alu, rd2_alu; //entradas a y b de la ALU
wire [15:0] bus_datos;
wire z;
wire [7:0] d0_p, d1_p, d2_p, d3_p;

sum sum_pc(pc_out, 10'b0000000001, sum_mux);	//a,1→in	sum_mux→out

registro #(10) pc(clk, reset, mux_pc, pc_out);	//clk,reset,mux_pc→in	pc_out→out
               
memprog mem_instr(clk, pc_out, bus_datos[15:0]);           
                             
mux2 #(10) mux_inc(bus_datos[15:6], sum_mux, s_inc, mux_pc); //modulo multiplexor, con s=1 sale sum_mux, s=0 sale d0            
             
regfile registros(clk, we3, bus_datos[7:4], bus_datos[11:8], bus_datos[15:12], mux_reg, rd1_alu, rd2_alu);               
              
alu alu1(rd1_alu, rd2_alu, op, alu_mux, z); 
           
mux2 mux_inm(alu_mux, bus_datos[11:4], s_inm, mux_mux);

registro #(1) ffzero(clk, reset, z, zero);	//clk,reset,mux_pc→in	pc_out→out

assign opcode = bus_datos[5:0];

///entrada salida
mux2 mux_e(mux_mux, puerto_mux, s_e, mux_reg);//si s_e → 1, lee datos de la entrada salida

mux16_e #(8) mux_puerto_e(d0_e, d1_e, d2_e, d3_e, bus_datos[7:6], puerto_mux);	//selecciona el puerto a escribir d0..3→puerto_mux_e

mux16_s #(8) mux_puerto_s(d0_p, d1_p, d2_p, d3_p, bus_datos[7:6],clk , s_mem_rd2,s_s, bus_datos[15:8],rd2_alu);	//selecciona el puerto del que leer puerto_mux_s→d0..3

registro #(8) puerto_s0(clk, reset, d0_p, d0_s);	//registro previo a disp salida
registro #(8) puerto_s1(clk, reset, d1_p, d1_s);	//registro previo a disp salida
registro #(8) puerto_s2(clk, reset, d2_p, d2_s);	//registro previo a disp salida
registro #(8) puerto_s3(clk, reset, d3_p, d3_s);	//registro previo a disp salida

endmodule
