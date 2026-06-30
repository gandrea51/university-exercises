#!/bin/bash
#SBATCH --job-name=montecarlo
#SBATCH --error=montecarlo-%j.err
#SBATCH --output=montecarlo-%j.out
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --ntasks-per-node=4

module load cuda
module load openmpi

mpicc montecarlo.c -o montecarlo

srun ./montecarlo

