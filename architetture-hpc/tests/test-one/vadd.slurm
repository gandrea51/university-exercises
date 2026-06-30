#!/bin/bash

#SBATCH --job-name=vadd_test
#SBATCH --output=risultato.txt
#SBATCH --error=errore.txt
#SBATCH --partition=shortrun
#SBATCH --gres=gpu:1
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1

module load cuda

srun ./vadd
