#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>

int main(int argc, char **argv){
    unsigned long long int i, rank_hit, rank_darts, total_hit, total_darts;
    double x_value, y_value;
    int rank, size;

    MPI_Init(&argc, &argv);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);

    total_darts = 1024;
    srand(42+rank);
    rank_darts = total_darts/size;
    rank_hit = 0;

    for (i = 0; i < rank_darts; i++) {
        x_value = (double)(rand())/RAND_MAX;
        y_value = (double)(rand())/RAND_MAX;
        if (( (x_value*x_value) + (y_value*y_value)) <= 1) rank_hit++;
    }

    MPI_Reduce(&rank_hit, &total_hit, 1, MPI_UNSIGNED_LONG_LONG, MPI_SUM, 0, MPI_COMM_WORLD);
    if (rank == 0){
        double pi = (double)(total_hit*4)/(double)(total_darts);
        printf("PI = %f\n", pi);
    }

    MPI_Finalize();
    return 0;
}

