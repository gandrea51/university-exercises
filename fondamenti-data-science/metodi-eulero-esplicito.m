% Metodo di Eulero esplicito per dy/dt = y * cos(t)
clear all; close all; clc;

% Definizione della funzione f(t, y)
f = @(t, y) y * cos(t);  % Nuova ODE

% Condizioni iniziali
t0 = 0;         % Tempo iniziale
y0 = 1;         % Valore iniziale
T = 10;         % Tempo finale
N = 400;        % Numero di passi
h = (T - t0)/N; % Passo temporale

% Inizializzazione
t = t0 : h: T;
y = zeros(1, N+1);
y(1) = y0;

% Metodo di Eulero esplicito
for n = 1:N
    y(n+1) = y(n) + h * f(t(n), y(n));
end

% Soluzione esatta per confronto
y_exact = exp(sin(t));

% Plot dei risultati
figure;
plot(t, y, 'b-', 'LineWidth', 1.5, 'DisplayName', 'Eulero esplicito');
hold on;
plot(t, y_exact, 'r--', 'LineWidth', 1.5, 'DisplayName', 'Soluzione esatta');
xlabel('t');
ylabel('y(t)');
title('Soluzione di dy/dt = y cos(t) con Eulero esplicito');
legend('Location', 'northwest');
grid on;
