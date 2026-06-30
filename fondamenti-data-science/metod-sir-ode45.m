% Modello SIR - Soluzione numerica con ode45
clear all; close all; clc;

% Parametri del modello
beta = 0.3;     % Tasso di contagio
gamma = 0.1;    % Tasso di recupero

% Popolazione iniziale
N = 1;              % Popolazione totale
I0 = 1e-3;          % Infetti iniziali
R0 = 0;             % Rimossi iniziali
S0 = N - I0 - R0;   % Suscettibili iniziali

% Tempo di simulazione
tspan = [0 120];

% Sistema di equazioni
sir_ode = @(t, y) [-beta*y(1)*y(2); 
                    beta*y(1)*y(2)-gamma*y(2); 
                    gamma*y(2)];

% Condizioni iniziali
y0 = [S0; I0; R0];

% Risoluzione numerica
[t, y] = ode45(sir_ode, tspan, y0);

% Plot dei risultati
figure;
plot(t, y(:,1), 'b-', 'LineWidth', 2); hold on;
plot(t, y(:,2), 'r-', 'LineWidth', 2);
plot(t, y(:,3), 'g-', 'LineWidth', 2);
xlabel('Tempo (giorni)');
ylabel('Numero di individui');
legend('Suscettibili', 'Infetti', 'Rimossi', 'Location', 'best');
title('Modello SIR - Simulazione epidemica');
grid on;
