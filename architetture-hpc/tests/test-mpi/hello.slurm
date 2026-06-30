#!/bin/batch
#SBATCH --job-name=helloMPI
#SBATCH --error=helloMPI-%j.err
#SBATCH --output=helloMPI-%j.out
### #SBATCH --nodes=2
#SBATCH --ntasks=4
### #SBATCH --ntasks-per-node=2

module load cuda
module load openmpi

mpicc hello.c -o hello

srun ./hello

sacct -j $SLURM_JOB_ID.0 --format=JobID%16,AllocNodes,NTasks,Elapsed,ConsumedEnergy

