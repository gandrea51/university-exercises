#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <omp.h>

#define GAIN 1.0
#define IMGX 512
#define IMGY 512

float *imgin = NULL;
float *imgout = NULL;

void allocateImginImgout() {
    /*
        Allocazione per l'immagine di input e di output 
    */
    imgin = (float *)malloc(IMGX*IMGY*sizeof(float));
    if (imgin == NULL) {
        perror("Errore allocazione imgin");
        exit(-1);
    }
    imgout = (float *)malloc(IMGX*IMGY*sizeof(float));
    if (imgout == NULL) {
        perror("Errore allocazione imgout");
        free(imgin);    // Libero la memoria precedentemente allocata
        exit(-1);
    }
}

void writeImout() {
    /*
        Output: risultati dell'elaborazione nel file binario moon.out
    */
    FILE *fpout = fopen("moon.out", "w");
    if (fpout == NULL) {
        perror("Errore nell'apertura di moon.out");
        exit(-1);
    }
    // Per ogni riga
    for (int i = 0; i < IMGX; i++) {
        size_t nw = fwrite(imgout + (i * IMGY), sizeof(float), IMGY, fpout);   
        if (nw != IMGY) {
            perror("fwrite() failed");
            fclose(fpout);
            exit(-1);
        }
    }
    fclose(fpout);
}

int main () {
    allocateImginImgout();      // Allocazione memoria
    double t0, dt;
     
    // File binario di input: moon.in
    FILE *fpin = fopen("moon.in", "r");
    if (fpin == NULL) {
        perror("Errore nell'apertura di moon.in");
        exit(-1);
    }

    // Lettura riga per riga per riempire l'array imgin
    for (int i=0; i<IMGX ; i++) {
        size_t nr = fread(imgin + (i*IMGY), sizeof(float), IMGY, fpin);
        if (nr != IMGY) {
            perror("fread() failed");
            exit(-1);
        }
    }
    fclose(fpin);
    
    // Inizio Calcolo Log - Correction
    t0 = omp_get_wtime();
    for (int i = 0; i < IMGX ; i++) {
        for (int j = 0; j < IMGY ; j++) {
            int index = i * IMGY + j;
            imgout [index] = GAIN * logf(1.0f + imgin[index]);      // Logf per migliori performance
        }
    }
    dt = omp_get_wtime() - t0;

    // Statistiche: Tempo, Tempo / #Punti
    printf("dt: %f msec (%f ns/point)\n", dt*1e3, dt*1e9/(double)(IMGX*IMGY));
    writeImout();

    free(imgin);
    free(imgout);

    return 0;   
}