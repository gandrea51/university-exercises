#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <omp.h>
#include "common.h"

int main() {
    double *grid, *grid_new, *tmp;
    double t0, dt;
    int iter;
    char myfile[256];

    // Allocazione della memoria
    grid = (double *)malloc(GX * GY * sizeof(double));      // Uso GX*GY per includere sia la griglia fisica che halo
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

    // Inizializzazione
    init_corner(grid);     // Impostazione della temperatura TC e sorgente nell'angolo
    memcpy(grid_new, grid, GX * GY * sizeof(double)); // Copia sulla seconda griglia

#if DUMP == 1
    // Dump iniziale
    sprintf(myfile, "video-serial/grid-%07d", 0);
    dump(grid, myfile);
#endif

    // Inizio dell'algoritmo di Jacobi
    t0 = omp_get_wtime();   // Tempo iniziale: esclusione dal calcolo delle fasi iniziali
    for (iter = 1; iter <= MAXITER; iter++) {
        
        // Iterazione su tutti i punti della griglia fisica
        for (int i = HY; i < HY + GLY; i++) {
            for (int j = HX; j < HX + GLX; j++) {

                // Controllo per non aggiornare l'angolo
                if (i >= IROW && j >= ICOLUMN) {
                    continue;
                }

                // Calcolo di Jacobi: media del punto stesso e dei 4 suoi vicini (Nord, Sud, Ovest, Est)
                int index = i * GX + j;
                grid_new[index] = (grid[index] + grid[index - GX] + grid[index + GX] + grid[index - 1] + grid[index + 1]) / 5.0;
            }
        }
#if DUMP == 1
        // Dump intermedio: quando eseguito, provoca un elevato overhead hardware portando quasi a un raddoppio del tempo di esecuzione 
        if (iter % DUMPSTEP == 0) {
            sprintf(myfile, "video-serial/grid-%07d", iter);
            dump(grid_new, myfile);
        }
#endif
        // Swap: griglia appena scritta -> griglia di lettura per il passo successivo
        tmp = grid;
        grid = grid_new;
        grid_new = tmp;
    }

    dt = (omp_get_wtime() - t0) * 1.e3;     // Tempo finale
    
#if DUMP == 1
    // Dump finale
    sprintf(myfile, "video-serial/grid-%07d", MAXITER);
    dump(grid, myfile);
#endif

    // Statistiche: MS totali, microsec per iterazione, GFLOPs reali (carico fisso di 5 operazione floating point per cella)    
    printf("[Statistics] %dx%d %d iter dT: %.2f msec dT/iter: %.2f usec GFLOPs: %.2f\n", GLX, GLY, MAXITER, dt, (dt*1000.0)/(double)MAXITER, (5.0 * (double)MAXITER * (double)GLX * (double)GLY) / (dt*1e6));
    
    // Pulizia
    free(grid);
    free(grid_new);
    return 0;
}
