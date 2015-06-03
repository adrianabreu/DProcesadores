module Clk_generator(input clk,
							output reg enable,
							input reset,
							input [7:0] port,
							output wire[51:0] sol_rate
							);
reg[51:0] new_rate;
assign sol_rate = new_rate;

always@(port)
begin
	case(port)
		 8'b0000000  :
		 begin
			enable <= 0;
			new_rate <=  0;
		 end
		 8'b000100  :///DO///  
		 begin
			enable <= 1;
			new_rate <=  17980;//
		 end
		 8'b0001000  :///RE///			
		 begin
			enable <= 1;
			new_rate <=  19200;//
		 end
		 //8'b0000100  :///MI///
		 //begin
			//enable <= 1;
			//new_rate <=  22800;//22154
		 //end
		 8'b0010000  :///FA///  
		 begin
			enable <= 1;
			new_rate <=  24000;//
		 end
		 //8'b0010000  :///SOL///  
		 //begin
			//enable <= 1;
			//new_rate <= 26182;//26400;//26182
		 //end
		 8'b0100000  :///LA///  
		 begin
			enable <= 1;
			new_rate <=  28800;//
		 end
		 8'b1000000  :///SI///  
		 begin
			enable <= 1;
			new_rate <=  32000;//
		 end
		default	:///Cualquier otra combinacion//
			begin
				enable <= 0;
				new_rate		<=		0;
			end
		endcase
end					

endmodule
