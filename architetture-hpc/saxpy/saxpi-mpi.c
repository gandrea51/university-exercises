#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <omp.h>
#include <mpi.h>

// Processo Master
#define MPI0 0

int main(int argc, char *argv[]) {
    float *X = NULL, *Y = NULL, *lX = NULL, *lY = NULL;
    float a = 17.17f;
    double t0, dt, sum = 0.0;
    long L = 100000000, lL;
    int mpi_size, mpi_rank;

    // Inizializzazione
    if (MPI_Init(&argc, &argv) != MPI_SUCCESS) {
        fprintf(stderr, "Error in MPI_Init.\n");
        exit(-1);
    }

    // #Totale di nodi attivi nel cluster
    MPI_Comm_size(MPI_COMM_WORLD, &mpi_size);
    // ID univoco del processo corrente (0 --> mpi_size-1)
    MPI_Comm_rank(MPI_COMM_WORLD, &mpi_rank);

    // Solo il Master alloca e inizializza la matrice globale
    if (mpi_rank == MPIO) {
        X = malloc(L*sizeof(float));
        Y = malloc(L*sizeof(float));
        srand48(1999);
        for (long ii = 0; ii < L; ii++) {
            X[ii] = (float)drand48();
            Y[ii] = (float)drand48();
        }
    }

    // Scomposizione dominio: ogni processo calcola la DIM della sua porzione locale
    lL = L/mpi_size;
    lX = malloc(lL*sizeof(float));
    lY = malloc(lL*sizeof(float));

    // Just to start all togheter (allinea il tempo di tutti i nodi)
    MPI_Barrier(MPI_COMM_WORLD);
    t0 = omp_get_wtime();

    /*
        Distribuzione scatter:
        Master prende X globale, lo divide nei vari blocchi e invia ogni parte a ogni processo (anche se stesso)
        inserendolo in lX (si introduce overhead di rete)
    */
    MPI_Scatter(X, lL, MPI_FLOAT, lX, lL, MPI_FLOAT, MPI0, MPI_COMM_WORLD);
    MPI_Scatter(Y, lL, MPI_FLOAT, lY, lL, MPI_FLOAT, MPI0, MPI_COMM_WORLD);
    
    // Saxpy: ogni nodo esegue il calcolo sulla sua CPU in isolamento hardware
    for (long ii = 0; ii < lL; ii++) {
        lY[ii] = a * lX[ii] + lY[ii];
    }

    /*
        Raccolta gather:
        Raccolta delle porzioni lY da tutti i nodi, ricomposizione nell'ordine corretto e scrittura su Y sul Master
    */
    MPI_Gather(lY, lL, MPI_FLOAT, Y, lL, MPI_FLOAT, MPI0, MPI_COMM_WORLD);
    dt = omp_get_wtime() - t0;
    
    if (mpi_rank == MPI0) {
        for (long ii = 0; ii < L; ii++) {
            sum += Y[ii];
        }

        printf("sum: %.2f dt: %f sec\n", sum, dt);

        free(X);
        free(Y);
    }

    free(lX);
    free(lY);

    MPI_Barrier(MPI_COMM_WORLD);
    MPI_Finalize();         // Chiusura comunicazioni MPI
    return 0;
}
