% Stochastic Gradient Descent
clear all; close all; clc;

% Dati sintetici (y = 3*x + rumore)
n = 100;
x_data = linspace(0, 10, n)';
y_data = 3 * x_data + randn(n, 1);

% Parametri iniziali
theta = 0;              % Stima iniziale del parametro
alpha = 0.01;           % Passo
epochs = 2;             % Numero di valutazioni

% Salva storia per il grafico
theta_history = theta;

% SGD Loop
for epoch = 1:epochs
    idx = randperm(n);      % Permutazione casuale dei dati
    for i = 1:n
        x_i = x_data(idx(i));           % Mettere il valore di x_data casuale
        y_i = y_data(idx(i));           % Mettere il valore di y_data casuale
        grad_i = -(y_i - theta * x_i) * x_i;    % Calcolare il gradiente su singolo L_n
        theta = theta - alpha * grad_i;         % Aggiornare theta
        theta_history(end+1) = theta;
    end
end

% Risultato finale
fprintf('Parametro ottimale trovato: theta = %.4f\n', theta);

% Plot dei dati e retta finale
figure;
scatter(x_data, y_data, 20, 'b', 'filled'); hold on;
plot(x_data, theta * x_data, 'r-', 'LineWidth', 2);
title('SGD: Regressione lineare su dati rumorosi');
xlabel('x'); ylabel('y');
legend('Dati', 'Fit finale', 'Location', 'best');
grid on;

% Plot theta
figure;
plot(theta_history, 'LineWidth', 1.5);
xlabel('Iterazione'); ylabel('\theta');
title('Convergenza del parametro \theta con SGD');
grid on;
