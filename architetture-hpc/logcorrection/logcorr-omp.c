#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <omp.h>

#define GAIN 1.0
#define IMGX 512
#define IMGY 512
#define DIM 4096
#define REPEAT 1000
#define MAXNUMTHREAD 16

float *imgin = NULL;
float *imgout = NULL;

void allocateImginImgout() {
    imgin = (float *)malloc(IMGX*IMGY*sizeof(float));
    if (imgin == NULL) {
        perror("Errore allocazione imgin");
        exit(-1);
    }
    imgout = (float *)malloc(IMGX*IMGY*sizeof(float));
    if (imgout == NULL) {
        perror("Errore allocazione imgout");
        free(imgin);
        exit(-1);
    }
}

void readImgin() {
    FILE *fpin = fopen("moon.in", "r");
    if (fpin == NULL) {
        perror("Errore apertura moon.in");
        exit(-1);
    }
    for (int i = 0; i < IMGX; i++) {
        size_t nr = fread(imgin + (i*IMGY), sizeof(float), IMGY, fpin);
        if (nr != IMGY){
            perror("fread() fail.");
            fclose(fpin);
            exit(-1);
        }
    }
    fclose(fpin);
}

void writeImout() {
    FILE *fpout = fopen("moon.out", "w");
    if (fpout == NULL) {
        perror("Errore apertura moon.out");
        exit(-1);
    }
    for (int i = 0; i < IMGX; i++) {
        size_t nw = fwrite(imgout + (i*IMGY), sizeof(float), IMGY, fpout);
        if (nw != IMGY) {
            perror("fwrite() failed");
            fclose(fpout);
            exit(-1);
        }
    }
    fclose(fpout);
}

int main () {
    allocateImginImgout();
    readImgin();

    double t0, dt;

    // Ripetizione dell'algoritmo a diverso #thread
    for (int t = 1; t <= MAXNUMTHREAD; t++) {
        omp_set_num_threads(t);
        t0 = omp_get_wtime();

        /*
            Creazione di un gruppo t di thread indipendenti
            Distribuzione dello spazio delle iterazioni tra i thread
            Unione dei cicli annidati in uno unico grande, invece di parallelizzare solo quello su "i" assegnando righe intere ai thread
        */
        #pragma omp parallel for collapse(2)
        for (int i = 0; i < IMGX; i++){
            for (int j = 0; j < IMGY; j++){
                imgout[i*IMGY+j] = 0.0f;

                for (int k = 0; k < REPEAT; k++) {
                    /*
                        Just to increase the workload of threads
                        Il calcolo sarebbe troppo veloce e l'overhead di OpenMP dominerebbe il calcolo base
                    */
                    int index = i * IMGY + j;
                    imgout [index] = GAIN * logf(1.0f+imgin[i*IMGY + j]);
                }
            }
        }

        dt = omp_get_wtime() - t0;
        printf("Threads: %d -> dt: %f msec (%f ns/point)\n", t, dt*1e3, dt*1e9/(double)(IMGX*IMGY));
        writeImout();
    }

    free(imgin);
    free(imgout);
    return 0;
}