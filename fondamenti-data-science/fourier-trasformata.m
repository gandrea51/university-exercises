% Fourier: Trasformata continua
clear all; close all; clc;

% Parametri
a = 1;                              % Mezzo supporto della funzione rettangolo
omega = linspace(-20, 20, 1000);    % Frequenze su cui valutare la trasformata
N = 1000;                           % Numero di punti di quadratura
t = linspace(-a, a, N);             % Intervallo in cui f(t)=1
dt = t(2) - t(1);                   % Passo

% Funzione f(t) = 1 su [-a,a], zero altrove
f = ones(size(t));

% Inizializza vettore trasformata
F_num = zeros(size(omega));

% Calcolo della trasformata numerica con quadratura 
for k = 1:length(omega)
    integrand = f .* exp(-1j * omega(k)*t);
    
    % Formula dei rettangoli
    F_num(k) = sum(integrand) * dt;  
end

% Trasformata esatta per confronto
F_exact = 2 * sin(omega*a) .\ omega;
F_exact(omega==0) = 2*a;

% Plot
figure;
plot(omega, real(F_num), '--r', 'LineWidth', 1.5); hold on;
plot(omega, F_exact, 'k', 'LineWidth', 2);
xlabel('\omega'); ylabel('Re[\hat{f}(\omega)]');
title('Trasformata di Fourier della funzione rettangolo: confronto');
legend('Numerica (quadratura)', 'Esatta', 'Location', 'NorthEast');
grid on;
