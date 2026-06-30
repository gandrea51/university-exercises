% Metodo di Newton in una dimensione per ottimizzazione
clear all; close all; clc;

% Funzione e derivate
f = @(x) x.^4 - 3*x.^3 + 2;
df = @(x) 4 * x.^3 - 9 * x.^2;
d2f = @(x) 12 * x.^2 - 18 * x;

% Parametri
x0 = 2;                 % Punto iniziale
tol = 1e-6;             % Tolleranza
max_iter = 20;          % Massimo numero di iterazioni

% Inizializzazione
x = x0;
iter = 0;
history = x;

fprintf('Iterazione\t x\t\t f(x)\n');
fprintf('%d\t\t %.6f\t %.6f\n', iter, x, f(x));

while abs(df(x)) > tol && iter < max_iter
    x = x - df(x) / d2f(x);
    iter = iter + 1; 
    history(end+1) = x;
    fprintf('%d\t\t %.6f\t %.6f\n', iter, x, f(x));
end

% Visualizzazione
x_vals = linspace(min(history)-1, max(history)+1, 400);
y_vals = f(x_vals);

figure;
plot(x_vals, y_vals, 'b-', 'LineWidth', 1.5); hold on;
plot(history, f(history), 'ro-', 'LineWidth', 1.5, 'MarkerFaceColor', 'r');
xlabel('x'); ylabel('f(x)');
title('Metodo di Newton per l''ottimizzazione di f(x)');
grid on;
legend('f(x)', 'Iterazioni Newton', 'Location', 'best');
