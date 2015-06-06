/*
 * pgm4.h
 *
 *  Created on: 24/04/2013
 *      Author: Pedro Toledo
 */

#ifndef PGM4_H_

#define PGM4_H_


#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <stddef.h>

unsigned char** pgmread(char* filename, int* w, int* h);
int pgmwrite(char* filename, int w, int h, unsigned char** data,
			char* comment_string, int binsave);
unsigned char** pgmread2(char* filename, int* row, int* col);
int pgmwrite2(char* filename, int row, int col, unsigned char** data,
			char* comment_string, int binsave);
int ppmwrite2(char* filename, int row, int col, unsigned char** datar,
  unsigned char** datag,unsigned char** datab,char* comment_string, int binsave);




#endif /* PGM4_H_ */
