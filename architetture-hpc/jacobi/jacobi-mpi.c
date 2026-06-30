#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <omp.h>
#include <mpi.h>
#include "common.h"

int main(int argc, char *argv[]) {
    int mpi_rank, mpi_size;
    int NX, NY, lGLY;
    int up_halo, down_halo;

    double *grid, *lgrid, *lgrid_new, *tmp;
    double t0, dt, dtmax;
    int iter;
    char myfile[256];
    FILE *fp = NULL;

    if (MPI_Init(&argc, &argv) != MPI_SUCCESS) {
        fprintf(stderr, "Error in MPI_Init.\n");
        exit(-1);
    }

    MPI_Comm_rank(MPI_COMM_WORLD, &mpi_rank);
    MPI_Comm_size(MPI_COMM_WORLD, &mpi_size);

    // Controllo che l'altezza totale (512) sia divisibile in parti uguali tra i rank: (ogni processo riceve una "fetta" di uguale spessore)
    if (GLY % mpi_size != 0) {
        if (mpi_rank == 0) {
            fprintf(stderr, "ERROR: GLY (%d) must be divisible by mpi_size (%d)\n", GLY, mpi_size);
            MPI_Abort(MPI_COMM_WORLD, -1);
        }
    }

    NX = GX;        // Larghezza locale = Larghezza totale GX
    lGLY = GLY / mpi_size;  // #Righe assegnate a ogni rank
    NY = lGLY + 2 * HY;     // Altezza locale = righe + 2 Halo

    grid = NULL;
    // Allocazione sottomatrici locali (con halo)
    lgrid = (double *)malloc(NX * NY * sizeof(double));
    lgrid_new = (double *)malloc(NX * NY * sizeof(double));
    if (!lgrid || !lgrid_new) {
        fprintf(stderr, "[RANK %d] Allocation fail\n", mpi_rank);
        MPI_Abort(MPI_COMM_WORLD, -1);
    }

    // Allocazione griglia iniziale (solo Rank 0)
    if (mpi_rank == 0) {
        grid = (double *)malloc(GX * GY * sizeof(double));
        if (!grid) {
            fprintf(stderr, "Grid allocation fail\n");
            MPI_Abort(MPI_COMM_WORLD, -1);
        }
        init(grid);

#if DUMP == 1
        sprintf(myfile, "video-2mpi/grid-%07d", 0);
        dump(grid, myfile);
#endif
        fp = fopen("data3.dat", "w");
        if (!fp) {
            fprintf(stderr, "Error opening data.dat\n");
            exit(EXIT_FAILURE);
        }
    }

    /*
        Scatter: Suddivisione della griglia: rank 0 -> altri rank 
        Rank 0: legge grid globale, invio di blocchi con lGLY righe larghe NX
        Destinatario: lgrid + (NX * HY): non scrive all'inizio (halo), ma dopo NX*HY, nella prima riga fisica 
    */
    MPI_Scatter(mpi_rank == 0 ? grid : NULL, NX*lGLY, MPI_DOUBLE, lgrid+NX*HY, NX*lGLY, MPI_DOUBLE, 0, MPI_COMM_WORLD);
    
    // Sicronizzazione griglia locale
    memcpy(lgrid_new + NX * HY, lgrid + NX * HY, NX * lGLY * sizeof(double));
    MPI_Barrier(MPI_COMM_WORLD);

    t0 = omp_get_wtime();
    for (iter = 1; iter <= MAXITER; iter++) {

        MPI_Status status;

        /*
            Upper halo, lower halo
            - upper: vicino superiore rank-1 (R0 nessuno) 
            - lower: vicino inferiore rank+1 (ultimo nessuno)
        */
        up_halo = (mpi_rank > 0) ? mpi_rank - 1 : MPI_PROC_NULL;
        down_halo = (mpi_rank < mpi_size - 1) ? mpi_rank + 1 : MPI_PROC_NULL;
        
        /*
            Primo scambio: (invio in su, ricevo da giu')
            Invio: lgrid + NX * HY, prima riga fisica al vicino superiore
            Ricevo: lgrid + NX * (NY-HY) dal vicino inferiore e la metto nell'ultima riga
        */
        MPI_Sendrecv(lgrid + NX * HY, NX, MPI_DOUBLE, up_halo, 0, lgrid + NX * (NY-HY), NX, MPI_DOUBLE, down_halo, 0, MPI_COMM_WORLD, &status);

        /*
            Secondo scambio: (invio in giu', ricevo da su)
            Invio: lgrid + NX * (NY-HY-1) ultima riga fisica reale
            Ricevo: lgrid dal vicino superiore e scrive la riga 0 di lgrid
        */
        MPI_Sendrecv(lgrid + NX * (NY-HY-1), NX, MPI_DOUBLE, down_halo, 1, lgrid, NX, MPI_DOUBLE, up_halo, 1, MPI_COMM_WORLD, &status);

        for (int i = HY; i < NY - HY; i++) {
            for (int j = HX; j < GX - HX; j++) {

                if ((j >= GX - HX - 1 - K) && (j < GX - HX)) continue;
                // Metodo di Jacobi
                int index = i * NX + j;
                lgrid_new[index] = (lgrid[index] + lgrid[index-NX] + lgrid[index+NX] + lgrid[index-1] + lgrid[index+1]) / 5.0;
            }
        }

        // Swap puntatori
        tmp = lgrid;
        lgrid = lgrid_new;
        lgrid_new = tmp;

#if DUMP == 1
        if (iter % DUMPSTEP == 0) {
            // Prendo l'area interna (lgrid + NX * HY) e la invio al Rank 0
            MPI_Gather(lgrid + NX * HY, NX * lGLY, MPI_DOUBLE, mpi_rank == 0 ? grid : NULL, NX * lGLY, MPI_DOUBLE, 0, MPI_COMM_WORLD);
            if (mpi_rank == 0) {
                sprintf(myfile, "video-2mpi/grid-%07d", iter);
                dump(grid, myfile);
            }
        }
#endif
    }

    MPI_Barrier(MPI_COMM_WORLD);
    dt = (omp_get_wtime() - t0) * 1.e3;

    // Recupero finale: tutti i rank inviano al Rank 0
    MPI_Gather(lgrid + NX * HY, NX * lGLY, MPI_DOUBLE, mpi_rank==0 ? grid : NULL, NX * lGLY, MPI_DOUBLE, 0, MPI_COMM_WORLD);
    
    // Confronto di tutti i tempi e recupero il massimo (nodo piu' lento)
    MPI_Reduce(&dt, &dtmax, 1, MPI_DOUBLE, MPI_MAX, 0, MPI_COMM_WORLD);

    if (mpi_rank == 0) {
#if DUMP == 1
        sprintf(myfile, "video-2mpi/grid-%07d", MAXITER);
        dump(grid, myfile);
#endif
        printf("[Statistics] %dx%d %d iter %d ranks dT: %.6f msec GFLOPs: %.2f\n", GLX, GLY, MAXITER, mpi_size, dtmax, (5.0 * (double)MAXITER * (double)GLX * (double)GLY) / (dtmax*1e6));
        if (fp) {
            fprintf(fp, "%d %d %d %.8f\n", GLX, mpi_size, MAXITER, dtmax);
            fclose(fp);
        }
        free(grid);

    }

    free(lgrid);
    free(lgrid_new);
    MPI_Finalize();
    return 0;
}