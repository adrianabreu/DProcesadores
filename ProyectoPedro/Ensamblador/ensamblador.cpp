#include <iostream>
#include <cstdlib>
#include <cmath>
#include <fstream>
#include <cstring>
#include <string>
#include "opcodes.h"

string* conv_binario(int numero){
	int dividendo, resto, divisor = 2;
	string* binario = new string("");

	dividendo = numero;
	while(dividendo >= divisor){ 
		resto = dividendo % 2;
		if(resto == 1)
		*binario = "1" + *binario; 
	else
		*binario = "0" + *binario; 
	 	
	dividendo = dividendo/divisor; 
	}
	if(dividendo == 1)
		*binario = "1" + *binario; 
	else
		*binario = "0" + *binario;
	
	//cout << "En sistema binario " << numero<< " se escribe " << *binario << endl;
	
	return binario;
}

void formatear_op(int size, string* operando){
	for(int i=0; i<size; i++)
		*operando = "0" + *operando;
}

string* formatear_salida(char* p1, char* p2, char* p3, char* p4, int mode){
		string* salida=new string;
		string* sp1=new string;
		string* sp2=new string;
		string* sp3=new string;
		string* sp4=new string;
		
		sp1=new string(p1);
		sp2=new string(p2);
		sp3=new string(p3);
		sp4=new string(p4);	
			
		if(mode==0)
			*salida=*sp1+'_'+*sp2+'_'+*sp3+'_'+*sp4;
		else if (mode==1)
			*salida=*sp1+*sp2+*sp3+*sp4;

		cout << "Codificada: " << *salida << endl;
		
	return salida;
}

