#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <omp.h>

#define PI 3.14159265358979323846

/*
    Funzione inline: il compilatore sostituira' la chiamata a funzione con il corpo della funzione dentro il loop
    Eliminazione dell'overhead della chiamata
*/
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
    n = 100;            // Number of intervals
    h = 1e-6;
    dx = (b - a) / n;

    /* 
        Allocate aligned memory
        Allinea l'indirizzo di partenza di Y a un multiplo di 4096 (DIM pagina):
        Dati non allineati forza la CPU a fare accessi extra e rallenta il calcolo
    */
    if (posix_memalign((void**)&Y, 4096, (n + 1) * sizeof(double)) != 0) {
        perror("ERROR: fail allocation Y.");
        exit(EXIT_FAILURE);
    }

    t0 = omp_get_wtime();
    for (long i = 0; i <= n; i++) {

        // Sampling at the beginning of the interval including b
        double xi = a + i * dx;

        /* 
            Central difference formula
            Approssima il valore della derivata f' in xi con il coefficiente angolare della retta
            secante che passa per (xi-h) e (xi+h)
        */
        Y[i] = (f(xi + h) - f(xi - h)) / (2.0 * h);
    }
    dt = omp_get_wtime() - t0;

    printf("n: %ld dt: %f msec\n", n, dt * 1e3);
    // Write the results on file
    FILE *fp = fopen("results.out", "w");

    if (fp == NULL) {
        perror("ERROR opening file.");
        free(Y);
        exit(EXIT_FAILURE);
    }

    for (long i = 0; i <= n; i++) {
        fprintf(fp, "%f %f\n", a + i * dx, Y[i]);
    }

    fclose(fp);
    free(Y);
    return 0;
}