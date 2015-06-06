#include<stdio.h>
#include<stdlib.h>

int **d ;
int sum();
int main(){
    d = (int **)calloc(3,sizeof(int));
    printf("\n%d",sum());
}

int sum(){
    int s = 0;
    int i,j;
    for(i=0;i<3;i++)
    d[i] = (int *)calloc(3,sizeof(int));

    for(i=0;i<3;i++){ 
        for(j=0;j<3;j++){
            d[i][j] = i+j;
            s+=d[i][j];
            printf("\n array[%d][%d]-> %d",i,j,d[i][j]);
        }
    }
return s;

}