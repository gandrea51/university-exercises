% Integrale di Fourier
clear all; close all; clc;

% Definizione funzione
f = @(x) x.^2;
a = -2; b = 2;
L = (b - a)/2;

% Parametri per somme di Riemann
M = 1000;                   % Numero di punti per discretizzazione
x = linspace(a,b,M);
dx = (b - a)/(M-1);

% Ordine serie di Fourier
N = 2;

% Calcolo a0 con somma di Riemann
a0 = (1/L) * (sum(f(x)) * dx) / 2;

% Calcolo an e bn con somme di Riemann
an = zeros(1, N);
bn = zeros(1, N);

for n = 1:N
    an(n) = (1/L) * sum(f(x) .* cos(n*pi*x/L)) * dx;
    bn(n) = (1/L) * sum(f(x) .* sin(n*pi*x/L)) * dx;
end

% Serie di Fourier troncata numerica
Ftrunc = a0 * ones(size(x));
for n = 1 : N
    Ftrunc = Ftrunc + an(n) * cos(n*pi*x/L) + bn(n) * sin(n*pi*x/L);
end

% Integrale esatto e integrale numerico (Riemann) della troncata
I_exact = integral(f, 0, 1);
x_int = linspace(0, 1, M);
dx_int = (1 - 0) / (M-1);
Fourier_interp = interp1(x, Ftrunc, x_int);
I_fourier = sum(Fourier_interp) * dx_int;

fprintf('Integrale esatto di x^2 su [0,1]: %f\n',I_exact);
fprintf('Integrale Fourier (Riemann) su [0,1]: %f\n',I_fourier);
fprintf('Errore assoluto: %e\n',abs(I_exact - I_fourier));

% Grafico delle primitive
Primitiva_esatta = (x.^3)/3;
Primitiva_Fourier = cumsum(Ftrunc) * dx;
Primitiva_Fourier = Primitiva_Fourier - Primitiva_Fourier(find(x>=a, 1));

figure;
plot(x,Primitiva_esatta,'b','LineWidth',2);
hold on;
plot(x,Primitiva_Fourier,'r--','LineWidth',2);
grid on;
legend('Primitiva esatta (x^3/3)','Primitiva Fourier (Riemann)');
title('Confronto primitive esatta e Fourier');