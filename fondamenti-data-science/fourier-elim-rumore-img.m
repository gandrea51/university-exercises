% Filtro soglia FFT per la riduzione del rumore
clear all; close all; clc;

% La FFT e' ampiamente utilizzata per la riduzione del rumore e il filtraggio dei segnali, poiche' e' semplice 
%   isolare e manipolare particolari bande di frequenza. Introduciamo un filtro di soglia FFT per la riduzione 
%   del rumore di un'immagine con rumore gaussiano aggiunto. In questo esempio, si osserva che il rumore e'
%   particolarmente pronunciato nelle alte frequenze e pertanto azzeriamo qualsiasi coefficiente di Fourier al 
%   di fuori di un dato raggio contenente basse frequenze.

A = imread('dog.jpg');                      % Lettura dell'immagine
B = rgb2gray(A);                            % Trasformazione dell'immagine in scala di grigi
imshow(B)                                   % Plot image
title('Immagine Originale')

% Introduciamo del rumore gaussiano
Bnoise = B + uint8(300 * randn(size(B))); 

% Trasformata di Fourier
Bt = fft2(Bnoise);

% Mostrare immagine con rumore
figure
imshow(Bnoise)
title('immagine con rumore')

% Introdurre una griglia della dimensione della matrice B
[nx,ny] = size(B);
[X,Y] = meshgrid(-ny/2+1:ny/2,-nx/2+1:nx/2);

% Questo comando mette le frequenze basse al centro della matrice
Btshift = fftshift(Bt);

% Calcolare un raggio al di fuori del quale azzerare le frequenze
R2 = X .^ 2 + Y .^ 2;  

% Mettere uguale a zero gli indici con frequenze maggiori di un certo raggio
ind = R2 > 400;

% Azzerare le frequenze che corrispondono all'indice ind
Btshiftfilt = Btshift;
Btshiftfilt(ind) = 0;

% Riordiniamo le frequenze come erano prima
Btfilt = ifftshift(Btshiftfilt);

% Ritorniamo nello spazio fisico
Bfilt = ifft2(Btfilt);

figure
imagesc(uint8(real(Bfilt)))                 % Filtered image
title('Immagine Filtrata')
colormap gray
set(gcf,'Position',[100 100 600 800])