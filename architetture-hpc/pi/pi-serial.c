#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <omp.h>

int main() {
    double dx, sum, xi, pi;
    double t0, dt;
    long n_steps;

    n_steps = 100000000;            // #Intervalli
    dx = 1.0 / (double)n_steps;
    sum = 0.0;

    t0 = omp_get_wtime();

    // Calcolo integrale sul metodo delle somme di Riemann al punto medio
    for (long i = 1; i <= n_steps; i++) {
        // Sampling f(x) at the middle of the interval
        xi = (i - 0.5) * dx;

        // Dipendenza Read after Write
        sum += 4.0 / (1.0 + xi*xi);
    }
    
    // Moltiplicazione finale per l'ampiezza dell'intervallo
    pi = dx * sum;
    dt = omp_get_wtime() - t0;

    printf("dt: %f sec pi: %f\n", dt, pi);
    return 0;
}
