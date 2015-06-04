#include <stdio.h>
//#include "sys/alt_timestamp.h"
//#include "alt_types.h"
#include <stdlib.h>
void suavizadoMedia(unsigned int *pmatrizInicialb,unsigned int *pmatrizResultadob,unsigned int **pmatrizResultadof, int anchoInicial, int altoInicial, int dimensionFiltro);

int main()
{
	unsigned int *pmatrizInicialb = 0; // Puntero que apunta al primer elemento de la matriz inicial
	unsigned int *pmatrizInicialf = 0; // Puntero que apunta a  la siguiente dirección a la última posición con valor de la matriz inicial
	unsigned int *matrizResultadob = 0; // Puntero que apunta al primer elemento de la matriz resultado
	unsigned int *matrizResultadof = 0;  // Puntero que apunta al ultimo elemento de la matriz resultado
	unsigned int ancho = 20, alto = 20;
	unsigned int *pbsram = 0; // Puntero qeu apuntará a la primera dirección de la memoria sram
	unsigned int *pbdsram = 0; // Puntero qeu apuntará a la primera dirección de la memoria sdram
	unsigned int *pmsram = 0;  // Puntero que se usa para comparar el ultimo valor que se puede tomar de la memoria sram
    unsigned int *pmdsram = 0; // Puntero que se usa para comparar el ultimo valor que se puede tomar de la memoria sdram
	unsigned int *pmatriz= 0; // Puntero que apunta a  la siguiente dirección a la última posición con valor de la matriz inicial


	pbdsram = (unsigned int*) 0x01000000;
    pbsram =(unsigned int*) 0x00100000;
	pmdsram = (unsigned int*) 0x017fffff;
    pmsram =(unsigned int*) 0x0017ffff;
	int i=0;
	unsigned int *a = pbdsram;
	pmatrizInicialb = pbdsram;
	for (;i < ancho*alto;i++)
	{
		*a = i;
		// printf("%d\n",*a);
		pmatrizInicialf = a;
		a++;
	}
	a--;
	printf("%d\t%d",*a,i);
	matrizResultadob = a; // La matriz resultado se guarda en la siguiente posición al último elemento de la matriz inicial
	/*alt_u32 timer;
	//MARICONA
	alt_timestamp_start();
	/*
	suavizadoMedia(matrizInicial,filtro, matrizResultado,ancho,alto,3);
	printf("%u", (unsigned int)timer);
	printf("\n");
	for(i = 0; i < 18; i++)
		for(j = 0; j < 18; j++)
		{
			printf("%u\t",matrizResultado[i*18+j]);
			if(j == 17)
				printf("\n");
		}
    */
return 0;
}


void suavizadoMedia(unsigned int *pmatrizInicialb,unsigned int *pmatrizResultadob,unsigned int **pmatrizResultadof, int anchoInicial, int altoInicial, int dimensionFiltro)
{

	int media;
	int i,j,x,y;
	unsigned int *pauxmatrizInicial = 0;
	unsigned int *pauxmatrizResultado = pmatrizResultadob;
	for(i = (dimensionFiltro/2); i < anchoInicial- (dimensionFiltro/2);i++)
	{
		for(j = (dimensionFiltro/2); j < altoInicial-(dimensionFiltro/2); j++)
		{
			media = 0;
			// desde -1 hasta 1 en caso de 3x3
			for(x = -(dimensionFiltro/2); x < (dimensionFiltro/2)+1; x ++)
			{
				for(y = -(dimensionFiltro/2); y < (dimensionFiltro/2)+1; y++)
				{
				    pauxmatrizInicial =  pmatrizInicialb;
				    pauxmatrizInicial = pauxmatrizInicial + ((i*anchoInicial + j) + (x * anchoInicial + y));
					media += *pauxmatrizInicial;
				}
			}
            *pmatrizResultadof =  pauxmatrizResultado; // Se mueve el puentero hacia la ultima posicion del ultimo elemento de la matriz resultado internamente en la funcion
			*pauxmatrizResultado = media/(dimensionFiltro*dimensionFiltro);
            pauxmatrizResultado = pauxmatrizResultado + 1;
		}
	}
}
