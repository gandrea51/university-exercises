#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <omp.h>

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
    log10max = 8;               // log10 of max number of intervals: da 10^1 a 10^7 intervalli

    for (int i = 1; i < log10max; i++) {
        n = (long)pow(10, i);
        dx = (b - a) / n;
        S = 0.0;
        
        t0 = omp_get_wtime();
        // Calcolo della somma di Riemann
        for (long ii = 1; ii <= n; ii++) {
            // Sampling at the begin of the interval including b
            xi = a + (double)ii * dx;

            // Dipendenza Read after Write
            S += f(xi) * dx;
        }
        dt = omp_get_wtime() - t0;

        // Validazione
        ve = F(b) - F(a);               // Exact value
        er = fabs(S - ve) / fabs(ve);   // Relative error

        // Statistics: aumenta N, l'errore err cala linearmente
        printf("n: %ld S: %.10f ve: %.10f err: %e dt: %f msec\n", n, S, ve, er, dt * 1e3);
    }

    return 0;
}
