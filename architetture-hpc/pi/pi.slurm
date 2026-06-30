#!/bin/bash
#SBATCH --job-name=integralpi-ser
#SBATCH --output=integralpi-ser%j.out
#SBATCH --time=00:10:00
#SBATCH --nodes=1
#SBATCH --mem=128000
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --cpu-freq=performance
#SBATCH --partition=ibm

make intpi-serial

if [[ $? != 0 ]];
then
    echo "compilation FAILED !"
    exit -1
else
    echo "compilation SUCCESSED."
fi

export OMP_PLACES=cores                  # Place threads on hardware cores
export OMP_PROC_BIND=close               # Place threads close each other

srun ./pi-serial | tee data.dat
