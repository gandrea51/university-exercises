% Metodo Gradient Descent
clear all; close all; clc;

% Prendere la funzione quadratica: f(x) = 0.5 * x' * Q * x - b' * x definita nell'esempio (pagina 34)
Q = [4, 1; 1, 2];
b = [1; 0];

% Griglia per la visualizzazione
[x1, x2] = meshgrid(linspace(-4, 4, 100), linspace(-3, 3, 100));
z = zeros(size(x1));

% Valutazione della funzione su tutta la griglia
for i = 1:size(x1, 1)
    for j = 1:size(x1, 2)
        x = [x1(i,j); x2(i,j)];
        z(i,j) = 0.5 * x' * Q * x - b' * x;
    end
end

% Plot delle curve di livello
figure;
contour_levels = -10 : 10 : 50;
[C,h]=contourf(x1, x2, z,contour_levels);
clabel(C,h)
hold on;
colormap('parula');
colorbar;
xlabel('$x_1$', 'Interpreter', 'latex');
ylabel('$x_2$', 'Interpreter', 'latex');
title('Curve di livello e iterazioni del metodo del gradiente', 'Interpreter', 'latex');
grid on;

% Metodo del gradiente
x_k = [-3; -1];             % Punto iniziale
alpha = 0.085;              % Passo
max_iter = 15;              % Numero di iterazioni

% Salva iterazioni per il plot
iterazioni = x_k';

for k = 1:max_iter
    % Gradiente
    grad = Q * x_k - b; 
    % Iterazione
    x_k = x_k - alpha * grad;
    % Salvataggio iterazioni
    iterazioni = [iterazioni, x_k']; 
end

% Plot delle iterazioni
plot(iterazioni(:,1), iterazioni(:,2), '-o', 'LineWidth', 2, 'Color', 'r', 'MarkerFaceColor', 'r');
plot(iterazioni(1,1), iterazioni(1,2), 's', 'MarkerSize', 8, 'MarkerEdgeColor', 'g', 'MarkerFaceColor', 'g');       % Punto iniziale
plot(iterazioni(end,1), iterazioni(end,2), 'p', 'MarkerSize', 10, 'MarkerEdgeColor', 'm', 'MarkerFaceColor', 'm');  % Ultimo punto

% Confrontare il risultato con fminsearch(f,[-3;1]);
f = @(x) 0.5 * [x(1);x(2)]' * Q * [x(1);x(2)] - b' * [x();x(2)];
gradf = @(x) Q * [x(1);x(2)] - b;

x_opt = inv(Q) * b;
plot(x_opt(1), x_opt(2), '*', 'MarkerSize', 15, 'Color', 'k');

legend('Curve di livello', 'Iterazioni GD', 'Inizio', 'Fine', 'Ottimo Teorico', 'Location', 'best');

disp(['Punto Ottimale Teorico: [', num2str(x_opt(1)), ', ', num2str(x_opt(2)), ']']);
disp(['Ultima Iterazione GD: [', num2str(x_k(1)), ', ', num2str(x_k(2)), ']']);
