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

    // File di log: verranno scritti i record per calcolare efficienza / speedup
    FILE *fp = fopen("data.dat", "w");
    if (!fp) {
        fprintf(stderr, "Error opening data.dat\n");
        free(grid);
        free(grid_new);
        exit(EXIT_FAILURE);
    }

    // Ciclo di scaling: raddoppio del #thread per iterazione
    for (int t = 1; t <= MAXNUMTHREADS; t*=2) {
        // Fisso il #thread
        omp_set_num_threads(t);

        // Inizializzazione eseguita per ogni iterazione 
        init(grid);
        memcpy(grid_new, grid, GX * GY * sizeof(double));
        
#if DUMP == 1
        // Dump iniziale: (solo per la prima esecuzione)
        if (t == 1) {
            sprintf(myfile, "video-omp/grid-%07d", 0);
            dump(grid, myfile);
        }
#endif

        t0 = omp_get_wtime();
        for (iter = 1; iter <= MAXITER; iter++) {
            
            // Parallelizzazione: divido in "strisce" la griglia lungo Y, schedule(static) -> ripartisce le righe in modo equo
            #pragma omp parallel for schedule(static)
            for (int i = HY; i < HY + GLY; i++) {
                for (int j = HX; j < HX + GLX; j++) {

                    // Controllo bordo
                    if ((j >= GX - HX - 1 - K) && (j < GX - HX)) {
                        continue;
                    }

                    int index = i * GX + j;
                    grid_new[index] = (grid[index] + grid[index - GX] + grid[index + GX] + grid[index - 1] + grid[index + 1]) / 5.0;
                }
            }
#if DUMP == 1
            // Dump intermedio: (solo per la prima iterazione)
            if (t == 1 && iter % DUMPSTEP == 0) {
                sprintf(myfile, "video-omp/grid-%07d", iter);
                dump(grid_new, myfile);
            }
#endif
            tmp = grid;
            grid = grid_new;
            grid_new = tmp;
        }
        dt = (omp_get_wtime() - t0) * 1.e3;

#if DUMP == 1
        // Dump finale: (solo per la prima iterazione)
        if (t == 1) {
            sprintf(myfile, "video-omp/grid-%07d", MAXITER);
            dump(grid, myfile);
        }
#endif

        // Statistiche: aggiunta del #thread corrente
        printf("[Statistics] %dx%d %d iter %d threads dT: %.6f msec GFLOPs: %.2f\n", GLX, GLY, MAXITER, t, dt, (5.0 * (double)MAXITER * (double)GLX * (double)GLY) / (dt*1e6));
        
        // Statistiche per i grafici: tempo totale in micro secondi
        fprintf(fp, "%d %d %d %.8f\n", GLX, t, MAXITER, dt*1e3);
    }
 
    fclose(fp);     // Chiusura file di log
    free(grid);
    free(grid_new);
    return 0;
}
