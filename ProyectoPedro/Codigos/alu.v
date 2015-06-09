module alu(input wire [7:0] a, b,
           input wire [2:0] op,
           output wire [7:0] y,
           output wire zero);

reg [7:0] s;		   
   
		   
always @(a, b, op)
begin
  case (op)              
	3'b000: s = a;
	3'b001: s = ~a;
	3'b010: s = a + b;
	3'b011: s = a - b;
	3'b100: s = a & b;
	3'b101: s = a | b;
	3'b110: s = -a;
	3'b111: s = a>>1;
	default: s = 'bx; //desconocido en cualquier otro caso (x ó z), por si se modifica el código
  endcase
end

assign y = s;

//Calculo del flag de cero
assign zero = ~(|y);   //operador de reducción |y hace la or de los bits del vector 'y' y devuelve 1 bit resultado
		   
endmodule
