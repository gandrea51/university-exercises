% Metodo di Newton in 2D
clear all; close all; clc;

% Funzione f(x,y)= (x-2)^4+(x-2)^2*y^2+(y+1)^2
f = @(x) (x(1)-2).^4 + (x(1)-2).^2 .* x(2).^2 + (x(2)+1).^2;

% Gradiente e hessiana
G = @(x) [
    4*(x(1)-2).^3 + 2*(x(1)-2).*x(2).^2;
    2*(x(1)-2).^2.*x(2) + 2*(x(2)+1)
];

H = @(x) [
    12*(x(1)-2).^2 + 2*x(2).^2,     4*(x(1)-2).*x(2);
    4*(x(1)-2).*x(2),               2*(x(1)-2).^2 + 2
];

% Parametri iniziali
xk = [1; 1];            % Punto iniziale
tol = 1e-6;
max_iter = 30;
history = xk';          % Memorizzare il percorso

fprintf('Iter\t x\t\t y\t\t f(x,y)\n');

for k = 1:max_iter
    gradient = G(xk);
    if norm(gradient) < tol
        break;
    end

    % Passo di Newton
    xk = xk + H(xk) \ (-gradient);
    history(end+1, :) = xk';        % Salva il percorso
end

fprintf('\nPunto stazionario trovato in: [%.6f, %.6f]\n', xk(1), xk(2));
fprintf('Valore funzione: f = %.6f\n', f(xk'));

% ========================
% Contour plot della funzione

[X, Y] = meshgrid(linspace(-3, 3, 100), linspace(-3, 3, 100));
Z = (X-2).^4+(X-2).^2.*Y^2+(Y+1).^2;

figure;
contour(X, Y, Z, 30); hold on;
plot(history(:,1), history(:,2), 'ro-', 'LineWidth', 2, 'MarkerFaceColor', 'r');
xlabel('x'); ylabel('y');
title('Metodo di Newton su $f(x,y) = \sin(x) + \cos(y)$', 'Interpreter', 'latex');
legend('Livelli di f(x,y)', 'Iterazioni Newton', 'Location', 'best');
grid on;
axis equal;
