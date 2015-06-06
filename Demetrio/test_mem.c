#include <stdio.h>
#include <stdlib.h>
#include <sys/alt_timestamp.h>
#include <alt_types.h>
#include <io.h>

int main(void){

	//IOWR_32DIRECT(0x00800000, OFFSET*i, 1); //Direccion base de la memoria, desplazamiento y dato a escribir
	//IORD_32DIRECT(0x00000000, 0); //Direccion base de la memoria y desplazamiento (lectura)
	alt_u32 time1;
	alt_u32 time2;
	alt_u32 time3;
	alt_u32 time4;
	alt_u32 time5;
	alt_u32 time6;
	alt_u8 OFFSET=sizeof(int);
	int pruebas=200;
	int i,j;

	if (alt_timestamp_start() < 0)
	{
		printf ("No timestamp device available\n");
	}
	else
	{
		time1 = alt_timestamp();
		//Podemos hacerlo asi o con puntero
		for(i=0; i<pruebas; i++)
			IOWR_32DIRECT(0x01000000, OFFSET*i, 1); //Direccion base de la memoria, desplazamiento y dato a escribir

		time2 = alt_timestamp();
		for(j=0; j<pruebas; j++)
			IOWR_32DIRECT(0x00100000, OFFSET*j, 1); //Direccion base de la memoria, desplazamiento y dato a escribir
		time3 = alt_timestamp();
		printf ("time in write in SDRAM = %u ticks\n", (unsigned int) (time2 - time1));
		printf ("time in write in SRAM = %u ticks\n", (unsigned int) (time3 - time2));
		//LECTURA
		time4 = alt_timestamp();
		for(i=0; i<pruebas; i++)
			IORD_32DIRECT(0x01000000, OFFSET*i); //Direccion base de la memoria, desplazamiento y dato a escribir

		time5 = alt_timestamp();
		for(j=0; j<pruebas; j++)
			IORD_32DIRECT(0x00100000, OFFSET*j); //Direccion base de la memoria, desplazamiento y dato a escribir
		time6 = alt_timestamp();
		printf ("time in read in SDRAM = %u ticks\n", (unsigned int) (time5 - time4));
		printf ("time in read in SRAM = %u ticks\n", (unsigned int) (time6 - time5));
	}

	return 0;
}
