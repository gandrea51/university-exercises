#include <stdio.h>
#include <stdlib.h>
#include <omp.h>
#include <cuda.h>
#include <cuda_runtime.h>

// Kernel CUDA
__global__ void saxpy(long n, float a_d, float *X_d, float *Y_d) {
    // id = ID blocco corrente nella grigla * #Thread totali in ogni blocco + ID thread specifico nel proprio blocco
    long id = blockIdx.x * blockDim.x + threadIdx.x;

    // Evito accessi out of bound in memoria
    if (id < n) {
        // Ogni thread gestisce un elemento SIMT
        Y_d[id] = a_d * X_d[id] + Y_d[id];
    }
}

int main() {
    float *X, *Y, *X_d, *Y_d;       // dati Host e dati Device
    float a;
    double t0, t1, dt0, dt1, sum;
    int nthrperblock;
    long L, nblock;

    a = 17.17f;
    L = 1e8;
    sum = 0.0;

    // Allocate X,Y each of length L
    if (posix_memalign((void**)&X, 4096, L*sizeof(float)) != 0) {
        perror("Error: allocation X fail.");
        exit(EXIT_FAILURE);
    }
    if (posix_memalign((void**)&Y, 4096, L*sizeof(float)) != 0) {
        perror("Error: allocation X fail.");
        free(X);
        exit(EXIT_FAILURE);
    }

    // Init X,Y
    srand48(1999);
    for (long ii = 0; ii < L; ii++) {
        X[ii] = (float)drand48();
        Y[ii] = (float)drand48();
    }

    /*
        Confugurazione CUDA
        nthrperblock, #thread per ciascun blocco
        nblock, #blocci necessari
    */
    nthrperblock = 128;         // Max: 1024
    dim3 threadblock(nthrperblock, 1, 1);

    nblock = ((L%nthrperblock) == 0) ? (L/nthrperblock) : (L/nthrperblock)+1;
    dim3 gridblock(nblock, 1, 1);

    // Allocazione X,Y sulla GPU
    cudaMalloc((void**)&X_d, L*sizeof(float));
    cudaMalloc((void**)&Y_d, L*sizeof(float));

    t0 = omp_get_wtime();

    // Trasferimento dati CPU -> GPU
    cudaMemcpy(X_d, X, L*sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(Y_d, Y, L*sizeof(float), cudaMemcpyHostToDevice);

    t1 = omp_get_wtime();

    // Kernel
    saxpy<<<gridblock, threadblock>>>(L, a, X_d, Y_d);

    /* 
        Sincronizzazione: 
        i kernel sono asincroni rispetto la CPU, in questo modo, l'host attende che tutti i core
        della GPU abbiano terminato
    */
    cudaDeviceSynchronize();

    // Gestione errori della GPU
    cudaError_t err = cudaGetLastError();
    if(err != cudaSuccess) {
        printf("%s\n", cudaGetErrorString(err));
    }
    dt1 = omp_get_wtime() - t1;     // Tempo di calcolo del kernel

    // Trasferimento risultati GPU -> CPU (solo Y)
    cudaMemcpy(Y, Y_d, L*sizeof(float), cudaMemcpyDeviceToHost);

    dt0 = omp_get_wtime() - t0;     // Tempo kernel + 2 trasferimenti
    for (long ii = 0; ii < L; ii++) {
        sum += Y[ii];
    }

    printf("sum: %.2f dt0: %f sec dt1: %f sec\n", sum, dt0, dt1);
    
    // Deallocazione sulla GPU
    cudaFree(X_d);
    cudaFree(Y_d);
    free(X);
    free(Y);
    return 0;
}
