all: saxpy-serial saxpy-cuda saxpy-omp saxpy-omptarget

saxpy-serial: saxpy.c
	gcc -Wall -Ofast -fopenmp -o saxpy-serial saxpy.c -lm

saxpy-cuda: saxpy.cu
	nvcc -O3 --allow-unsupported-compiler -gencode arch=compute_70,code=sm_70 -Xcompiler -fopenmp -o saxpy-cuda saxpy.cu -lm

saxpy-omp:
	gcc -Wall -Ofast -fopenmp -o saxpy-omp saxpy-omp.c -lm

saxpy-omptarget:
    nvc -Wall -Ofast -Minfo --ptxas-options=-v -mp=gpu -gpu=cc70 -o saxpy-omptarget saxpy-omptarget.c -lm

clean:
	/bin/rm saxpy-serial saxpy-cuda saxpy-omp

