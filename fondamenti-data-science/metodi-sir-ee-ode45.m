% Simulazione del modello SIR con Eulero esplicito e ode45
clear all; close all; clc;

% Parametri del modello
beta = 0.3;     % Tasso di contagio
gamma = 0.1;    % Tasso di recupero

% Popolazione iniziale
N = 1;
I0 = 1e-3;
R0 = 0;
S0 = N - I0 - R0;

% Intervallo temporale
T = 160;            % Giorni
h = 1;              % Passo temporale per Eulero
t_euler = 0:h:T;
Nsteps = length(t_euler);

% Inizializzazione Eulero
S_euler = zeros(1, Nsteps); I_euler = zeros(1, Nsteps); R_euler = zeros(1, Nsteps);
S_euler(1) = S0; I_euler(1) = I0; R_euler(1) = R0;

% Eulero esplicito
for n = 1:Nsteps-1
    
    dS = -beta * S_euler(n) * I_euler(n);
    dI = beta * S_euler(n) * I_euler(n) - gamma * I_euler(n);
    dR = gamma * I_euler(n);

    S_euler(n+1) = S_euler(n) + h * dS;
    I_euler(n+1) = I_euler(n) + h * dI; 
    R_euler(n+1) = R_euler(n) + h * dR;
end

% ODE45 per confronto
sir_ode = @(t, y) [-beta*y(1)*y(2); beta*y(1)*y(2)-gamma*y(2); gamma*y(2)];
[t_ode, y_ode] = ode45(sir_ode, [0 T], [S0; I0; R0]);

% Plot confronto
figure;
subplot(3,1,1)
plot(t_ode, y_ode(:,1), 'b', t_euler, S_euler, 'b--');
ylabel('Suscettibili');
legend('ode45','Eulero','Location','northeast');
title('Confronto SIR - ode45 vs Eulero esplicito');
grid on;

subplot(3,1,2)
plot(t_ode, y_ode(:,2), 'r', t_euler, I_euler, 'r--');
ylabel('Infetti');
legend('ode45','Eulero','Location','northeast');
grid on;

subplot(3,1,3)
plot(t_ode, y_ode(:,3), 'g', t_euler, R_euler, 'g--');
xlabel('Tempo (giorni)');
ylabel('Rimossi');
legend('ode45','Eulero','Location','southeast');
grid on;
