module uc(input wire clk, 
			reset, 
			z, 
			input wire [5:0] opcode, 
			output reg s_inc, 
			s_inm,
			s_e,
			s_s,
			s_mem_rd2, 
			we3, 
			output wire [2:0] op
);

assign op = opcode[2:0];

always @(*)

  if (reset == 1'b1)
  begin
  $display ("RESET");
    we3 <= 1'b0;		//no permite escribir registro
    s_inm <= 1'b0;		//no constante inmediata	  
    s_inc <= 1'b1;		//stay
    s_e <= 1'b0;		//no se usa ES
    s_mem_rd2 <= 1'b1;	//acuerdate de poner 0
    s_s<=1'b0;			//no hay salida a puerto
  end
  
  else
  begin
    casex (opcode)
	6'b111111:
	  begin
	    $display ("Op. FIN");
	    s_inc <= 1'b0;
	    we3 <= 1'b0;
	    s_s <= 1'b0;
		 
		 //valores por defecto
		 s_inm <= 1'b0;	  
		 s_e <= 1'b0;
       s_mem_rd2 <= 1'b0;
	 	    
	  end
	
	6'b111110:
	  begin
	    $display ("Op. NOP");
	    s_inc <= 1'b0;
	    we3 <= 1'b0;
	    s_s <= 1'b0;
		 
		 //valores por defecto
		 s_inm <= 1'b0;	  
		 s_e <= 1'b0;
       s_mem_rd2 <= 1'b0;
	  end
	  
	//ALU
	6'bxx0xxx:
	  begin
	    $display ("Op. ALU");
	    we3 <= 1'b1;		//permite escribir registro
	    $display("op=%b", op);
	    s_inc <= 1'b1;		//pc+1
	    s_inm <= 1'b0;		//no constante inmediata
	    s_e <= 1'b0;		//no se usa E, se usa ALU
	    s_mem_rd2 <= 1'b0;	//
	    s_s<=1'b0;			//no hay salida a puerto
	  end
	  
	//CARGA
	6'bxx1000:
	  begin
	  $display ("Op. CARGA");
	  	s_s <=1'b0;			//no hay salida a puerto
	    we3 <= 1'b1;		//permite escribir registro
	    s_inc <= 1'b1;		//pc+1
	    s_inm <= 1'b1;		//constante inmediata
	    s_e <= 1'b0;		//no se usa ES
	    s_mem_rd2 <= 1'b0;	//

	  end
	  
	//SALTO ABSOLUTO
	6'b001001:
	  begin
	  $display ("Op. SALTO");
	    we3 <= 1'b0;		//no permite escribir registro
	    s_inc <= 1'b0;		//salto
	    s_inm <= 1'b0;		//no constante inmediata
	    s_e <= 1'b0;		//no se usa ES
	    s_mem_rd2 <= 1'b0;	//
	    s_s<=1'b0;			//no hay salida a puerto
	  end
	  
	//SALTO CONDICIONAL
	6'b001010:
	  begin
	  $display ("Op. SALTO CONDICIONAL == 0");
	    we3 <= 1'b0;		//no permite escribir registro
	    s_inm <= 1'b0;		//no constante inmediata	  
	    s_e <= 1'b0;		//no se usa ES
	    s_mem_rd2 <= 1'b0;	//
	    s_s<=1'b0;			//no hay salida a puerto
	    if(z == 1'b1)
	      s_inc <= 1'b0;		//salto
	    else
	      s_inc <= 1'b1;		//pc+1
	  end

	6'b001011:
	  begin
	  $display ("Op. SALTO CONDICIONAL != 0");
	    we3 <= 1'b0;		//no permite escribir registro
	    s_inm <= 1'b0;		//no constante inmediata	  
	    s_e <= 1'b0;		//no se usa ES
	    s_mem_rd2 <= 1'b0;	//
	    s_s<=1'b0;			//no hay salida a puerto
	    if(z != 1'b1)
	      s_inc <= 1'b0;		//salto
	    else
	      s_inc <= 1'b1;		//pc+1
	  end  

	6'bxx1100:
	  begin
	  $display ("Op. SALIDA MEM PRG");
	  	we3 <= 1'b1;		//permite escribir registro
	    s_inc <= 1'b1;		//pc+1
	    s_inm <= 1'b0;		//no constante inmediata
	    s_e <= 1'b0;		//NO se usa E, se usa S
	    s_mem_rd2 <= 1'b0;	//sale de memoria
	    s_s<=1'b1;			//hay salida a puerto
	  end	  

	6'b001110:
	  begin
	  $display ("Op. SALIDA REGISTRO");
		we3 <= 1'b1;		//permite escribir registro
	    s_inc <= 1'b1;		//pc+1
	    s_inm <= 1'b0;		//no constante inmediata
	    s_e <= 1'b0;		//NO se usa E, se usa S
	    s_mem_rd2 <= 1'b1;	//sale del banco de registros
	    s_s<=1'b1;			//hay salida a puerto
	  end	  

	6'b011110:
	  begin
	  $display ("Op. LECTURA ENTRADA");
	  	we3 <= 1'b1;		//permite escribir registro
	    s_inc <= 1'b1;		//pc+1
	    s_inm <= 1'b0;		//no constante inmediata	  
	    s_e <= 1'b1;		//se usa E
	    s_mem_rd2 <= 1'b0;	//
	    s_s<=1'b0;			//no hay salida a puerto
	  end	  	
	//DEFECTO
	default:
	  begin
	    we3 <= 1'b0;		//no permite escribir registro
	    s_inm <= 1'b0;		//no constante inmediata	  
	    s_inc <= 1'b1;		//pc+1
	    s_e <= 1'b0;		//no se usa E
	    s_mem_rd2 <= 1'b1;	//
	    s_s<=1'b0;			//no hay salida a puerto
	  end

    endcase
  end	
endmodule
