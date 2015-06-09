#include <iostream>
#include <string>
#include <map>

using namespace std;

map <string,int> opcodes;

struct str_inst{
	string* opcode;
	int operandos;
};

void diccionario(){
	opcodes["DIR"]=1; //xx0000: s = a;
	opcodes["NEG"]=2; //xx0001: s = ~a;
	opcodes["ADD"]=3; //xx0010: s = a + b;
	opcodes["SUB"]=4; //xx0011: s = a - b;
	opcodes["AND"]=5; //xx0100: s = a & b;
	opcodes["OR"]=6; //xx0101: s = a | b;
	opcodes["C2A"]=7; //xx0110: s = -a;
	opcodes["C2B"]=8; //xx0111: s = -b;
	opcodes["LOAD"]=9; //xx1000: Carga
    opcodes["IJM"]=10;//001001: Incondicional
    opcodes["CJZ"]=11;//001010: Condicional z=1
    opcodes["CJNZ"]=12;//001011: Condicional z=0
    opcodes["RIN"]=13;//001100: Leer Entrada   
    opcodes["WOUT"]=14;//001101: Escribir Salida Registro
    opcodes["WOUTI"]=15;//001110: Escribir Salida Inmediato
    opcodes["WOUTR"]=20;//xx1111: Salida indirecta
    opcodes["RJM"]=16;//011001: Salto relativo
    opcodes["SJM"]=17;//011010: Salto a subrutina
    opcodes["RSJM"]=18;//011011: Retorno
    opcodes["NOP"]=19; //1000_0000_0101_1001: No operacion
    
}

str_inst opcode(char* operacion){
	
	str_inst convertida;
	
	switch(opcodes[operacion]){
		case 1:
			cout << "CARGA POR ALU" << endl;
			convertida.opcode= new string("0000");
			convertida.operandos=3;
			break;
			
		case 2:
			cout << "NEG" << endl;
			convertida.opcode= new string("0001");
			convertida.operandos=3;
			break;
		
		case 3:
			cout << "ADD" << endl;
			convertida.opcode= new string("0010");
			convertida.operandos=3;
		break;
		
		case 4:
			cout << "SUB" << endl;
			convertida.opcode= new string("0011");
			convertida.operandos=3;
		break;
		
		case 5:
			cout << "AND" << endl;
			convertida.opcode= new string("0100");
			convertida.operandos=3;
		break;
		
		case 6:
			cout << "OR" << endl;
			convertida.opcode= new string("0101");
			convertida.operandos=3;
		break;
		
		case 7:
			cout << "C2A" << endl;
			convertida.opcode= new string("0110");
			convertida.operandos=3;
		break;
		
		case 8:
			cout << "C2B" << endl;
			convertida.opcode= new string("0111");
			convertida.operandos=3;
		break;
		
		case 9:
			cout << "CARGA" << endl;
			convertida.opcode= new string("1000");
			convertida.operandos=2;
		break;
		
		case 10:
			cout << "SALTO ABSOLUTO" << endl;
			convertida.opcode= new string("001001");
			convertida.operandos=1;
		break;
		
		case 11:
			cout << "SALTO CONDICIONAL Z=1" << endl;
			convertida.opcode= new string("001010");
			convertida.operandos=1;
		break;
		
		case 12:
			cout << "SALTO CONDICIONAL Z=0" << endl;
			convertida.opcode= new string("001011");
			convertida.operandos=1;
		break;
		
		case 13://LEER DESDE ES
			cout << "LEER DESDE ENTRADA SALIDA" << endl;
			convertida.opcode= new string("001100");
			convertida.operandos=2;
		break;
		
		case 14:
			cout << "ESCRIBIR EN ES DESDE REGISTRO" << endl;
			convertida.opcode= new string("001101");
			convertida.operandos=2;
		break;
		
		case 15:
			cout << "ESCRIBIR EN ES UN INMEDIATO" << endl;
			convertida.opcode= new string("001110");
			convertida.operandos=2;
		break;
		
		case 16:
			cout << "SALTO RELATIVO" << endl;
			convertida.opcode= new string("011001");
			convertida.operandos=1;
		break;
		
		case 17:
			cout << "SALTO A SUBRUTINA" << endl;
			convertida.opcode= new string("011010");
			convertida.operandos=1;
		break;
		
		case 18:
			cout << "RETORNO DESDE SUBRUTINA" << endl;
			convertida.opcode= new string("011011");
			convertida.operandos=0;
		break;
		
		case 19:
			cout << "NO OPERACION" << endl;
			convertida.opcode= new string("011001");
			convertida.operandos=0;
		break;
		
		case 20:
			cout << "SALIDA INDIRECTA REGISTRO" << endl;
			convertida.opcode= new string("1111");
			convertida.operandos=2;
		break;

		case 21:
			cout << "GUARDAR SONIDO EN REGISTRO" << endl;
			convertida.opcode= new string("011100");
			convertida.operandos=1;
		break;
		
		case 22:
			cout << "REPRODUCIR SONIDO" << endl;
			convertida.opcode= new string("011101");
			convertida.operandos=1;
		break;
		
		case 0:
			cout << "INDEFINIDO" << endl;
			convertida.opcode=new string("xxxx");
			convertida.operandos=-1;
		break;
	}
	return convertida;
}
