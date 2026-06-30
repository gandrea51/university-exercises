% Ottimizzazione vincolata: Penalizzazione esterna
clear all; close all; clc;

% Funzione obiettivo: Rosenbrock
f = @(x) 100*(x(2) - x(1)^2)^2 + (1 - x(1))^2;

% Vincolo di uguaglianza
h = @(x) (x(1) + 0.5)^2 + (x(2) + 0.5)^2 - 0.25;

% Penalizzazione
penalized = @(x, mu) f(x) + (1/mu) * h(x)^2;

% Parametri penalizzazione
mu_values = [1e-1, 1e-2, 1e-3, 1e-4];
x_vals = zeros(length(mu_values)+1, 2);
x0 = [1, 1];
x_vals(1, :) = x0;

% Ottimizzazione iterativa
for i = 1:length(mu_values)
    mu = mu_values(i)               % Valore di penalizzazione
    obj = @(x) penalize(x, mu);     % Funzione obiettivo
    x0 = fminunc(obj, x0, optimoptions('fminunc', 'Display', 'off', 'Algorithm', 'quasi-newton'));
    x_vals(i+1, :) = x0;            % Salvataggio dei valori
end

% Griglia per contour plot
[xg, yg] = meshgrid(linspace(-1.5, 1.5, 100), linspace(-1.5, 1.5, 100));
F = 100*(yg - xg.^2).^2 + (1 - xg).^2;

% Plot
figure;
contour(xg, yg, F, 30, 'LineWidth', 1.2); hold on;
%colormap('viridis');
colorbar;
xlabel('x'); ylabel('y');
title('Rosenbrock con vincolo circolare e iterazioni');
axis equal;
grid on;

% Vincolo: cerchio centrato in (-0.5, -0.5) di raggio 0.5
theta = linspace(0, 2*pi, 400);
xc = -0.5 + 0.5*cos(theta);
yc = -0.5 + 0.5*sin(theta);
plot(xc, yc, 'r-', 'LineWidth', 2, 'DisplayName', 'Vincolo');

% Iterazioni
plot(x_vals(:,1), x_vals(:,2), 'ko--', 'DisplayName', 'Iterazioni');
plot(x_vals(1,1), x_vals(1,2), 'bo', 'MarkerFaceColor', 'b', 'DisplayName', 'Inizio');
plot(x_vals(end,1), x_vals(end,2), 'ro', 'MarkerFaceColor', 'r', 'DisplayName', 'Fine');

legend('Location', 'southeast');

figure
surf(F)
