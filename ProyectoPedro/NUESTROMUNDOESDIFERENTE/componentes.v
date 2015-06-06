//Componentes varios

//Banco de registros de dos salidas y una entrada
module regfile(input  wire        clk, 
               input  wire        we3,           //se�al de habilitaci�n de escritura ���ROJO!!!
               input  wire [3:0]  ra1, ra2, wa3, //direcciones de regs leidos y reg a escribir
               input  wire [7:0]  wd3, 			 //dato a escribir
               output wire [7:0]  rd1, rd2);     //datos leidos

  reg [7:0] regb[0:15]; //memoria de 16 registros de 8 bits de ancho

  // El registro 0 siempre es cero
  // se leen dos reg combinacionalmente
  // y la escritura del tercero ocurre en flanco de subida del reloj
  always @(posedge clk)
    if (we3) regb[wa3] <= wd3;	
  
  assign rd1 = (ra1 != 0) ? regb[ra1] : 0;
  assign rd2 = (ra2 != 0) ? regb[ra2] : 0;
endmodule

//modulo sumador  
module sum(input  wire [9:0] a, b,
             output wire [9:0] y);

  assign y = a + b;
endmodule

module retrasado(input wire clk, reset,
					output reg clock);
	reg [24:0] s;
	always @(clk)
		begin
			if(reset)
				s = 25b'0;
			if (s == 25b'1011111010111100001000000)
				begin
					clock = 1;
					s = 25b'0;
				end
			else
				s=s+1;
				clock = 0;
		end
endmodule

//modulo de registro para modelar el PC, cambia en cada flanco de subida de reloj o de reset
module registro #(parameter WIDTH = 8)
              (input  wire             clk, reset,
               input  wire [WIDTH-1:0] d, 
               output reg  [WIDTH-1:0] q);

  always @(posedge clk, posedge reset)
    if (reset) q <= 0;
    else       q <= d;
endmodule

//modulo multiplexor, con s=1 sale d1, s=0 sale d0
module mux2 #(parameter WIDTH = 8)
             (input  wire [WIDTH-1:0] d0, d1, 
              input  wire             s, 
              output wire [WIDTH-1:0] y);

  assign y = s ? d1 : d0; 
endmodule

//
// NUEVOS COMPONENTES PARA E/S
//

module mux16_e #(parameter WIDTH = 8)
	    (input  wire [WIDTH-1:0] d0, d1, d2, d3,
	      input  wire [1:0] s, 
	      output reg [WIDTH-1:0] y);
	
	always @(*)
    begin
		case (s)
			2'b00: y = d0;
			2'b01: y = d1;
			2'b10: y = d2;
			2'b11: y = d3;
		endcase
	end	
endmodule

module mux16_s #(parameter WIDTH = 8)
	    (output  reg [WIDTH-1:0] d0, d1, d2, d3,
	      input  wire [1:0] s_puerto, 
			input wire clk,
	      input wire s_entrada, s_encendido,
	      input wire [WIDTH-1:0] y0,y1);
	      

	      
	always @(posedge clk)
	begin
		if(s_encendido)
		begin
		
		  case (s_puerto)
			2'b00: d0 = (s_entrada) ? y1 : y0;
			2'b01: d1 = (s_entrada) ? y1 : y0;
			2'b10: d2 = (s_entrada) ? y1 : y0;
			2'b11: d3 = (s_entrada) ? y1 : y0;
		  endcase
		end
	end	
endmodule
