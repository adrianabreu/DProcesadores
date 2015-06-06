/*
 * pgm4.c
 *
 *  Created on: 24/04/2013
 *      Author: Pedro Toledo
 */
/*
 This is a distributed version of pgm read/write functions.
 pgmread(), pgmwrite(), pgmread2(), pgmwrite2() was revised by Ozy, who is
 the TA of CECS365 in Univ. of Missouri-Columbia.
 ppmwrite2() was writen by Hai Jiang, just a little change from pgmwrite2().
*/
#include "pgm4.h"

/* unsigned char* pgmread(char* filename, int* w, int* h)
 *
 * Reads a binary or ascii pgm file and returns a pointer to the
 * image in 2D matrix (wxh) which are the width and height
 * returned through the pointers that are given.  The calling
 * function has responsibility to free the memory pointed to by
 * the returned value.  A NULL is returned in the case of failure to
 * correctly read the file.
 *
 * NOTE: the image buffer returned is in column dominant format
 */

unsigned char** pgmread(char* filename, int* w, int* h)
{
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

/* write a binary pgm or an ascii pgm file with the comment string in the header
 * int pgmwrite(char* filename, int w, int h, unsigned char* data,
 *     			char* comment_string, int binsave)
 * Writes a binary  pgm file to the file name given
 * and returns a 0 if successful.  Input parameters are the pointer to 2D matrix
 * with wxh dimension, w and h are the  width and height respectively.
 * The comment string should be passed as NULL if no comments are to be included.
 * Setting binsave = 1 will save the file as binary pgm, else it is ascii pgm.
 *
 * NOTE: this function assumes input bufefr "data" is in column dominant format.
 */

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




/* unsigned char* pgmread2(char* filename, int* row, int* col)
 *
 * Reads a binary or ascii pgm file and returns a pointer to the
 * image in 2D matrix (row x col) which are the width and height
 * returned through the pointers that are given.  The calling
 * function has responsibility to free the memory pointed to by
 * the returned value.  A NULL is returned in the case of failure to
 * correctly read the file.
 *
 * NOTE: the image buffer returned is in row dominant format
 */

unsigned char** pgmread2(char* filename, int* row, int* col)
{
    FILE* file;
    char line[256];
    int maxval;
    int binary;
    int nread;
    int i,j, int_tmp;
    char firstchar;

    unsigned char** data;
    unsigned char*  bindata;
    if ((file = fopen(filename, "rw")) == NULL)
	{
	    printf("ERROR: file open failed\n");
	    *row = *col = 0;
	    return(NULL);
	}
    fgets(line, 256, file);
    if (strncmp(line,"P5", 2))
	{
	    if (strncmp(line,"P2", 2))
		{
		    printf("pgm read: not a pgm file\n");
		    *row = *col = 0;
		    return(NULL);
		}
	    else
		binary = 0;
	}
    else
	binary = 1;

    fgets(line, 256, file);printf("%s\n", line);
    while (line[0] == '#')
    {fgets(line, 256, file);printf("%s\n", line);}



    sscanf(line,"%d", col);
    sscanf(line,"%d", row);
    fgets(line, 256, file);
    sscanf(line, "%d", &maxval);
    printf("row = %d\tcol = %d\tmaxval = %d\n", *row, *col, maxval);


    if ((data = (unsigned char**)calloc((*row), sizeof(unsigned char*))) == NULL)
    {
	printf("Memory allocation error. Exit program\n");
	exit(1);
    }
    for (j=0 ; j < (*row); j++)
        if ((data[j] = (unsigned char*)calloc((*col), sizeof(unsigned char))) == NULL)
        {
	   printf("Memory allocation error. Exit program\n");
	   exit(1);
        }


    if (binary)
    {
	if ((bindata = (unsigned char*)calloc((*row)*(*col), sizeof(unsigned char))) == NULL)
        {
	   printf("Memory allocation error on bindata. Exit program\n");
	   exit(1);
        }

	printf("Reading %s as binary.\n", filename);

	nread = fread((void*)bindata, sizeof(unsigned char), (*row)*(*col), file);


        for(i=0; i< (*row); i++)
	   for(j=0; j< (*col); j++)
               data[i][j] = (unsigned char)bindata[(i*(*col))+j];

	free(bindata);
    }
    else {



	printf("Reading %s as ascii.\n", filename);

        for (j = 0; j < (*row); j++)
	{
            for (i = 0; i < (*col); i++)
	    {
		fscanf(file,"%d", &int_tmp);
		data[j][i] = (unsigned char)int_tmp;

	    }

        }

    }


    fclose(file);
    return(data);
}

/* write a binary pgm or an ascii pgm file with the comment string in the header
 * int pgmwrite(char* filename, int row, int col, unsigned char* data,
 *     			char* comment_string, int binsave)
 * Writes a binary  pgm file to the file name given
 * and returns a 0 if successful.  Input parameters are the pointer to 2D matrix
 * with rowxcol dimension, w and h are the  width and height respectively.
 * The comment string should be passed as NULL if no comments are to be included.
 * Setting binsave = 1 will save the file as binary pgm, else it is ascii pgm.
 *
 * NOTE: this function assumes input bufefr "data" is in row dominant format.
 */

int pgmwrite2(char* filename, int row, int col, unsigned char** data,
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

    fprintf(file,"%d %d \n", col, row);

    maxval = 0;
    for (i = 0; i < row; i++)
        for (j=0; j < col; j++)
	    if ((int)data[i][j] > maxval)
	        maxval = (int)data[i][j];

    fprintf(file, "%d\n", maxval);

    if (binsave == 1)
    {
	temp = (unsigned char*)calloc(row*col, sizeof(unsigned char));

	for(i=0; i<row; i++)
           for(j=0; j<col; j++)
               temp[(i*col)+j]= (unsigned char)data[i][j];

        nread = fwrite((void*)temp, sizeof(unsigned char), (row*col), file);
	printf("Writing to %s as binary.\n", filename);
	free(temp);

    }else{

	printf("Writing to %s as ascii.\n", filename);

	for(j=0; j<row; j++)
	   for(i=0; i<col; i++)
	      fprintf(file,"%d ", (int)data[j][i]);

    }

    fclose(file);
    return(0);
}

int ppmwrite2(char* filename, int row, int col, unsigned char** datar,
  unsigned char** datag,unsigned char** datab,char* comment_string, int binsave)
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
      fprintf(file,"P6\n");
   else
      fprintf(file,"P3\n");

    if (comment_string != NULL)
        fprintf(file,"# %s \n", comment_string);

    fprintf(file,"%d %d \n", col, row);

    maxval = 0;
    for (i = 0; i < row; i++)
        for (j=0; j < col; j++)
            if ((int)datar[i][j] > maxval)
                maxval = (int)datar[i][j];

    maxval = 255;
    fprintf(file, "%d\n", maxval);

    if (binsave == 1)
    {
        temp = (unsigned char*)calloc(3*row*col, sizeof(unsigned char));

        for(i=0; i<row; i++)
           for(j=0; j<col; j++)
		{
                temp[3*((i*col)+j)]= (unsigned char)datar[i][j];
                temp[3*((i*col)+j)+1]= (unsigned char)datag[i][j];
                temp[3*((i*col)+j)+2]= (unsigned char)datab[i][j];
		}

        nread = fwrite((void*)temp, sizeof(unsigned char), (3*row*col), file);
        printf("Writing to %s as binary.\n", filename);
        free(temp);

    }else{

        printf("Writing to %s as ascii.\n", filename);

        for(j=0; j<row; j++)
           for(i=0; i<col; i++)
              fprintf(file,"%d %d %d ", (int)datar[j][i],(int)datag[j][i],(int)datab[j][i]);

    }

    fclose(file);
    return(0);
}

