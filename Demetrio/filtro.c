#include <stdio.h>
#include <stdlib.h>
#include <sys/alt_timestamp.h>
#include <alt_types.h>
#define N 8
#define M 10

int pos(int fila,int columna, int ancho){
	return fila*ancho+columna;
}

void rellenar_filtro(int* matfiltro,int tam, int modo){
	int i,j;

	if(modo==0){
    	for(i=0;i<tam;i++){
       		for(j=0;j<tam;j++){
       			if((i==j) && (j==(tam/2)))
       				matfiltro[pos(i,j,tam)]=2;
       			else
            	    matfiltro[pos(i,j,tam)]=1;
       		}
        }
	}
	else{
		for(i=0;i<tam;i++){
			for(j=0;j<tam;j++){
		        matfiltro[pos(i,j,tam)]=1;
	       	}
	    }
	}

}


int valornewpixel(int* matriz,int* matfiltro, int tamfiltro, int pivotei, int pivotej,int ancho){
    //SUMA DE LA MULTIPLICACION DE LA MATRIZ POR (LA MATRIZ DE FILTRO * 1/SIZE²)
    //SE HACE LA SUMA Y DESPUES SE APLICA LA FORMULA DEL FILTRO
    int valor=0,i,j,k,l;
    for( i=pivotei,k=0;k<tamfiltro;i++,k++){
        for(j=pivotej,l=0;l<tamfiltro;j++,l++){
            valor+=(matriz[pos(i,j,ancho)]*matfiltro[pos(k,l,tamfiltro)]);
        }
    }
    //printf("%d %d \n",valor,tamfiltro);
    valor=valor/(tamfiltro*tamfiltro);
    return valor;
}

void aplicarfiltro(int* matriz, int* matfiltro, int* matresult, int filasmat, int columnasmat,int tamfiltro){
	int i,j;
	int valorfori=filasmat-(tamfiltro-1);
	int valorforj=columnasmat-(tamfiltro-1);
	printf("Estoy en aplicarfiltro");
	for (i=0;i<valorfori;i++){
	    for(j=0;j<valorforj;j++){
	    	printf("%d %d ",i,j);
	    	matresult[pos(i,j,valorforj)]=valornewpixel(matriz,matfiltro,tamfiltro,i,j,columnasmat);
	    }
	}
}

void rellenar_imagen(int* matriz, int filas,int columnas){
   int i,j;
   int pixel;
   for (i=0;i<filas;i++){
   	  pixel=0;
      for(j=0;j<columnas;j++){
      	 matriz[pos(i,j,columnas)]=pixel;
      	 pixel+=255/15;
      }
   }
}

void mostrar_imagen(int* matriz,int filas, int columnas){
	int i,j;
	for (i=0; i<filas; i++){
		printf("\n");
		for(j=0; j<columnas; j++){
			printf("%d ", matriz[pos(i,j,columnas)]);
		}
	}
	printf("\n");
}

void func1(void{)
	int tamfiltro=3,modo=0;
	int matriz[80];
	int filtro[20];
	int* newmatriz;
	//----------------------------------------------------------
	//printf("Introduzca el tamaño del filtro:\n");
	//scanf("%i", &tamfiltro);
	//printf("Introduzca el modo de filtro (0 = ponderado):\n");
	//scanf("%i", &modo);
	//----------------------------------------------------------
    rellenar_imagen(matriz,N,M);
	mostrar_imagen(matriz,N,M);

	if (tamfiltro > 0){
		rellenar_filtro(filtro,tamfiltro,modo);
		//printf("Imagen filtro \n");
		//mostrar_imagen(filtro,tamfiltro,tamfiltro);

    	//printf("Hagamos malloc \n");
    	newmatriz = (int*) malloc ((N-(tamfiltro-1))*(M-(tamfiltro-1)));

    	//printf("Llego a aplicar filtro \n");
    	aplicarfiltro(matriz,filtro,newmatriz,N,M,tamfiltro);
    	mostrar_imagen(newmatriz,N-(tamfiltro-1),M-(tamfiltro-1));
	}
}
int main(void){

	alt_u32 time1;
	alt_u32 time2;
	//alt_u32 time3;
	
	if (alt_timestamp_start() < 0)
	{
		printf ("No timestamp device available\n");
	}
	else
	{
		time1 = alt_timestamp();
		func1(); /* first function to monitor */
		time2 = alt_timestamp();
		//func2(); /* second function to monitor */
		//time3 = alt_timestamp();
		printf ("time in func1 = %u ticks\n",
		(unsigned int) (time2 - time1));
		/*printf ("time in func2 = %u ticks\n",
		(unsigned int) (time3 - time2));
		printf ("Number of ticks per second = %u\n",
		(unsigned int)alt_timestamp_freq());*/
	}

	return 0;
}
