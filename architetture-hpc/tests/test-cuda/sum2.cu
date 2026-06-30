#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>
#define THREADS_PER_BLOCK 512

__global__ void add(double* c, double* a, double *b){
    int idx = blockIdx.x * blockDim.x + threadIdx.x;
    c[idx] = a[idx] + b[idx];
}

int main (int argc, char *argv[]) {
    int N = 1024;
    double *a_h, *b_h, c_h*, *a_d, *b_d, c_d*;
    
    // Allocazione memoria, copia dei dati
    
    dim3 dimBlock(THREADS_PER_BLOCK, 1, 1);
    dim3 dimGrid(N/THREADS_PER_BLOCK, 1, 1);

    add<<<dimGrid, dimBlock>>>(c_d, a_d, b_d);

    // Copia, deallocazione
}

