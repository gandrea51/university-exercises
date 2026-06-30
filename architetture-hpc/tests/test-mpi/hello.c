#include <stdio.h>
#include <mpi.h>

int main(int argc, char **argv){
    // Inizialize
    MPI_Init(&argc, &argv);

    // Number of processor
    int size;
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    // Rank of the process
    int rank;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);

    printf("Hello World, from rank %d out of %d processor\n", rank, size);
    MPI_Finalize();
}

