% Mini-batch SGD per regressione lineare (1D)
clear all; close all; clc;

% Dati sintetici (y = 3*x + rumore)
n = 100;
x_data = linspace(0, 10, n)';
y_data = 3 * x_data + randn(n, 1);

% Parametri iniziali
theta = 0;              % Stima iniziale del parametro
alpha = 0.01;           % Passo
epochs = 2;             % Numero di valutazioni
batch_size = 10;        % Grandezza del batch per il calcolo del gradiente

% Salva storia per il grafico
theta_history = theta;

% Mini-batch SGD loop
for epoch = 1:epochs
    idx = randperm(n);          % Shuffle dei dati
    x_shuffled = x_data(idx);   % Mettere il valore di x_data casuale
    y_shuffled = y_data(idx);   % Mettere il valore di y_data casuale
    
    for i = 1:batch_size:n
        % Estrai mini-batch 
        x_batch =  x_shuffled(i: min(i + batch_size - 1, n)); % Estrarre un sottogruppo di valori per calcolare il gradiente
        y_batch = y_shuffled(i : min(i + batch_size - 1, n)); % Estrarre un sottogruppo di valori per calcolare il gradiente
        
        % calcolo del gradiente medio sul mini-batch
        grad_batch =- mean((y_batch - theta * x_batch) .* x_batch);
        
        % Aggiorna parametro
        theta = theta - alpha * grad_batch;
        theta_history(end+1) = theta;
    end
end

% Risultato finale
fprintf('Parametro ottimale trovato: theta = %.4f\n', theta);

% Plot dei dati e retta finale
figure;
scatter(x_data, y_data, 20, 'b', 'filled'); hold on;
plot(x_data, theta * x_data, 'r-', 'LineWidth', 2);
title('Mini-batch SGD: Regressione lineare');
xlabel('x'); ylabel('y');
legend('Dati', 'Fit finale', 'Location', 'best');
grid on;

% Plot theta
figure;
plot(theta_history, 'LineWidth', 1.5);
xlabel('Iterazione'); ylabel('\theta');
title('Convergenza del parametro \theta con mini-batch SGD');
grid on;
