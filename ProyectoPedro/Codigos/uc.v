module uc(input wire clk, reset, z, input wire [5:0] opcode, 
    output reg s_inc, s_inm, selentrada, selsalida, enablebackup,
               s_rel, s_ret, we3, enable0, enable1, enable2, enable3, audioreg, audioact,
    input wire [1:0] puerto1,puerto2, output wire [2:0] op,input wire continue);

//Si usamos wires se descontrola todo
assign op = opcode[2:0];

always @(*)
  begin 
    enable0 <= 1'b0;
    enable1 <= 1'b0;
    enable2 <= 1'b0;
    enable3 <= 1'b0;
      if (reset == 1'b1)
      begin
        we3 <= 1'b0;        //Escritura inhabilitada
        s_inm <= 1'b0;      //No vienen constantes del multiplexor    
        s_inc <= 1'b1;      //El pc continua su ciclo normal
        selentrada<= 1'b0;  //No se aceptan entradas de los disp.   
        selsalida <= 1'b0;  //La entrada al mux de salida es el bus de datos
        s_rel <= 1'b0;
        s_ret <= 1'b0; 
        enablebackup <= 1'b0;
        audioreg <= 1'b0;
        audioact <= 1'b0;
      end
      
      else
      begin
        casex (opcode)
    	
    	//ALU
    	6'bxx0xxx:
    	  begin
            we3 <= 1'b1;        //Habilitamos escritura
            s_inc <= 1'b1;      //El pc continua su ciclo normal
            s_inm <= 1'b0;      //No vienen constantes al muxtiplexor
            selentrada<= 1'b0;  //No se aceptan entradas de los disp.   
            selsalida <= 1'b0;  //La entrada al mux de salida es el bus de datos
            s_rel <= 1'b0;
            s_ret <= 1'b0; 
            enablebackup <= 1'b0;
            audioreg <= 1'b0;
            audioact <= 1'b0;
    	  end
    	  
    	//CARGA
    	6'bxx1000:
    	  begin
            we3 <= 1'b1;        //Habilitamos escritura
            s_inc <= 1'b1;      //El pc continua su ciclo normal
            s_inm <= 1'b1;      //Habilitamos la entrada de constante al mux
            selentrada<= 1'b0;  //No se aceptan entradas de los disp.   
            selsalida <= 1'b0;  //La entrada al mux de salida es el bus de datos
    	    s_rel <= 1'b0;
            s_ret <= 1'b0; 
            enablebackup <= 1'b0;
            audioreg <= 1'b0;
            audioact <= 1'b0;
    	  end
    	  
        //SALTO INCONDICIONAL
        6'b001001:
          begin
            we3 <= 1'b0;        //Escritura inhabilitada
            s_inc <= 1'b0;      //El pc recibe la direccion de la instruccion
            s_inm <= 1'b0;      //No vienen constantes del multiplexor
            selentrada<= 1'b0;  //No se aceptan entradas de los disp.   
            selsalida <= 1'b0;  //La entrada al mux de salida es el bus de datos
    	    s_rel <= 1'b0;
            s_ret <= 1'b0; 
            enablebackup <= 1'b0;
            audioreg <= 1'b0;
            audioact <= 1'b0;
    	  end
    	  
    	//SALTO CONDICIONAL SI ZERO
    	6'b001010:
    	  begin
          //Z da un 1 cuando la salida del ALU es 0
    	    we3 <= 1'b0;		//Escritura inhabilitada
    	    s_inm <= 1'b0;		//No vienen constantes al multiplexor	  
    	    selentrada <= 1'b0; //No se aceptan entradas de los disp.
            selsalida <= 1'b0;  //La entrada al mux de salida es el bus de datos
            s_rel <= 1'b0;
            s_ret <= 1'b0; 
            enablebackup <= 1'b0;
            audioreg <= 1'b0;
            audioact <= 1'b0;

    	    if(z == 1'b1)
    	      s_inc <= 1'b0;   //El pc recibe la direccion de la instruccion
    	    else
    	      s_inc <= 1'b1;   //El pc continua su ciclo normal

    	  end

    	//SALTO CONDICIONAL NO ZERO
    	6'b001011:
    	  begin
          //Z da un 1 cuando la salida del ALU es 0
            we3 <= 1'b0;    //Escritura inhabilitada
            s_inm <= 1'b0;  //No vienen constantes al multiplexor
            selentrada <= 1'b0;  //No se aceptan entradas de los disp.
            selsalida <= 1'b0;  //La entrada al mux de salida es el bus de datos
            s_rel <= 1'b0;
            s_ret <= 1'b0; 
            enablebackup <= 1'b0;
            audioreg <= 1'b0;
            audioact <= 1'b0;

    	    if(z != 1'b1)
    	       s_inc <= 1'b0;  //El pc recibe la direccion de la instruccion
    	    else
    	       s_inc <= 1'b1;  //El pc continua su ciclo normal
    	  end  

        //LECTURA ENTRADA
        6'b001100:
          begin
            we3 <= 1'b1;        //Habilitamos escritura
            s_inc <= 1'b1;      //El pc continua su ciclo normal
            s_inm <= 1'b0;      //No vienen constantes del multiplexor    
            selentrada <= 1'b1; //Se aceptan entradas de los dispositivos
            selsalida <= 1'b0;  //La entrada al mux de salida es el bus de datos
            s_rel <= 1'b0;
            s_ret <= 1'b0; 
            enablebackup <= 1'b0;
            audioreg <= 1'b0;
            audioact <= 1'b0;
          end   

    	//ESCRIBIR EN SALIDA DESDE REGISTRO
    	6'b001101:
    	  begin
            we3 <= 1'b0;        //Deshabilitamos escritura
            s_inc <= 1'b1;      //El pc continua su ciclo normal
            s_inm <= 1'b0;      //No vienen constantes del multiplexor
            selentrada <= 1'b0; //No se aceptan entradas de los disp.  
            selsalida <= 1'b1;  //Se espera que salga por salida rd2
            s_rel <= 1'b0;
            s_ret <= 1'b0; 
            enablebackup <= 1'b0;
            audioreg <= 1'b0;
            audioact <= 1'b0;
            case (puerto1)
                2'b00:
                    enable0 <= 1'b1;   

                2'b01: 
                    enable1 <= 1'b1;

                2'b10: 
                    enable2 <= 1'b1;
                    
                2'b11: 
                    enable3 <= 1'b1;
            endcase 	
    	  end	  

        //ESCRIBIR EN SALIDA CONSTANTE INMEDIATA
        6'b001110:
          begin
            we3 <= 1'b0;        //Deshabilitamos escritura
            s_inc <= 1'b1;      //El pc continua su ciclo normal
            s_inm <= 1'b0;      //No vienen constantes del multiplexor
            selentrada <= 1'b0;  //No se aceptan entradas de los disp.      
            selsalida <= 1'b0;  //La entrada al mux de salida es el bus de datos
            s_rel <= 1'b0;
            s_ret <= 1'b0; 
            enablebackup <= 1'b0;
            audioreg <= 1'b0;
            audioact <= 1'b0;
            case (puerto1)
                2'b00:
                    enable0 <= 1'b1;   

                2'b01: 
                    enable1 <= 1'b1;

                2'b10: 
                    enable2 <= 1'b1;
                    
                2'b11: 
                    enable3 <= 1'b1;
            endcase 

          end

        //SALIDA INDIRECTA DESDE REGISTROS
        6'bxx1111:
          begin
            we3 <= 1'b0;        //Deshabilitamos escritura
            s_inc <= 1'b1;      //El pc continua su ciclo normal
            s_inm <= 1'b0;      //No vienen constantes del multiplexor
            selentrada <= 1'b0; //No se aceptan entradas de los disp.  
            selsalida <= 1'b1;  //Se espera que salga por salida rd2
            s_rel <= 1'b0;
            s_ret <= 1'b0; 
            enablebackup <= 1'b0;
            audioreg <= 1'b0;
            audioact <= 1'b0;
            case (puerto2)
                2'b00:
                    enable0 <= 1'b1;   

                2'b01: 
                    enable1 <= 1'b1;

                2'b10: 
                    enable2 <= 1'b1;
                    
                2'b11: 
                    enable3 <= 1'b1;
            endcase     
          end   
         //SALTO RELATIVO
         6'b011001:
          begin
            we3 <= 1'b0;        //Deshabilitamos escritura
            s_inc <= 1'b1;      //El pc continua su ciclo normal
            s_inm <= 1'b0;      //No vienen constantes del multiplexor
            selentrada <= 1'b0;  //No se aceptan entradas de los disp.      
            selsalida <= 1'b0;  //La entrada al mux de salida es el bus de datos
            s_rel <= 1'b1; //SALTO RELATIVO
            s_ret <= 1'b0; 
            enablebackup <= 1'b0;
            audioreg <= 1'b0;
            audioact <= 1'b0;
        end

        //SALTO A SUBRUTINA        
        6'b011010:
          begin
            we3 <= 1'b0;        //Deshabilitamos escritura
            s_inc <= 1'b0;      //El pc cambia su ciclo
            s_inm <= 1'b0;      //No vienen constantes del multiplexor
            selentrada <= 1'b0;  //No se aceptan entradas de los disp.      
            selsalida <= 1'b0;  //La entrada al mux de salida es el bus de datos
            s_rel <= 1'b0; //SALTO RELATIVO
            s_ret <= 1'b0;
            enablebackup <= 1'b1;
            audioreg <= 1'b0;
            audioact <= 1'b0;
        end

        //RETORNO A SUBRUTINA
        6'b011011:
          begin
            we3 <= 1'b0;        //Deshabilitamos escritura
            s_inc <= 1'b0;      //El pc cambia su ciclo
            s_inm <= 1'b0;      //No vienen constantes del multiplexor
            selentrada <= 1'b0;  //No se aceptan entradas de los disp.      
            selsalida <= 1'b0;  //La entrada al mux de salida es el bus de datos
            s_rel <= 1'b0; //SALTO RELATIVO
            s_ret <= 1'b1; 
            enablebackup <= 1'b0;
            audioreg <= 1'b0;
            audioact <= 1'b0;
        end     

        //Leer entradas a audio reg
        6'b011100:
           begin
            we3 <= 1'b0;        //Deshabilitamos escritura
            s_inc <= 1'b1;      //El pc cambia su ciclo
            s_inm <= 1'b0;      //No vienen constantes del multiplexor
            selentrada <= 1'b0;  //No se aceptan entradas de los disp.      
            selsalida <= 1'b0;  //La entrada al mux de salida es el bus de datos
            s_rel <= 1'b0; //SALTO RELATIVO
            s_ret <= 1'b0; 
            enablebackup <= 1'b0;
            audioreg <= 1'b1;
            audioact <= 1'b0;
          end     

        
        //REPRODUCIR AUDIO DESDE REGISTRO   
        6'b011101:
           begin
            we3 <= 1'b0;        //Deshabilitamos escritura
                  
            s_inm <= 1'b0;      //No vienen constantes del multiplexor
            selentrada <= 1'b0;  //No se aceptan entradas de los disp.      
            selsalida <= 1'b0;  //La entrada al mux de salida es el bus de datos
            s_rel <= 1'b0; //SALTO RELATIVO
            s_ret <= 1'b0; 
            enablebackup <= 1'b0;
            audioreg <= 1'b0;
            audioact <= 1'b1;
            if(continue==1'b1)
               s_inc <= 1'b1;//El pc cambia su ciclo
            else
               s_inc <= 1'b0;
           end
        
    	//DEFECTO
    	default:
    	  begin
    	    we3 <= 1'b0;		//Escritura inhabilitada
    	    s_inm <= 1'b0;		//No vienen constantes del multiplexor   	  
    	    s_inc <= 1'b1;		//El pc continua su ciclo normal
    	    selentrada<= 1'b0;	//No se aceptan entradas de los disp.
    	    selsalida <= 1'b0;	//La entrada del mux de salida es el bus de datos
    	    s_rel <= 1'b0;
            s_ret <= 1'b0; 
            enablebackup <= 1'b0;	
            audioreg <= 1'b0;
				audioact <= 1'b1;
            end
        endcase
      end	
    end
endmodule