string* codificar(FILE* ficherosalida,string* instruccion, int mode){
		str_inst bopcode;
		string* operando1=new string;
		string* operando2=new string;
		string* operando3=new string;
		
		char p1[5]="----",p2[5]="----",p3[5]="----",p4[5]="----";
		string *salida;
		int pos_op1=0, pos_op2=0, pos_op3=0;
		
		pos_op1= instruccion->find_first_of(' ');
		pos_op2= instruccion->find_first_of(' ',pos_op1+1);
		pos_op3= instruccion->find_first_of(' ',pos_op2+1);
		
		//cout << "Pos_op1: " << pos_op1 << " Pos_op2: " << pos_op2 << " Pos_op3: " << pos_op3 << endl;
		
		char operacion[pos_op1];
		instruccion->copy(operacion,pos_op1);
		operacion[pos_op1]='\0';
		
		bopcode=opcode(operacion); //OBTENEMOS SU OPCODE Y EL NUMERO DE OPERANDOS
		cout << "opcode: " << *bopcode.opcode << " operandos: " << bopcode.operandos << endl;
		
		if(bopcode.operandos!=-1){
			if(bopcode.opcode->size()==4){ //ALU CARGA SAL.IND.REGISTRO
				if(*bopcode.opcode=="1111"){
					char op1[5], op2[5];
					
					instruccion->copy(op1,(pos_op2-pos_op1),pos_op1+1);
					instruccion->copy(op2,(instruccion->size()-pos_op1),pos_op2+1);
					
					operando1=conv_binario(atoi(op1));
					operando2=conv_binario(atoi(op2));
					operando3=new string("0000");
					
					formatear_op(4-operando1->size(),operando1);
					formatear_op(4-operando2->size(),operando2);
					
					operando1->copy(p3,4);
					operando2->copy(p2,4);
					operando3->copy(p1,4);
				}
				else{

 				char op1[5], op2[5], op3[5];
				
				instruccion->copy(op1,(pos_op2-pos_op1),pos_op1+1);
				instruccion->copy(op2,(pos_op3-pos_op2),pos_op2+1);
				if(pos_op3!=-1)
					instruccion->copy(op3,(instruccion->size()-pos_op3),pos_op3+1);
				else
					instruccion->copy(op2,(instruccion->size()-pos_op2),pos_op2+1);
				
				//cout << op1 << " " << op2 << " " << op3 << endl;
				operando1=conv_binario(atoi(op1));
				operando2=conv_binario(atoi(op2));
				if(pos_op3!=-1)
					operando3=conv_binario(atoi(op3));
				//cout << operando1->size() << " " << operando2->size() << " " << operando3->size() << endl;
				formatear_op(4-operando1->size(),operando1);
				if(pos_op3!=-1){
					formatear_op(4-operando2->size(),operando2);
					formatear_op(4-operando3->size(),operando3);
				}
				else
					formatear_op(8-operando2->size(),operando2);
				//cout << *operando1 << " " << *operando2<< " " << *operando3 << endl;
				operando1->copy(p1,4);
				operando2->copy(p2,4);
				if(pos_op3!=-1)
					operando3->copy(p3,4);
				else
					operando2->copy(p3,4,4);
				}
				bopcode.opcode->copy(p4,4);	
			}
			else{ //SALTO, E/S, NOP
				if(bopcode.operandos==0){
					if(*bopcode.opcode=="011001"){//NOP
						operando1=new string("01");
						operando2=new string("1000");
						operando3=new string("0000");
						operando1->copy(p3,2);
					}
				}
				else if(bopcode.operandos==1){
					char op1[5], sign;
					
					instruccion->copy(op1,(instruccion->size()-pos_op1),pos_op1+1);

					if(*bopcode.opcode=="011001"){//SALTO RELATIVO
						if(atoi(op1)<0){
							operando1=conv_binario(abs(atoi(op1)));
							sign='1';
						}
						else{
							operando1=conv_binario(atoi(op1));
							sign='0';
						}
						formatear_op(9-operando1->size(),operando1);
						*operando1=sign + *operando1;
					}
					else{
						operando1=conv_binario(atoi(op1));	
						formatear_op(10-operando1->size(),operando1);
					}
					
					operando1->copy(p1,4);
					operando1->copy(p2,4,4);
					operando1->copy(p3,2,8);
					
				}
				else if(bopcode.operandos==2){
					char op1[5], op2[5];
					
					instruccion->copy(op1,(pos_op2-pos_op1),pos_op1+1);
					instruccion->copy(op2,(instruccion->size()-pos_op1),pos_op2+1);
					
					operando1=conv_binario(atoi(op1));
					operando2=conv_binario(atoi(op2));
					operando3=new string("0000");
					
					formatear_op(2-operando1->size(),operando1);	
					
					if(*bopcode.opcode=="001100"){//LECTURA A REGISTRO
						formatear_op(4-operando2->size(),operando2);
						operando1->copy(p3,2);
						operando2->copy(p1,4);
						operando3->copy(p2,4);
					}
					else if(*bopcode.opcode=="001101"){//SALIDA DESDE REGISTRO
						formatear_op(4-operando2->size(),operando2);
						operando1->copy(p3,2);
						operando2->copy(p2,4);
						operando3->copy(p1,4);
					}
					else if(*bopcode.opcode=="001110"){//SALIDA INMEDIATA
						formatear_op(8-operando2->size(),operando2);
						operando1->copy(p3,2);
						operando2->copy(p2,4,4);
						operando2->copy(p1,4);
					}
					else
						cout << "Opcode 6, 2 operandos que no es es, no implementado" << endl;
					
				}
				else{
					operando2->copy(p1,4);
					operando3->copy(p2,4);
				}
				
				bopcode.opcode->copy(p4,4,2);
				p3[3]=(bopcode.opcode->c_str())[1];
				p3[2]=(bopcode.opcode->c_str())[0];

			}
		salida=formatear_salida(p1,p2,p3,p4,modo);
		}
		else{
			cout << "INSTRUCCION DESCONOCIDA!!" << endl;
			salida=new string("XXXX_XXXX_XXXX_XXXX");
		}
		
	fprintf(ficherosalida,"%s\n",salida->c_str());
}

main(){
    char nombrefichero[20], buffer[128];
    int mode=-1;
    string* instruccionentrada;
	string* instruccionsalida=new string;
    ifstream ficheroentrada;
    FILE* ficherosalida;
    
    ficherosalida=fopen("progfile.dat","w");

	
    cout << "Introduce el nombre de fichero (con extension): ";
    cin >> nombrefichero;
    cout << "Nombre de salida (progfile.dat)"<< endl;   
    ficheroentrada.open(nombrefichero, ios::in);
	
	//ficheroentrada.open("programa.txt", ios::in);
	cout << "[0]: Modo verilog" << endl << "[1]: Modo Verilog HDL" << endl;
	cin >> mode;
	
    diccionario();
    
    if (ficheroentrada.is_open()){
        while(!ficheroentrada.eof()){
            ficheroentrada.getline(buffer,128);
            //cout << buffer << endl;
        	instruccionentrada=new string(buffer);
        	if(instruccionentrada->size()>0){
            	cout << "Instruccion: " << *instruccionentrada << endl;
            	instruccionsalida=codificar(ficherosalida,instruccionentrada,mode);
        	}                                                 
        	cout << endl;
        }
    }
	cout << "Hecho!" << endl;
    return 0;
}
