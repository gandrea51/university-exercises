#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>

__global__ void add(double *c, double *a, double *b){
        int i = threadIdx.x;
        c[i]=a[i]+b[i];
}

int main(int argc, char *argv[]){
    int N = 1024;
    double *a_h, *b_h, *c_h, *a_d, *b_d, *c_d;

    printf("Allocazione memoria host\n");
    a_h = (double *)malloc(N*sizeof(double));
    b_h = (double *)malloc(N*sizeof(double));
    c_h = (double *)malloc(N*sizeof(double));
    for (int i = 0; i < N; i++) {
        a_h[i] = i;
        b_h[i] = i*2;
    }

    printf("Allocazione memoria device\n");
    cudaMalloc((void **) &a_d, N*sizeof(double));
    cudaMalloc((void **) &b_d, N*sizeof(double));
    cudaMalloc((void **) &c_d, N*sizeof(double));

    printf("Copia Host -> Device\n");
    cudaMemcpy(a_d, a_h, N*sizeof(double), cudaMemcpyHostToDevice);
    cudaMemcpy(b_d, b_h, N*sizeof(double), cudaMemcpyHostToDevice);

    printf("Lancio kernel\n");
    add<<<1,N>>>(c_d, a_d, b_d);

    printf("Kernel eseguito, Copia Device -> Host\n");
    cudaMemcpy(c_h, c_d, N*sizeof(double), cudaMemcpyDeviceToHost);

    printf("Primi risultati\n");
        for (int i = 0; i < 10; i++) {
        printf("c_h[%d] = %f\n", i, c_h[i]);
    }

    printf("Deallocazione memoria\n");
    cudaFree(a_d);
    cudaFree(b_d);
    cudaFree(c_d);
    free(a_h);
    free(b_h);
    free(c_h);

    printf("Termine\n");
    return 0;
}

