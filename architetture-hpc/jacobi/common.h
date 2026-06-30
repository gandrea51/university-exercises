#include <stdlib.h>
#include <string.h>
#include <stdio.h>

// Dimensione griglia fisica (asse X)
#ifndef GLX
#warning setting GLX = 512
#define GLX 512
#endif

// Dimensione griglia fisica (asse Y)
#ifndef GLY
#warning setting GLY = 512
#define GLY 512
#endif

// #Passi massimi
#ifndef MAXITER
#warning setting MAXITER = 10000
#define MAXITER 10000
#endif

// Frequenza di dump
#if DUMP == 1
#ifndef DUMPSTEP
#warning setting DUMPSTEP = 500
#define DUMPSTEP 500
#endif
#endif

#define TB 72.0
// Temperatura massima
#define TH 212.0
// Temperatura minima
#define TC 32.0

// Dimensioni dei bordi (halo)
#define HX 1
#define HY 1

// Dimensioni totali della griglia
#define GX (HX + GLX + HX)
#define GY (HY + GLY + HY)

// #Colonne della sorgente a destra
#define K 16
// Limite massimo di thread del loop di scaling 
#define MAXNUMTHREADS 128


// Variante nell'angolo
#define INNESCO 64
#define IROW ((HY + GLY) - INNESCO)
#define ICOLUMN ((HX + GLX) - INNESCO)

int GLYH2 = (int)(GLY / 2);

// Inizializzazione della griglia alla Temp. minima e applicazione del gradiente simmetrico sulle ultime K colonne
void init(double *grid) {
    for (int i = 0; i < GY; i++) {
        for (int j = 0; j < GX; j++) {
            int index = i * GX + j;
            grid[index] = TC;
        }
    }

    // Applicazione del gradiente nella metà superiore: (crescita fino a TH)
    for (int i = HY; i < HY + GLYH2; i++) {
        for (int j = (GX - HX - 1 - K); j < (GX - HX); j++) {
            grid[i*GX+j] = TC + ((double)(TH * 2 * (i-HY)) / ((double)(GLY)));
        }
    }

    // Applicazione del gradiente nella metà inferiore: (calo fino a TC)
    for (int i = HY + GLYH2; i < HY + GLY; i++) {
        for (int j = (GX - HX - 1 - K); j < (GX - HX); j++) {
            grid[i*GX+j] = TC + ((double)(TH * 2 * (GY - (i - HY))) / ((double)(GLY)));
        }
    }
}

// Dump: I/O sincrono sul disco: salvataggio in formato binario dei punti fisici della griglia (saltando i bordi)
void dump(double *grid, const char *filename) {
    FILE *fp = fopen(filename, "w");
    if (fp == NULL) {
        fprintf(stderr, "Error opening output file.\n");
        exit(EXIT_FAILURE);
    }
    for (int i = 1; i < GY - 1; i++) {
        fwrite((grid + (i*GX) + 1), sizeof(double), GLX, fp);
    }
    fclose(fp);
}

// Kernel OpenMP target
void kernel(double *out, const double *in){
    #pragma omp teams distribute parallel for collapse(2)
    for (int i = HY; i < HY + GLY; i++) {
        for (int j = HX; j < HX + GLX; j++) {

            // Controllo bordo
            if ((j >= GX - HX - 1 - K) && (j < GX - HX)) {
                // Rispetto della specifica: La sorgente a destra, deve rimanere intatta
                continue;
            }

            int index = i * GX + j;
            out[index] = (in[index] + in[index - GX] + in[index + GX] + in[index - 1] + in[index + 1]) / 5.0;
        }
    }
}

// Inizializazione nell'angolo 
void init_corner(double *grid) {
    for (int i = 0; i < GY; i++) {
        for (int j = 0; j < GX; j++) {
            int index = i * GX + j;
            grid[index] = TC;
        }
    }

    for (int i = IROW; i < (HY + GLY); i++) {
        for (int j = ICOLUMN; j < (HX + GLX); j++) {
            int index = i * GX + j;
            grid[index] = TH;
        }
    }
}