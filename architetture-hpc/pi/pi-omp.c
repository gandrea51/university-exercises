#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <omp.h>

#define MAXNUMTHREADS 16

int main() {
    double dx, sum, xi, pi;
    double t0, dt;
    long n_steps;

    n_steps = 100000000;
    dx = 1.0 / (double)n_steps;

    FILE *fp = fopen("data.dat", "w");
    if (fp == NULL) {
        perror("Error open data.dat");
        return EXIT_FAILURE;
    }

    for (int t = 1; t <= MAXNUMTHREADS; t++) {
        sum = 0.0;
        omp_set_num_threads(t);

        t0 = omp_get_wtime();

        #pragma omp parallel for reduction(+:sum) private(xi) schedule(static)
        for (long i = 1; i <= n_steps; i++) {
            // Sampling f(x) at the middle of the interval
            xi = (i - 0.5) * dx;

            // Dipendenza Read after Write
            sum += 4.0 / (1.0 + xi*xi);
        }
        
        pi = dx * sum;
        dt = omp_get_wtime() - t0;
        printf("nt: %d dt: %f sec pi: %015f\n", t, dt, pi);
        fprintf(fp, "%d %d %ld %f\n", t, t, n_steps, dt);
    }

    fclose(fp);
    return 0;
}
