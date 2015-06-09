//Memoria de programa

module memprog(input  wire clk,
               input  wire [9:0] a,
               output wire [15:0] rd);

  reg [15:0] mem[0:1023]; //memoria de 1024 palabras de 16 bits de ancho

  initial
  begin
    $readmemb("D:/Documentos/GitHub/DProcesadores/ProyectoPedro/Codigos/progfile.dat",mem); // inicializa la memoria del fichero en texto binario
  end
  assign rd = mem[a]; 
endmodule


