#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <omp.h>

#define PI 3.14159265358979323846
#define MAXNUMTHREAD 16

inline double f(double x) {
    return sin(x);
}

int main() {
    double a, b, h, dx;
    double t0, dt;
    long n;
    double *Y;

    a = 0.1;            // Lower bound
    b = 2 * PI;         // Upper bound
    n = 10000000;       // Number of intervals: aumentato per dare piu' lavoro
    h = 1e-6;
    dx = (b - a) / n;

    // Memory allocation
    if (posix_memalign((void**)&Y, 4096, (n + 1) * sizeof(double)) != 0) {
        perror("ERROR: allocation failed.");
        exit(EXIT_FAILURE);
    }

    FILE *fd = fopen("data.dat", "w");
    if (fd == NULL) {
        perror("ERROR opening benchmark file");
        exit(EXIT_FAILURE);
    }

    for (int t = 1; t <= MAXNUMTHREAD; t++) {
        omp_set_num_threads(t);
        t0 = omp_get_wtime();

        /*
            Parallelizzazione
            i privata per ogni thread e Y e' condiviso
        */
        #pragma omp parallel for
        for (long i = 0; i <= n; i++) {
            // Sampling at the beginning of the interval including b
            double xi = a + i * dx;

            // Central difference formula
            Y[i] = (f(xi + h) - f(xi - h)) / (2.0 * h);
        }
        dt = omp_get_wtime() - t0;
        fprintf(fd, "%d %d %ld %f\n", t, t, n, dt);
        printf("t: %d dt: %f msec\n", t, dt * 1e3);
        
    }
    // Write the results on file
    FILE *fp = fopen("/dev/null", "w");

    if (fp == NULL) {
        perror("ERROR opening file.");
        free(Y);
        exit(EXIT_FAILURE);
    }

    for (long i = 0; i <= n; i++) {
        fprintf(fp, "%f %f\n", a + i * dx, Y[i]);
    }
    fclose(fp);
    
    fclose(fd);
    return 0;
}
