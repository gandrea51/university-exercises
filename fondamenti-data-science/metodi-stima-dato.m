% Fitting del modello SIR per stimare i parametri beta e gamma a partire dai dati
close all; clear all; clc;

% Caricamento dati
load('global_data.mat');  % Si assume che contenga Iperc, Sperc, Rperc

% Dati osservati
I_data = Iperc(1:end);  % Colonna
S_data = Sperc(1:end);
R_data = Rperc(1:end);

Nt = length(I_data);
T = Nt;
t_data = linspace(0, T, Nt);

% Popolazione iniziale (normalizzata o percentuale)
N = S_data(1) + I_data(1) + R_data(1);
y0 = [S_data(1), I_data(1), R_data(1)];

% Stima iniziale [beta, gamma]
params0 = [0.3, 0.03];

% Funzione obiettivo per la minimizzazione
cost_func = @(params) sir_error(params, t_data, S_data, I_data, R_data, y0);

% Ottimizzazione con fminsearch
[params_opt, fval] = fminsearch(cost_func, params0);

% Parametri ottimizzati
beta_est = params_opt(1);
gamma_est = params_opt(2);
fprintf('Beta stimato: %.4f\n', beta_est);
fprintf('Gamma stimato: %.4f\n', gamma_est);

% Simulazione con i parametri stimati
sir_ode = @(t, y) [
    -beta_est * y(1) * y(2);
     beta_est * y(1) * y(2) - gamma_est * y(2);
     gamma_est * y(2)
];
[t_fit, y_fit] = ode45(sir_ode, t_data, y0);

% Plot confronto
figure;
plot(t_data, I_data, 'ro', 'DisplayName', 'Infetti - dati'); hold on;
plot(t_fit, y_fit(:,2), 'r-', 'DisplayName', 'Infetti - modello');
plot(t_data, S_data, 'bo', 'DisplayName', 'Suscettibili - dati');
plot(t_fit, y_fit(:,1), 'b-', 'DisplayName', 'Suscettibili - modello');
plot(t_data, R_data, 'go', 'DisplayName', 'Rimossi - dati');
plot(t_fit, y_fit(:,3), 'g-', 'DisplayName', 'Rimossi - modello');
legend('Location', 'best');
xlabel('Tempo'); ylabel('Percentuale / individui');
title('Fit del modello SIR ai dati osservati');
grid on;
