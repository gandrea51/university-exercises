% Metodo di Runge-Kutta del 4° ordine per dy/dt = y * cos(t)
clear all; close all; clc;

% Definizione della funzione
f = @(t, y) y * cos(t);

% Condizioni iniziali
t0 = 0;
y0 = 1;
T = 10;
N = 20;                 % Numero di passi
h = (T - t0) / N;       % Passo temporale

% Inizializzazione
t = linspace(t0, T, N+1);
y = zeros(1, N+1);
y(1) = y0;

% Metodo RK4
for n = 1:N
    k1 = f(t(n), y(n));
    k2 = f(t(n) + 1/2 * h, y(n) + 1/2 * h * k1);
    k3 = f(t(n) + 1/2 * h, y(n) + 1/2 * h * k2);
    k4 = f(t(n) + h, y(n) + h * k3);
    y(n+1) = y(n) + (h/6) * (k1 + 2 * k2 + 2* k3 + k4);
end

% Soluzione esatta per confronto
y_exact = exp(sin(t));

% Plot
figure;
plot(t, y, 'b-', 'LineWidth', 1.5, 'DisplayName', 'RK4');
hold on;
plot(t, y_exact, 'r--', 'LineWidth', 1.5, 'DisplayName', 'Soluzione esatta');
xlabel('t');
ylabel('y(t)');
title('Soluzione di dy/dt = y cos(t) con RK4');
legend('Location', 'northwest');
grid on;
