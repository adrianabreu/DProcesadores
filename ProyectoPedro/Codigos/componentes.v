//Componentes varios

//DECODIFICADOR 5 A 32

module deco4a7(input  wire [3:0]  binario,
               output wire [6:0]  display1, display2);   

reg[6:0] salida1, salida2;

assign display1 = salida1;
assign display2 = salida2;

  always @(binario) begin
    case (binario)
      
      4'b0000:
        begin
          salida1<=7'b1000000;
          salida2<=7'b1111111;
        end

      4'b0001:
        begin
          salida1<=7'b1111001;
          salida2<=7'b1111111;
        end

      4'b0010:
        begin
          salida1<=7'b0100100;
          salida2<=7'b1111111;
        end

      4'b0011:
        begin
          salida1<=7'b0110000;
          salida2<=7'b1111111;
        end

      4'b0100:
        begin
          salida1<=7'b0011001;
          salida2<=7'b1111111;
        end

      4'b0101:
        begin
          salida1<=7'b0010010;
          salida2<=7'b1111111;
        end

      4'b0110:
        begin
          salida1<=7'b0000010;
          salida2<=7'b1111111;
        end

      4'b0111:
        begin
          salida1<=7'b1111000;
          salida2<=7'b1111111;
        end

      4'b1000:
        begin
          salida1<=7'b0000000;
          salida2<=7'b1111111;
        end

      4'b1001:
        begin
          salida1<=7'b0011000;
          salida2<=7'b1111111;
        end
     //---------------------------------------
      4'b1010:
        begin
          salida1<=7'b1000000;
          salida2<=7'b1111001;
        end

      4'b1011:
        begin
          salida1<=7'b1111001;
          salida2<=7'b1111001;
        end

      4'b1100:
        begin
          salida1<=7'b0100100;
          salida2<=7'b1111001;
        end

      4'b1101:
        begin
          salida1<=7'b0110000;
          salida2<=7'b1111001;
        end

      4'b1110:
        begin
          salida1<=7'b0011001;
          salida2<=7'b1111001;
        end

      4'b1111:
        begin
          salida1<=7'b0010010;
          salida2<=7'b1111001;
        end
    endcase
  end
endmodule

//Registro de ancho 10 para almacenar el audio
module registro10(input wire clk, reset,
                  input wire audioreg,
                  input wire [9:0] morse,
                  output reg [9:0] salida);

   always @(posedge clk)
      begin
        if (reset) salida <= 10'b0;
        if (audioreg) salida <= morse;
      end
endmodule

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
  
  assign rd1 = (ra1 != 0) ? regb[ra1] : 8'b0;
  assign rd2 = (ra2 != 0) ? regb[ra2] : 8'b0;
endmodule


module descompose(input wire clk, reset, enable,
          input wire [9:0] entrada,
          output reg short, l, clock, continue,inputwire[24:0] s);
  
 //reg [24:0]s; 
 reg[9:0] morse;
 reg still;
 reg[3:0] cuantosvan; //Contador hasta 9
 
  always @(posedge clk,posedge reset)
    begin
      if(reset)
        begin
            clock = 0;
            s = 25'b0;
            morse = entrada;
            short=0;
            l=0;
            continue=1;
            cuantosvan=0;
        end
		else
            begin
                continue=0;
    			if (s == 25'b101111101011110000100000)
    				begin
              if(cuantosvan==4'b1001)
              begin 
                continue=1;
                cuantosvan=0;
              end 
    					if(clock==0)
    						clock = 1;
    					else
    						clock = 0;
    					s = 25'b0;
    					if(enable)
    						if(still)
    							begin
    								l=1;
    								short=0;
    								still=0;
    								morse = morse << 1;
                           cuantosvan= cuantosvan + 1;
    							end
    						else
    						  begin 
    						if(morse[9]==1'b1)
    							begin
    								morse = morse << 1;
                                    cuantosvan= cuantosvan + 1;
    								if(morse[9]==1'b1)
    									begin
    										l=1;
    										still=1;
    										short=0;
    									end
    								else
    									begin
    										short=1;
    										l=0;
    									end
    							end
    							else
    								begin
    									short=0;
    									l=0;
    									morse = morse << 1;
                                        cuantosvan= cuantosvan + 1;
    								end
    							end
    		        end 
                else
    			    begin
                        s=s+1;
    		        end
            end
    end  
endmodule

//modulo sumador  
module sum(input  wire [9:0] a, b,
             output wire [9:0] y);

  assign y = a + b;
endmodule

//modulo sum/rest
module sumrest(input  wire [9:0] a, b,
              input wire resta,
             output wire [9:0] y);

  assign y = (resta==1) ? (a - b) : (a + b);
endmodule

module selectordepuerto(input wire [5:0] opcode, output wire y);

    assign y=(opcode[3:0] == 1111) ? 1 : 0;
endmodule

//modulo complemento a 2
module complementoa2(input wire [8:0] a, input wire resta,
                     output wire [9:0] y);
  assign y = (resta==1) ? {1'b1,-a} : {1'b0,a};
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

module registroconenable #(parameter WIDTH = 8)
              (input  wire             clk, reset,enable,
               input  wire [WIDTH-1:0] d, 
               output reg  [WIDTH-1:0] q);

  always @(posedge clk, posedge reset)
  if (reset) q <= 0;
  else
		if(enable) q <= d;
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

module mux4 #(parameter WIDTH = 8)
	    (input  wire [WIDTH-1:0] d0, d1, d2, d3,
	      input  wire [1:0] s, 
	      output reg [WIDTH-1:0] y);
	
	always @(*) //Demasiadas cosas para ponerlas una a una
    begin
		case (s)
			2'b00: y = d0;
			2'b01: y = d1;
			2'b10: y = d2;
			2'b11: y = d3;
		endcase
	end	
endmodule

module dmux4 #(parameter WIDTH = 8)
	    (output  reg [WIDTH-1:0] d0, d1, d2, d3,
	      input  wire [1:0] s, 
	      input wire [WIDTH-1:0] y);
	      
	always @(s, y) //MUY IMPORTANTE LA ENTRADA TAMBIEN
	begin
		begin
		  case (s)
			2'b00:
                begin
                    d0 = y;
                    d1 = 1'bx;
                    d2 = 1'bx;
                    d3 = 1'bx;    
                end

			2'b01: 
                begin
                    d0 = 1'bx;
                    d1 = y;
                    d2 = 1'bx;
                    d3 = 1'bx;    
                end

			2'b10: 
                begin
                    d0 = 1'bx;
                    d1 = 1'bx;
                    d2 = y;
                    d3 = 1'bx;    
                end
                
			2'b11: 
                begin
                    d0 = 1'bx;
                    d1 = 1'bx;
                    d2 = 1'bx;
                    d3 = y;    
                end
		  endcase
		end
	end	
endmodule

module concatenator4000 (input wire clk, reset, enable,
                         input wire [7:0] a,b,
                         output reg[24:0] resultado);

always @(posedge clk, posedge reset)
    begin 
    if(reset)
      begin
        resultado <= 25'b1011111010111100001000000;
      end 
    else
       begin
          if(enable)
            begin
                resultado <= {a,9'b11111111,b};
            end
       end
    end 
endmodule
