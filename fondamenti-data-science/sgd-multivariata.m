% Mini-batch SGD per regressione lineare multivariata 
clear all; close all; clc;

% Dati sintetici
n = 200;      % Numero di punti
d = 2;        % Numero di feature
X = randn(n, d);            % X: [x1, x2]
theta_true = [2; -1];       % Veri coefficienti
y = X * theta_true + 0.5 * randn(n, 1);  % y = 2*x1 - x2 + rumore

% Parametri iniziali per SGD
theta = zeros(d, 1);      % Inizializzazione
alpha = 0.05;             % Learning rate
epochs = 30;
batch_size = 20;

% Tracciamento della storia dei parametri
theta_history = theta';

% MINI-BATCH SGD
for epoch = 1:epochs
    idx = randperm(n);
    X_shuffled = X(idx, :);
    y_shuffled = y(idx);
    
    for i = 1:batch_size:n
        end_idx = min(i + batch_size - 1, n);

        X_batch = X_shuffled(i:end_idx, :);
        y_batch = y_shuffled(i:end_idx);
        
        % Gradiente medio sul mini-batch
        grad = -(X_batch' * (y_batch - X_batch * theta)) / size(X_batch, 1);
        
        % Aggiornamento dei parametri
        theta = theta - alpha * grad;
        theta_history(end+1, :) = theta';
    end
end

x1 = X(:, 1);
x2 = X(:, 2);

% Griglia per il piano
[xg1, xg2] = meshgrid(linspace(min(x1), max(x1), 20), linspace(min(x2), max(x2), 20));
Z_true = theta_true(1)*xg1 + theta_true(2)*xg2;
Z_final = theta(1)*xg1 + theta(2)*xg2;

figure;
scatter3(x1, x2, y, 30, 'b', 'filled'); hold on;
mesh(xg1, xg2, Z_true, 'EdgeColor', 'g', 'FaceAlpha', 0.3);   % piano vero
mesh(xg1, xg2, Z_final, 'EdgeColor', 'r', 'FaceAlpha', 0.3);  % piano appreso
xlabel('x_1'); ylabel('x_2'); zlabel('y');
legend('Dati', 'Piano vero', 'Piano appreso');
title('Mini-Batch SGD - Regressione lineare 3D');
grid on;
view(45, 25);

figure;
plot(theta_history, 'LineWidth', 1.5);
xlabel('Iterazione'); ylabel('\theta');
legend({'\theta_1', '\theta_2'}, 'Location', 'best');
title('Convergenza dei parametri con Mini-Batch SGD');
grid on;
