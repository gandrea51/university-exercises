% Ott. Vincolata: Penalizzazione esterna con vincoli di disuguaglianza
clear all; close all; clc;

% Funzione obiettivo
f = @(x) 0.5*(x(1) - 3)^2 + (x(2) - 2)^2;

% Funzione penalizzazione per disuguaglianze: max(0, g(x))^2
% g(x)=-2x(1)+x(2)≤ 0; x1 + x2 ≤ 4; −x2 ≤ 0
g1 = @(x) -2*x(1) + x(2);
g2 = @(x) x(1) + x(2) - 4;
g3 = @(x) -x(2);
penalty = @(x) max(0, g1(x))^2 + max(0, g2(x))^2 + max(0, g3(x))^2;

% Funzione penalizzata
mu = 1e-1;                                          % Parametro iniziale di penalità
penalized_f = @(x, mu) f(x) + (1/mu) * penalty(x);

% Parametri di ottimizzazione
x0 = [3; 2];                            % Punto iniziale
mu_vals = [1e-1, 1e-2, 1e-3, 1e-4];
x_vals = x0;

% Ciclo di penalizzazione con fminunc
options = optimoptions('fminunc', 'Algorithm', 'quasi-newton', 'Display', 'off');

for mu = mu_vals
    obj = @(x) f(x) + (1/mu) * penalty(x);  % Funzione obiettivo
    x0 = fminunc(obj, x0, options);
    x_vals = [x_vals, x0]; 
end

% Plot finale
figure;
hold on;
[xg, yg] = meshgrid(linspace(-1, 4, 400), linspace(-1, 4, 400));
Z = 0.5*(xg - 3).^2 + (yg - 2).^2;
contour(xg, yg, Z, 30, 'LineWidth', 1.2); hold on;
%contour(@(x, y) f([x; y]), [-1 4 -1 4], 'LevelStep', 0.5, 'LineWidth', 1.2);
colormap('parula');
colorbar;
xlabel('x'); ylabel('y');
title('Penalizzazione per vincoli di disuguaglianza');
axis equal; grid on;

% Rappresenta le regioni dei vincoli
fimplicit(@(x, y) -2*x + y, [-1 4 -1 4], 'r--', 'LineWidth', 1.5, 'DisplayName', '-2x + y \leq 0');
fimplicit(@(x, y) x + y - 4, [-1 4 -1 4], 'b--', 'LineWidth', 1.5, 'DisplayName', 'x + y \leq 4');
fimplicit(@(x, y) -y, [-1 4 -1 4], 'g--', 'LineWidth', 1.5, 'DisplayName', 'y \geq 0');

% Iterazioni
plot(x_vals(1,:), x_vals(2,:), 'ko--', 'DisplayName', 'Iterazioni');
scatter(x_vals(1,1), x_vals(2,1), 50, 'b', 'filled', 'DisplayName', 'Inizio');
scatter(x_vals(1,end), x_vals(2,end), 50, 'r', 'filled', 'DisplayName', 'Ottimo');

legend('Location', 'bestoutside');
