% SVD Decomposition for image compression
clear all; close all; clc;

%% Read and preprocess the image
%A = imread('dog.jpg');
A = imread('gerry.jpg');
X = double(rgb2gray(A));

nx = size(X,1);             % Numero di righe
ny = size(X,2);             % Numero di colonne

%% Plot the original grayscale image
figure;
imagesc(X);
axis off, colormap gray 
title('Original image');

%% Perform SVD decomposition
[U, S, V] = svd(X);

%% Choose the rank for approximation
r = [10, 50, 100];

%% Calculate and plot the low-rank approximations
for i = 1 : length(r)
    Xapprox = U(:, 1:r(i)) * S(1:r(i), 1:r(i)) * V(:, 1:r(i))';

    figure;
    imagesc(Xapprox);
    axis off, colormap gray
    title(['Approximation with rank r = ', num2str(r(i))]);

    %% Calculate the computational cost

    % The total memory for full image is nx*ny
    % The memory for the approximation is the sum of the sizes the the 3 matrics
    original = nx * ny;
    approx = (nx * r(i)) + r(i) + (ny * r(i));
    compress_ratio = approx / original;
    disp(['Rank r = ', num2str(r(i)), '| Compress ratio: ', num2str(compress_ratio)]);
end

%% Plot the singular values on a semilogarithmic scale
figure; 
semilogx(diag(S));
grid on;
xlabel('Singular value index, r')
ylabel('Singular value, \sigma_r')
title('Singular value of the image matrix');