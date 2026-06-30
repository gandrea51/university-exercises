#!/bin/bash
#SBATCH --job-name=saxpy
#SBATCH --output=saxpy-cuda-%j.out
#SBATCH --time=00:10:00
#SBATCH --nodes=1
#SBATCH --mem=128000
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=16
#SBATCH --cpu-freq=performance
#SBATCH --gres=gpu:1
#SBATCH --partition=ibm

module load nchpc-hpcx-cuda12

make all

if [[ $? != 0 ]];
then
  echo "compilation fail."
  exit -1
else
  echo "compilation successed."
fi

export OMP_PLACES=cores
export OMP_PROC_BIND=close

echo "running: saxpy-omp.c"
srun ./saxpy-omp
