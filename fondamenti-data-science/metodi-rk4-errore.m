% Ordine di convergenza dei metodi di Eulero e Runge Kutta 4
clear all; close all; clc;

% Funzione e soluzione esatta
f = @(t, y) y * cos(t);
y_exact_fun = @(t) exp(sin(t));

% Parametri
T = 5; y0 = 1;
Ns = [20 40 80 160 320 640];        % Diversi numeri di passi
errors_euler = zeros(size(Ns));
errors_rk4   = zeros(size(Ns));
hs = zeros(size(Ns));

for i = 1:length(Ns)
    N = Ns(i);
    h = T / N;
    hs(i) = h;
    t = linspace(0, T, N+1);
    
    % Metodo di Eulero
    y_euler = zeros(1, N+1);
    y_euler(1) = y0;
    for n = 1:N
        y_euler(n+1) = y_euler(n) + h * f(t(n), y_euler(n));
    end
    
    % Metodo RK4
    y_rk4 = zeros(1, N+1);
    y_rk4(1) = y0;
    for n = 1:N
        k1 = f(t(n), y_rk4(n));
        k2 = f(t(n) + 1/2 * h, y_rk4(n) + 1/2 * h * k1);
        k3 = f(t(n) + 1/2 * h, y_rk4(n) + 1/2 * h * k2);
        k4 = f(t(n) + h, y_rk4(n) + h * k3);
        y_rk4(n+1) = y_rk4(n) + (h/6) * (k1 + 2 * k2 + 2* k3 + k4);
    end
    
    % Errore globale
    y_true = y_exact_fun(T);
    errors_euler(i) = abs(y_true - y_euler(end));
    errors_rk4(i)   = abs(y_true - y_rk4(end));
end

% Plot log-log
figure;
loglog(hs, errors_euler, 'bo-', 'LineWidth', 1.5, 'DisplayName', 'Eulero esplicito');
hold on;
loglog(hs, errors_rk4, 'rs--', 'LineWidth', 1.5, 'DisplayName', 'RK4');
xlabel('Passo h');
ylabel('Errore globale |y(T) - yN|');
title('Confronto dell''errore globale: Eulero vs RK4');
legend('Location', 'southeast');
grid on;

% Ordine di convergenza (slope)
p_euler = polyfit(log(hs), log(errors_euler), 1);
p_rk4   = polyfit(log(hs), log(errors_rk4), 1);

fprintf('Ordine di convergenza (Eulero): ~%.2f\n', p_euler(1));
fprintf('Ordine di convergenza (RK4): ~%.2f\n', p_rk4(1));
