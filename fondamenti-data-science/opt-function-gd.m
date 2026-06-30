% Ott. vincolata: Penalizzazione esterna con GD
clear all; close all; clc;

% Funzione obiettivo e vincolo
f = @(x) 100*(x(2) - x(1)^2)^2 + (1 - x(1))^2;
h = @(x) (x(1) + 0.5)^2 + (x(2) + 0.5)^2 - 0.25;

grad_f = @(x) [
    -400*x(1)*(x(2) - x(1)^2) - 2*(1 - x(1));
    200*(x(2) - x(1)^2)
];
grad_h = @(x) [
    2*(x(1) + 0.5);
    2*(x(2) + 0.5)
];

% Function per la discesa del gradiente
function traj = gradient_descent(x_start, alpha, max_iter, mu, h_func, grad_f_func, grad_h_func)
    x_k = x_start(:);
    traj = x_k';
    for k = 1:max_iter
        h_val = h_func(x_k);
        
        grad_h_val = grad_h_func(x_k);
        grad_f_val = grad_f_func(x_k);
        
        % Calcolo del gradiente della funzione penalizzata (phi)
        grad_phi = grad_f_val + (1/mu) * 2 * h_val * grad_h_val;
        
        x_k = x_k - alpha * grad_phi;       % Aggiornamento del passo
        traj = [traj; x_k'];
        
        % Criterio di arresto
        if norm(alpha * grad_phi) < 1e-4
            break;
        end
    end
end

% Parametri penalizzazione
mu_values = [1e-1, 1e-2, 1e-3, 1e-4];
x0 = [1, 1];
x_vals = x0;

% Loop su penalità con discesa
for mu = mu_values
    % phi = @(x) f(x) + (1/mu)*h(x)^2;
    
    % Funzione da minimizzare phi, punto iniziale x0, passo 0.01*mu, numero iterazioni massimo 5000
    traj = gradient_descent(x0, 0.001, 5000, mu, h, grad_f, grad_h);
    x0 = traj(end, :);          % Ultimo valore in uscita dall'algoritmo di discesa del gradiente.
    x_vals = [x_vals; x0];
end

% Griglia per la funzione
[xg, yg] = meshgrid(linspace(-1.5, 1.5, 400), linspace(-1.5, 1.5, 400));
Z = 100*(yg - xg.^2).^2 + (1 - xg).^2;

% Vincolo
theta = linspace(0, 2*pi, 400);
xc = -0.5 + 0.5*cos(theta);
yc = -0.5 + 0.5*sin(theta);

% Plot
figure;
contour(xg, yg, Z, 30, 'LineWidth', 1.2); hold on;
%colormap('viridis');
colorbar;
xlabel('x'); ylabel('y');
title('Penalizzazione + discesa del gradiente');
axis equal; grid on;

plot(xc, yc, 'r-', 'LineWidth', 2, 'DisplayName', 'Vincolo');
plot(x_vals(:,1), x_vals(:,2), 'ko--', 'DisplayName', 'Iterazioni');
plot(x_vals(1,1), x_vals(1,2), 'bo', 'MarkerFaceColor', 'b', 'DisplayName', 'Inizio');
plot(x_vals(end,1), x_vals(end,2), 'ro', 'MarkerFaceColor', 'r', 'DisplayName', 'Fine');
legend('Location', 'southeast');


