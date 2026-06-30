# Target: compilazione di tutte le versioni
all: jacobi-serial jacobi-omp jacobi-target jacobi-mpi jacobi-corner

# Compilatore C
CC = gcc

# Parametri da riga di comande: Dimensioni griglia, Num. Iterazioni, Gestione dei Dump
FLAGS = -DGLX=$(GLX) -DGLY=$(GLY) -DMAXITER=$(MAXITER) -DDUMP=$(DUMP) -DDUMPSTEP=$(DUMPSTEP)

# Opzioni: Abilitazione dei warning, Massima ottimizzazione, OpenMP, Libreria matematica
CFLAGS = -Wall -Ofast -fopenmp -lm

# Versione seriale 
jacobi-serial: jacobi-serial.c
	$(CC) $(FLAGS) $(CFLAGS) -o jacobi-serial jacobi-serial.c

# Versione OpenMP per CPU multicore
jacobi-omp: jacobi-omp.c
	$(CC) $(FLAGS) $(CFLAGS) -o jacobi-omp jacobi-omp.c

# Versione OpenMP target per GPU: Informazioni di compilazione, Abilitazione OpenMP target, Architettura GPU Volta
jacobi-target: jacobi-target.c
	nvc $(FLAGS) -Minfo --ptxas-options=-v -mp=gpu -gpu=cc70 $(CFLAGS) -o jacobi-target jacobi-target.c

# Versione MPI su piu' processi
jacobi-mpi: jacobi-mpi.c
	mpicc $(FLAGS) $(CFLAGS) -o jacobi-mpi jacobi-mpi.c

# Variante seriale con sorgente nell'angolo della griglia
jacobi-corner: jacobi-corner.c
	$(CC) $(FLAGS) $(CFLAGS) -o jacobi-corner jacobi-corner.c

clean:
	/bin/rm -f jacobi-serial jacobi-omp jacobi-target jacobi-mpi jacobi-corner

