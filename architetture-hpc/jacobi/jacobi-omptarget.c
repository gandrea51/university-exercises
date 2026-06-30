#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <omp.h>
#include "common.h"

int main() {
    double *grid, *grid_new;
    double t0, dt;
    int iter;
    long N;

    grid = (double *)malloc(GX * GY * sizeof(double));
    if (!grid) {
        fprintf(stderr, "Error allocation grid.\n");
        exit(EXIT_FAILURE);
    }
    grid_new = (double *)malloc(GX * GY * sizeof(double));
    if (!grid_new) {
        fprintf(stderr, "Error allocation grid_new.\n");
        free(grid);
        exit(EXIT_FAILURE);
    }
    N = (long)GX * (long)GY;    // Dimensione lineare totale

    // Allocazione sul device (sulla GPU)
    #pragma omp target enter data map(alloc: grid[0:N]) 
    #pragma omp target enter data map(alloc: grid_new[0:N])

    // Inizializzazione (sulla CPU)
    init(grid);
    memcpy(grid_new, grid, GX * GY * sizeof(double));
    
    // Copio sul device: trasferimento CPU -> GPU
    #pragma omp target update to(grid[0:N])
    #pragma omp target update to(grid_new[0:N])

    t0 = omp_get_wtime();
    // Esecuzione di Jacobi: non eseguo lo swap dei puntatori, ma eseguo due volte il kernel cambiando l'ordine delle griglie
    for (iter = 1; iter <= MAXITER; iter += 2) {
        kernel(grid_new, grid);
        kernel(grid, grid_new);
    }
    dt = (omp_get_wtime() - t0) * 1.e3;

    #pragma omp target update from(grid[0:N])

    printf("[Statistics] %dx%d %d iter dT: %.6f msec GFLOPs: %.2f\n", GLX, GLY, MAXITER, dt, (5.0 * (double)MAXITER * (double)GLX * (double)GLY) / (dt*1e6));
    printf("[Results] %d %d %.8f\n", GLX, MAXITER, dt*1e3);
    
    // Deallocazione sul device (sulla GPU)
    #pragma omp target exit data map(release: grid[0:N])
    #pragma omp target exit data map(release: grid_new[0:N])

    free(grid);
    free(grid_new);
    return 0;
}

