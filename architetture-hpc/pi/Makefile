all: intpi-serial intpi-omp

intpi-serial: pi-serial.c
        gcc -Wall -O3 -fopenmp -o pi-serial pi-serial.c -lm

intpi-omp: pi-omp.c
        gcc -Wall -O3 -fopenmp -o pi-omp pi-omp.c -lm

clean:
        /bin/rm pi-serial pi-omp
