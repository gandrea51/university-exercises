% Confronto tra i metodi di Eulero, Runge Kutta e Crack Nicholson
clear all; close all; clc;

% Definizione ODE
f = @(t, y) y * cos(t);
y_exact_fun = @(t) exp(sin(t));

% Parametri
t0 = 0; T = 20; y0 = 1;
h = 0.1;
t = t0 : h : T;
N = length(t);

% Inizializzazione soluzioni
y_euler_exp = zeros(1, N);
y_euler_imp = zeros(1, N);
y_rk4 = zeros(1, N);
y_cn = zeros(1, N);
y_exact = y_exact_fun(t);

% Inizializzazione
y_euler_exp(1) = y0;
y_euler_imp(1) = y0;
y_rk4(1) = y0;
y_cn(1) = y0;

% Eulero esplicito
for n = 1:N-1
    y_euler_exp(n+1) = y_euler_exp(n) + h * f(t(n), y_euler_exp(n)); 
end

% Eulero implicito
for n = 1:N-1
    y_euler_imp(n+1) =  y_euler_imp(n) / (1 - h * cos(t(n+1)));
end

% Runge-Kutta 4
for n = 1:N-1
    k1 = f(t(n), y_rk4(n));
    k2 = f(t(n) + 1/2 * h, y_rk4(n) + 1/2 * h* k1);
    k3 = f(t(n) + 1/2 * h, y_rk4(n) + 1/2 * h * k2);
    k4 = f(t(n) + + h, y_rk4(n) + h * k3);
    y_rk4(n+1) = y_rk4(n) + (h/6) * (k1 + 2*k2 + 2*k3 + k4);
end

% Crank–Nicolson
for n = 1:N-1
    a = 1 + 0.5 * h * cos(t(n));
    b = 1 - 0.5 * h * cos(t(n+1));
    y_cn(n+1) = y_cn(n) * (a / b);
end

% Plot confronto
figure;
plot(t, y_exact, 'k-', 'LineWidth', 2); hold on;
plot(t, y_euler_exp, 'b--', 'LineWidth', 2);
plot(t, y_euler_imp, 'm:', 'LineWidth', 2);
plot(t, y_rk4, 'r-.', 'LineWidth', 2);
plot(t, y_cn, 'g-', 'LineWidth', 2);
legend('Esatta', 'Eulero esplicito', 'Eulero implicito', 'RK4', 'Crank - Nicolson', 'Location', 'northwest');
xlabel('Tempo t'); ylabel('y(t)');
title('Confronto metodi numerici per y'' = y cos(t)');
grid on;

% Errori
figure;
plot(t, abs(y_euler_exp - y_exact), 'b--', 'LineWidth', 1.5); hold on;
plot(t, abs(y_euler_imp - y_exact), 'm:', 'LineWidth', 1.5);
plot(t, abs(y_rk4 - y_exact), 'r-.', 'LineWidth', 1.5);
plot(t, abs(y_cn - y_exact), 'g-', 'LineWidth', 1.5);
legend('Errore Eulero esp.', 'Errore Eulero imp.', 'Errore RK4', 'Errore CN', 'Location', 'northwest');
xlabel('Tempo t'); ylabel('Errore assoluto');
title('Errori rispetto alla soluzione esatta');
grid on;
