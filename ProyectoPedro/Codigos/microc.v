//Microcontrolador sin memoria de datos de un solo ciclo
module microc(input wire clk, reset, enable0, enable1, enable2, enable3, 
                         enablebackup,s_inc, s_inm, we3, selsalida, 
                         selentrada, s_rel, s_ret,
			  input wire[7:0]ein0,ein1,ein2,ein3, 
			  output wire [5:0] opcode,
              input wire [2:0] op,
              output wire [1:0] puerto1,
              output wire [1:0] puerto2,
              output wire [7:0] sout0,sout1,sout2,sout3,
				  output wire [9:0] pc_out,
              output wire zero,output wire [24:0]contador,input wire s_cont);

//wire [7:0]sout0,sout1,sout2,sout3;
wire [9:0] muxpc_out; //cable sumador, pc y memprog; cable mux_pc y pc
wire [9:0] sumpc_out; //Salida del sumador del pc
wire [7:0] alu_mux_in, mux_reg, alu_mux_out, puerto_mux; //Conexion multiplexor alu
wire [7:0] rd1, rd2; //Entradas alu
wire [15:0] bus_de_datos; //Bus
wire z;
wire [7:0] sin0, sin1, sin2, sin3;
wire [7:0] eout0,eout1,eout2,eout3;
wire [7:0] SalidaMux2ADmux4;
wire[1:0] salmuxpuerto;

//Cables nuevos:
wire [9:0] smuxalupc,restorepc,retornopc_out,compsalto_out;

assign opcode = bus_de_datos[5:0];

//mux2 #(2) muxpuertosal(bus_de_datos[7:6],rd1[1:0],selpuerto,salmuxpuerto);
//assign puerto = (bus_de_datos[3:0]==1111) ? rd1[1:0] : bus_de_datos[7:6];
assign puerto1 = bus_de_datos[7:6];
assign puerto2 = rd1[1:0];

sum sum_pc(pc_out, smuxalupc, sumpc_out); //module sum(input wire [9:0] a, b, output wire [9:0] y);

//--------------------------------------------------------
//Modificaciones para las mejoras de salto
//---------------------------------------------------------
//Salto relativo
complementoa2 compsalto(bus_de_datos[14:6],bus_de_datos[15],compsalto_out);
mux2 #(10) mux_srel(10'b1,compsalto_out,s_rel,smuxalupc);

//Salto subrutina
registroconenable #(10) pcbackup(clk, reset, enablebackup, sumpc_out, restorepc);
mux2 #(10) retornopc (muxpc_out,restorepc,s_ret,retornopc_out);
//------------------------------------------------------------------------------

//module registro #(parameter WIDTH = 8)(input wire clk, reset,
//input wire [WIDTH-1:0] d,  output reg  [WIDTH-1:0] q);
registro #(10) pc(clk, reset, retornopc_out, pc_out);

//module memprog(input wire clk, input wire [9:0] a, output wire [15:0] rd);     
memprog memoria(clk, pc_out, bus_de_datos[15:0]);

//module mux2 (input  wire [WIDTH-1:0] d0, d1, input wire s,
//output wire [WIDTH-1:0] y);    
mux2 #(10) mux_pc(bus_de_datos[15:6], sumpc_out, s_inc, muxpc_out);

//module regfile(input wire clk, input wire we3, input wire [3:0] ra1, ra2, wa3, 
//input wire [7:0] wd3, output wire [7:0] rd1, rd2);   
regfile registros(clk, we3, bus_de_datos[7:4], bus_de_datos[11:8], bus_de_datos[15:12], mux_reg, rd1, rd2);               

//module alu(input wire [7:0] a, b, input wire [2:0] op,
//           output wire [7:0] y, output wire zero);      
alu alu1(rd1, rd2, op, alu_mux_in, z); 
/* module concatenator4000 (input wire clk, reset, enable,
                         input wire [7:0] a,b,
                         output reg[24:0] resultado); */ 

concatenator frecuencia(clk,reset,s_cont,rd1,rd2,contador);
//module mux2 #(parameter WIDTH = 8)(input  wire [WIDTH-1:0] d0, d1, input wire s, 
//                                   output wire [WIDTH-1:0] y);
mux2 mux_banco(alu_mux_in, bus_de_datos[11:4], s_inm, alu_mux_out);

//Para que la señal de zero no desaparezca la retrasaremos un ciclo metiendola en un registro
//assign zero = z;
registro #(1) regzero(clk, reset, z, zero);	



//--------------------------------------------
//ENTRADA - SALIDA
//--------------------------------------------

//Muxentrada a registro
mux2 muxentradaregistro(alu_mux_out, puerto_mux, selentrada, mux_reg);

mux2 muxademux(bus_de_datos[15:8],rd2,selsalida,SalidaMux2ADmux4);
mux4 #(8) muxentrada(ein0, ein1, ein2, ein3, bus_de_datos[7:6], puerto_mux);

//Registros de salida
registroconenable #(8) salida0(clk, reset, enable0, SalidaMux2ADmux4, sout0);
registroconenable #(8) salida1(clk, reset, enable1, SalidaMux2ADmux4, sout1);
registroconenable #(8) salida2(clk, reset, enable2, SalidaMux2ADmux4, sout2);
registroconenable #(8) salida3(clk, reset, enable3, SalidaMux2ADmux4, sout3);

//-------------------------------------------------------------------------------

endmodule
