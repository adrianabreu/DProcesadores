module ModuloSonido(input clk, enable,
							output reg s_enable,
							input reset, short, long,
							output wire[51:0] sonido
							);
	reg[51:0] frecuencia;
	assign sonido= frecuencia;
	reg still;

	always@(clk)
		if(enable)
			begin
				if (short)
					begin
						s_enable <= 1;
						frecuencia <=  32000;
					end
				else
					begin
					if (long)
						begin
							s_enable <= 1;
							still <= 1;
							frecuencia <=  32000;
						end
					else
						begin
						if(still)
							begin
								still <= 0;
								s_enable <= 1;
								frecuencia <=  32000;
							end
						else
							begin
								s_enable <= 0;
								frecuencia <=  0;
							end
						end
					end
				end
endmodule
