#include <stdio.h>
#include <stdlib.h>
//#include <sys/alt_timestamp.h>
//#include <alt_types.h>
//#include "pgm4.h"
#define N 8
#define M 10

unsigned char** newmatriz;

unsigned char** pgmread(char* filename, int* w, int* h){
    FILE* file;
    char line[256];
    int maxval;
    int binary;
    int nread;
    int i,j, int_tmp;

    unsigned char** data;
    unsigned char*  bindata;
	printf("Debug: Opening image:\n");
    if ((file = fopen(filename, "r")) == NULL)
	{
	    printf("ERROR: file open failed\n");
	    *h = *w = 0;
	    return(NULL);
	} else {
		printf("Debug: Image open successfully!\n");
	}
    fgets(line, 256, file);
    if (strncmp(line,"P5", 2))
	{
	    if (strncmp(line,"P2", 2))
		{
		    printf("pgm read: not a pgm file\n");
		    *h = *w = 0;
		    return(NULL);
		}
	    else
		binary = 0;
	}
    else
	binary = 1;

    fgets(line, 256, file);
    while (line[0] == '#')
    fgets(line, 256, file);


    sscanf(line,"%d", w);
    fgets(line, 256, file);
    sscanf(line,"%d", h);
    fgets(line, 256, file);
    sscanf(line, "%d", &maxval);


    if ((data = (unsigned char**)calloc((*w), sizeof(unsigned char*))) == NULL)
    {
	printf("Memory allocation error. Exit program\n");
	exit(1);
    }
    for (j=0 ; j < (*w); j++)
        if ((data[j] = (unsigned char*)calloc((*h), sizeof(unsigned char))) == NULL)
        {
	   printf("Memory allocation error. Exit program\n");
	   exit(1);
        }


    if (binary)
    {
	if ((bindata = (unsigned char*)calloc((*w)*(*h), sizeof(unsigned char))) == NULL)
        {
	   printf("Memory allocation error on bindata. Exit program\n");
	   exit(1);
        }

	printf("Reading %s as binary.\n", filename);

	nread = fread((void*)bindata, sizeof(unsigned char), (*w)*(*h), file);

	for(i=0; i< (*w); i++)
           for(j=0; j< (*h); j++)
               data[i][j] = (unsigned char)bindata[(j*(*w))+i];

	free(bindata);
    }
    else {
	printf("Reading %s as ascii.\n", filename);

	for (i = 0; i < (*h); i++)
	{
            for (j = 0; j < (*w); j++)
	    {
		fscanf(file,"%d", &int_tmp);
		data[j][i] = (unsigned char)int_tmp;

	    }

        }

    }


    fclose(file);
    return(data);
}

int pgmwrite(char* filename, int w, int h, unsigned char** data,
			char* comment_string, int binsave)
{
    FILE* file;
    char line[256];
    int maxval;
    int binary;
    int nread;
    int i,j, int_tmp;
    unsigned char* temp;

    if ((file = fopen(filename, "w")) == NULL)
	{
	    printf("ERROR: file open failed\n");
	    return(-1);
	}

   if (binsave == 1)
      fprintf(file,"P5\n");
   else
      fprintf(file,"P2\n");

    if (comment_string != NULL)
	fprintf(file,"# %s \n", comment_string);

    fprintf(file,"%d %d \n", w, h);

    maxval = 0;
    for (i = 0; i < w; i++)
        for (j=0; j < h; j++)
	    if ((int)data[i][j] > maxval)
	        maxval = (int)data[i][j];

    fprintf(file, "%d \n", maxval);

    if (binsave == 1)
    {
	temp = (unsigned char*)calloc(w*h, sizeof(unsigned char));

	for(i=0; i<w; i++)
           for(j=0; j<h; j++)
               temp[(j*w)+i]= (unsigned char)data[i][j];

        nread = fwrite((void*)temp, sizeof(unsigned char), (w)*(h), file);
	printf("Writing to %s as binary.\n", filename);
        free(temp);

    }else{
	printf("Writing to %s as ascii.\n", filename);

	for(i=0; i<h; i++)
           for(j=0; j<w; j++)
		fprintf(file,"%d ", (int)data[j][i]);

    }

    fclose(file);
    return(0);
}

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


