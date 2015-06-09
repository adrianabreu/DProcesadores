module ModuloSonido(input clk, enable,
							output reg s_enable,
							input short, long,
							output wire[51:0] sonido
							);
	reg[51:0] frecuencia=32000;
	assign sonido= frecuencia;

	always@(clk)
	 begin
    if (enable)
	    begin
		    if (long)
			    begin
				    s_enable <= 1;
					 //frecuencia <=  32000;
				 end
			 else 
			 if (short)
			    begin
				    s_enable <= 1;
					 //frecuencia <=  32000;
				 end
			 else 
			    begin
				    s_enable <= 0;
					 //frecuencia <=  0;
				 end
	    end
	end
endmodule
