#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <omp.h>

/* 
    Nessun aumento del #thread. Saxpy e' memory bound, aumentare i thread porta i core della CPU
    a competere per lo stesso bus di memoria
*/

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

    // SAXPY
    t0 = omp_get_wtime();
    // Parallelizzazione
    #pragma omp parallel for schedule(static)
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
