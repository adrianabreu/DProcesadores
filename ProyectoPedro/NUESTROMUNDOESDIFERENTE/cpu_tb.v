`timescale 1 ns / 10 ps

module cpu_tb;

reg reset, clk;	
reg [7:0] d0_e, d1_e, d2_e, d3_e;
wire [7:0] d0_s, d1_s, d2_s, d3_s;

always begin
	clk = 1;
	#20;
	clk = 0;
	#60;
end

initial begin

      $monitor ("time=%0d, clk=%b, Reset=%b, d0_s=%d, d1_s=%d, d2_s=%d, d3_s=%d", $time, clk, reset, d0_s, d1_s, d2_s, d3_s);
	  
      $dumpfile ("cpu_tb.vcd"); 
      $dumpvars;
	  
	  d3_e = 8'b00000000; //611111111
	  #50
	  d3_e = 8'b00000001;
	  #50
	  d3_e = 8'b00000010;
	  #50
	  d3_e = 8'b00000100;
	  #50
	  d3_e = 8'b00001000;
	  #50
	  d3_e = 8'b00010000;

	  
	  $display ("Entradas: d0_e=%d, d1_e=%d, d2_e=%d, d3_e=%d", d0_e, d1_e, d2_e, d3_e);
	  
      reset = 1;
      #5
      reset = 0;
      #10000
	  
  $finish;
  
end

cpu cpu1(clk, reset, d0_e, d1_e, d2_e, d3_e, d0_s, d1_s, d2_s, d3_s);

endmodule

