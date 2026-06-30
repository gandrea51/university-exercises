% Confronto: Metodo di Newton vs Gradient Descent per minimizzare f(x)
clear all; close all; clc;

% Funzione e derivate
f = @(x) x.^4 - 3*x.^3 + 2;
df = @(x) 4*x.^3 - 9*x.^2;
d2f = @(x) 12*x.^2 - 18*x;

% Parametri generali
x0 = 2;                  % Punto iniziale
tol = 1e-8;
max_iter = 50;

% --------------------
% Metodo di Newton
x_newton = x0;
newton_hist = x0;

for i = 1:max_iter
    if abs(df(x_newton)) < tol
        break;
    end
    x_newton = x_newton - df(x_newton) / d2f(x_newton);
    newton_hist(end+1) = x_newton;
end

% --------------------
% Gradient Descent
alpha = 0.01;           
x_gd = x0;
gd_hist = x_gd;

for i = 1:max_iter
    if abs(df(x_gd)) < tol
        break;
    end
    x_gd = x_gd - alpha * df(x_gd);
    gd_hist(end+1) = x_gd;
end

% --------------------
% Grafico della funzione e dei percorsi
x_vals = linspace(min([newton_hist gd_hist])-1, max([newton_hist gd_hist])+1, 500);
y_vals = f(x_vals);

figure;
plot(x_vals, y_vals, 'k-', 'LineWidth', 1.5); hold on;
plot(newton_hist, f(newton_hist), 'ro-', 'MarkerFaceColor', 'r', 'DisplayName', 'Newton');
plot(gd_hist, f(gd_hist), 'bo-', 'MarkerFaceColor', 'b', 'DisplayName', 'Gradient Descent');
legend('f(x)', 'Newton', 'Gradient Descent', 'Location', 'best');
xlabel('x'); ylabel('f(x)');
title('Confronto: Metodo di Newton vs Gradient Descent');
grid on;

% --------------------
% Confronto iterativo
fprintf('\nNumero di iterazioni:\n');
fprintf('Metodo di Newton: %d\n', numel(newton_hist) - 1);
fprintf('Gradient Descent: %d\n', numel(gd_hist) - 1);




