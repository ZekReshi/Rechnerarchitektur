#include <stdio.h>
int function(int,int);

int main(){
    int a = 0x40400000;
    int b = 0x3d400000;
    function(a,b);
    return 0;
}

int function(int a,int b){
    float f0 = *(float*)(&a); //reinterpret a as float from memory
    float f1 =*(float*)(&b);
        printf("f0: %f, f1: %f\n",f0,f1);

    float f2 = 5.0;
    float f3 = 2.0;
    float f4 = 0.0;
    do{
        f2 += f3;
        f0 /=f2;
        f4 = f0*f2;
                printf("f0: %f, f2: %f, f4:%f\n",f0,f2,f4);


    } while ((f4<f1)==0);
}