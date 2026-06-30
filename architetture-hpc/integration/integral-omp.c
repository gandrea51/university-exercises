#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <omp.h>
#define MAXNUMTHREADS 16

inline double f(double x) {
    return sin(x);
}

inline double F(double x) {
    return -cos(x);
}

int main() {
    double a, b, S, dx;
    double xi, ve, er;
    double t0, dt;
    long n;
    int log10max;

    a = 0.0;                    // Lower bound
    b = 10.0;                   // Upper bound
    log10max = 8;               // log10 of max number of intervals
    n = 100000000;              // #intervalli fissato per rendere trascurabile l'overhead OpenMP
    dx = (b - a) / n;

    FILE *fp = fopen("data.dat", "w");
    if (fp == NULL) {
        perror("Error open data.dat");
        return EXIT_FAILURE;
    }

    for (int t = 1; t <= MAXNUMTHREADS; t++) {     
        S = 0.0;
        omp_set_num_threads(t);
        
        t0 = omp_get_wtime();

        /*
            Parallelizzazione: reduction(+:S) private(xi) schedule(static)
            1. S e' condivisa, se piu' thread provano a scrivere insieme su S -> corruzione dati. Si ordina a OpenMP
            di creare una copia privata (a 0) per ogni thread e alla fine, somma tutti i parziali

            2. Variabile xi privata per ogni thread: se fosse condivisa, ognuno sovrascrive il valore di un altro

            3. Suddivide lo spazio delle iterazioni in blocchi contigui e omogenei, assegnandoli ai thread: perfetto load balancing
            azzerando overhead di sincronizzazione
        */

        #pragma omp parallel for reduction(+:S) private(xi) schedule(static)
        for (long ii = 1; ii <= n; ii++) {
            // Sampling at the begin of the interval including b
            xi = a + (double)ii * dx;

            // Dipendenza Read after Write
            S += f(xi) * dx;
        }
        dt = omp_get_wtime() - t0;

        ve = F(b) - F(a);               // Exact value
        er = fabs(S - ve) / fabs(ve);   // Relative error
        printf("t: %ld S: %.10f ve: %.10f err: %e dt: %f msec\n", t, S, ve, er, dt * 1e3);
        fprintf(fp, "%d %d %ld %f\n", t, t, n, dt);
    }

    fclose(fp);
    return 0;
}
