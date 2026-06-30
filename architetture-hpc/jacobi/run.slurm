#!/bin/bash

# Configurazioni

#SBATCH --job-name=jacobi           # Nome del Job
#SBATCH --output=jacobi-%j.out      # File di output
#SBATCH --time=0:20:00              # Tempo massimo
#SBATCH --nodes=1                   # Num di nodi
#SBATCH --mem=128000                # Memoria richiesta

# Per Seriale, OpenMP, OpenMP target e Corner settarlo a 1, Per MPI settarlo a 32
#SBATCH --ntasks=1                  # Num massimo processi

# Per OpenMP settarlo a 128, Per Seriale, OpenMP target, MPI e Corner settarlo a 1
#SBATCH --cpus-per-task=1           # Core per processo

# Per OpenMP target
#SBATCH --gres=gpu:1                # Num di GPU
#SBATCH --partition=ibm             # Partizione del cluster

# Dimensioni griglia
GLX=512
GLY=512
MAXITER=10000
DUMPSTEP=500

# Dump: 0 -> misurazione delle performance
#       1 -> generazione dei file per l'animazione
DUMP=0

# Environment

module purge

module load nvhpc/24.1
# module load nvhpc-hpcx-cuda12

make clean
make GLX=$GLX GLY=$GLY MAXITER=$MAXITER DUMP=$DUMP DUMPSTEP=$DUMPSTEP

if [[ $? != 0 ]]; then
    echo "[ERROR] compilation failed."
    exit -1
fi

# Versione OpenMP


# Versione Seriale
echo "running jacobi-serial ..."
./jacobi-serial

# Versione OpenMP
export OMP_PLACES=cores
export OMP_PROC_BIND=close
echo "running jacobi-omp ..."
srun ./jacobi-omp

# Versione OpenMP target
echo "running jacobi-target ..."
./jacobi-target

# Versione MPI: con rank 1 --> 32
echo "running 1 rank jacobi-mpi ..."
mpirun -np 1 ./jacobi-mpi

echo "running 2 rank jacobi-mpi ..."
mpirun -np 2 ./jacobi-mpi

echo "running 4 rank jacobi-mpi ..."
mpirun -np 4 ./jacobi-mpi

echo "running 8 rank jacobi-mpi ..."
mpirun -np 8 ./jacobi-mpi

echo "running 16 rank jacobi-mpi ..."
mpirun -np 16 ./jacobi-mpi

echo "running 32 rank jacobi-mpi ..."
mpirun -np 32 ./jacobi-mpi

# Versione sorgente nell'angolo
echo "running jacobi-corner ..."
./jacobi-corner

exit 0