% stiff_solver
clear; clc; close all;

% Equazione differenziale y'(t)=-15y(t); y(0)=1

% Parametri del problema stiff
lambda = -15;             % Coefficiente stiff
y0 = 1;                   % Condizione iniziale
T = 1;                    % Tempo finale
h = 0.05;                 % Passo temporale
N = round(T / h);         % Numero di passi
t = linspace(0, T, N+1);  % Vettore tempo

% Soluzione esatta
y_exact = y0 * exp(lambda * t);

% Inizializzazione
y_euler_exp = zeros(1, N+1); y_euler_exp(1) = y0;
y_euler_imp = zeros(1, N+1); y_euler_imp(1) = y0;
y_crank_nic = zeros(1, N+1); y_crank_nic(1) = y0;

% Metodi numerici
for n = 1:N
    A = lambda * h;
    
    % Euler esplicito
    y_euler_exp(n+1) = y_euler_exp(n) * (1+A);

    % Euler implicito
    y_euler_imp(n+1) = y_euler_imp(n) / (1-A);

    % Crank–Nicolson
    y_crank_nic(n+1) = y_crank_nic(n) * (1+A/2) / (1-A/2);
end

% Plot dei risultati
figure;
plot(t, y_exact, 'k-', 'LineWidth', 2); hold on;
plot(t, y_euler_exp, 'r--o', 'DisplayName', 'Euler Esplicito');
plot(t, y_euler_imp, 'b--s', 'DisplayName', 'Euler Implicito');
plot(t, y_crank_nic, 'g--d', 'DisplayName', 'Crank-Nicolson');
legend('Location', 'northeast');
xlabel('t'); ylabel('y(t)');
title(['Confronto metodi numerici su problema stiff con h = ', num2str(h)]);
grid on;
