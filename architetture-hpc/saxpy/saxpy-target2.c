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

    // Allocazione degli array nella GPU
    #pragma omp target enter data map(alloc: X[0:L])
    #pragma omp target enter data map(alloc: Y[0:L])

    t0 = omp_get_wtime();

    // Trasferimento dei dati CPU -> GPU
    #pragma omp target update to(X[0:L])
    #pragma omp target update to(Y[0:L])

    // Parallelizzazione kernel
    #pragma omp target teams distribute parallel for
    for (long ii = 0; ii < L; ii++) {
        Y[ii] = a * X[ii] + Y[ii];
    }

    // Trasferimento dei dati GPU -> CPU (solo Y)
    #pragma omp target update from(Y[0:L])

    dt = omp_get_wtime() - t0;

    // Deallocazione degli array sulla GPU
    #pragma omp target exit data map(release: X[0:L])
    #pragma omp target exit data map(release: Y[0:L])

    // Sum all Y just to use this data (this runs on the host)
    for (long ii = 0; ii < L; ii++) {
        sum += Y[ii];
    }

    printf("sum: %.2f dt: %f sec\n", sum, dt);
    free(X);
    free(Y);
    return 0;
}
