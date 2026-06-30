#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <omp.h>

int main() {
    float *X, *Y;
    float a;
    double t0, dt, sum;
    long L;

    a = 17.17f;
    L = 1e8;
    sum = 0.0;

    // Allocate X,Y each of length L (vettorizzazione SIMD)
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

    // SAXPY
    t0 = omp_get_wtime();

    /*
        Parallelizzazione: target teams distribute parallel for map(to: X[0:L]) map(tofrom: Y[0:L])
        target, sposta il controllo al device
        teams distribute, crea il set di Master Thread sulla GPU e distribuisce i blocci di iterazioni del loop
        parallel for, parallelizza le iterazioni assegnate a ogni team tra i singoli thread interni
        map(to), trasferimento dati via PCI CPU -> GPU
        map(tofrom), trasferimento dati via PCI prima CPU -> GPU e viceversa alla fine
    */
    #pragma omp target teams distribute parallel for map(to: X[0:L]) map(tofrom: Y[0:L])
    for (long ii = 0; ii < L; ii++) {
        Y[ii] = a * X[ii] + Y[ii];
    }
    dt = omp_get_wtime() - t0;

    // Sum all Y just to use this data (this runs on the host)
    for (long ii = 0; ii < L; ii++) {
        sum += Y[ii];
    }

    printf("sum: %.2f dt: %f sec\n", sum, dt);
    free(X);
    free(Y);
    return 0;
}