unsigned char valornewpixel(unsigned char** matriz,int* matfiltro, int tamfiltro, int pivotei, int pivotej){
    //SUMA DE LA MULTIPLICACION DE LA MATRIZ POR (LA MATRIZ DE FILTRO * 1/SIZE²)
    //SE HACE LA SUMA Y DESPUES SE APLICA LA FORMULA DEL FILTRO
    int i,j,k,l;
    unsigned char valor=0;
    printf("Estoy en valorn pixel \n");
    for( i=pivotei,k=0;k<tamfiltro;i++,k++){
        for(j=pivotej,l=0;l<tamfiltro;j++,l++){
        	printf("Hey estoy en %d %d \n", i, j);
        	printf("%d \n", matriz[i][j]);
        	printf("%d \n", matfiltro[pos(k,l,tamfiltro)]);
            valor+=(matriz[i][j]*matfiltro[pos(k,l,tamfiltro)]);
        }
    }
    //printf("%d %d\ n",valor,tamfiltro);
    printf("He terminado el filtro, voy a dividir entre %d \n",tamfiltro);
    valor=valor/(tamfiltro*tamfiltro);
    printf("%d \n",valor);
    return valor;
}

void aplicarfiltro(unsigned char** matriz, int* matfiltro, unsigned char** newmatriz, int filasmat, int columnasmat,int tamfiltro){
	printf("Estoy en aplicarfiltro \n");
	int i,j;
	for (i=0;i<filasmat;i++){
	    for(j=0;j<columnasmat;j++){
	    	printf("%u \n",newmatriz[i][j]);
	    	newmatriz[i][j]=valornewpixel(matriz,matfiltro,tamfiltro,i,j);
	    	printf("La asignacion ha sido correcta \n");
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

void func1(){
	int tamfiltro=3,modo=0,w,h;
	unsigned char** matriz;
	int filtro[20];
	char filename[30]="inputImage.pgm";
	char outname[30]="outputImage.pgm";
	
	unsigned char iterador;
	int ow,oh;
	
	matriz=pgmread(filename,&h,&w);

	if (tamfiltro > 0){
		rellenar_filtro(filtro,tamfiltro,modo);

    	ow=w-(tamfiltro-1);
    	oh=h-(tamfiltro-1);
    	int width;
    	width=oh;
    	printf("I will create %d rows and %d columns \n", width, width);
    	int i,j;
    	newmatriz = calloc(width, sizeof(unsigned char*));
		
        for (j=0 ; j < width; j++){
            if (( newmatriz[j] = calloc(oh, sizeof(unsigned char))) == NULL){
        	   printf("Memory allocation error. Exit program\n");
	            exit(1);
            }
           
        }
        printf("I ended creating the row %d \n", j);
        for (i=0;i<width;i++){
        	for(j=0;j<width;j++){
        		printf("%c \n",newmatriz[i][j]);
        	}
        }
        printf ("imagen leida \n");
    	aplicarfiltro(matriz,filtro,newmatriz,ow,oh,tamfiltro);
    	printf ("Aplicamos el iltro like a heros");
    	pgmwrite(outname,ow,oh,newmatriz,"",1);
    	printf ("Imagen hecha, con dos cojones");
	}
}
int main(void){

	//alt_u32 time1;
	//alt_u32 time2;
	//alt_u32 time3;
	
	/*if (alt_timestamp_start() < 0)
	{
		printf ("No timestamp device available\n");
	}
	else
	{*/
	//	time1 = alt_timestamp();
		func1(); /* first function to monitor */
	//	time2 = alt_timestamp();
		//func2(); /* second function to monitor */
		//time3 = alt_timestamp();
	//	printf ("time in func1 = %u ticks\n",
	//	(unsigned int) (time2 - time1));
		/*printf ("time in func2 = %u ticks\n",
		(unsigned int) (time3 - time2));
		printf ("Number of ticks per second = %u\n",
		(unsigned int)alt_timestamp_freq());*/
	//}

	return 0;
}
