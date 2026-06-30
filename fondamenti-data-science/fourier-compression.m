% Fourier: Image compression
clear all; close all; clc;

% Read the image - Conversion it to grayscale
A = imread('dog.jpg');
B = rgb2gray(A);

% 2D Fourier Trasform - Sort the frequencies by their magnitude
Bt = fft2(double(B));
Btsort = sort(abs(Bt(:)));

keep = 0.1;     % Percentage of frequencies to keep

% Display the original image
figure
imshow(B)
title("Original image")

% Choose a threshold value based on the sorted magnitudes
thresh = Btsort(floor( (1 - keep) * length(Btsort) ));

% Find the indices of frequencies that are below the threshold and set them to zero.
ind = abs(Bt) < thresh;
Atlow = Bt;
Atlow(ind) = 0;

% Return to the spatial domain by applying the inverse Fourier Transform and convert the result back to an 8-bit integer image.
Alow = uint8(ifft2(Atlow));

% Display the compressed image
figure
imshow(Alow)
title("Compressed Image")
