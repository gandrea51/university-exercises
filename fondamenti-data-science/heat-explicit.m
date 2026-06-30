% Explicit scheme 
close all; clear all; clc;

function v_shifted = shift(k, v)
    N = length(v);
    k = mod(k, N); % Assicura k nell'intervallo [0, N-1]
    if k == 0
        v_shifted = v;
    elseif k > 0
        % Shift a destra: v(i+1) -> up
        v_shifted = [v(N-k+1:N), v(1:N-k)];
    else 
        % Shift a sinistra: v(i-1) -> um
        k = abs(k);
        v_shifted = [v(k+1:N), v(1:k)];
    end
end

lg = 10.;               % Semi-lunghezza spazio 
dx = 0.05;              % Dimensione della mesh
nx = lg/dx;             % Numero di punti (meta') 
cfl = 0.4;              % Condizione CFL per la stabilita'
dt = dx*dx*cfl;         % Passo temporale
Tfinal=0.5;             % Tempo finale
nt=floor(Tfinal/dt);    % Numero di passi temporali

lambda = dt / (dx * dx);

% Inizializzazione

x=zeros(1,2*nx+1);      % Punti nello spazio
u0=zeros(1,2*nx+1);     % Dato iniziale
for i=1:2*nx+1
  x(i) = (i-nx-1)*dx;
  u0(i) = max(0.,1.-x(i)^2);
end
u=u0;           % Soluzione
up=u0;          % Vettore della soluzione con shift a destra
um=u0;          % Vettore della soluzione con shift a destra 
uexact=u0;

figure;
plot(x,u0,'linewidth',2);
title('dato iniziale') ;
grid on;

for n=1:nt
    up = shift(1,u);
    um = shift(-1,u);
        
    u = u + lambda * (up - 2*u + um);
    
    if rem(n,5) == 0
        clf()
        plot(x,u,x,u0,'linewidth',2)
        title('explicit scheme, cfl=0.4');
        pause(0.01);
    end
end

% Confronto con la soluzione pseudo-esatta
uexact = zeros(1,2*nx+1);       % Formula soluzione esatta da implementare 1/sqrt(4pit)int u_0(y)e(-(x-y)^2/4t)dy
for i=1:2*nx+1                  % Per ogni punto nello spazio calcolo la soluzione esatta
    for j=1:2*nx+1              % Ciclo su ogni punto dello spazio 
         t=nt*dt;
         y=j*dx;
         x1=i*dx;
         uexact(i) = uexact(i) + integrale da calcolare somma di Riemann;
    end
    uexact(i) = uexact(i)/sqrt(4*pi*t) ;
end
plot(x,u,x,uexact,x,u0,'linewidth',2)
legend('computed','exact','initial')
title('Explicit scheme, cfl=0.4, 500 time steps');