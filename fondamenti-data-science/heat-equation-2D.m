% Equazione del calore in 2 dimensioni
clear all; close all; clc;

% Inizializzazione
Lx = 1;               % Lunghezza dominio in direzione x
Ly = 1;               % Lunghezza dominio in direzione y
dx = 0.025;           % Mesh size in direzione x
dy = 0.025;           % Mesh size in direzione y
cfl = 0.4;            % Necessaria per la stabilita' schema esplicito
nx = Lx / dx;           % Numero di punti in direzione x
ny = Ly / dy;           % Numero di punti in direzione y
dt = cfl/(1/dx^2 + 1/dy^2);       % Passo temporale per stabilita'
Tfinal = 0.01;
nt = floor(Tfinal/dt);            % Numero di cicli temporali per arrivare al tempo finale

% Dati inziali
x = zeros(1, nx + 1);
y = zeros(1, ny + 1);
u0 = zeros(nx + 1, ny + 1);      % Primo indice mi descrive lo spostamento lungo l'asse x,il secondo lungo l'asse y
                                 % Attenzione perche' in linguaggio matriciale il primo indice e' la riga, il secondo la colonna

for i=1 : nx+1                      % Ciclo su x   
    x(i) = dx * (i-1);              % Vettore griglia in direzione x
    for j = 1 : ny+1                % Ciclo su y
        y(j) = (j-1) * dy;          % Vettore griglia in direzione y
        u0(i,j) = max(0, 1 - 500 * (x(i) - 0.5)^2 - 500 * (y(j) - 0.5)^2);
    end
end
surf(u0)

u = u0;
for ii = 1 : nt
    u_new = u;
    for i = 2:nx
        for j = 2:ny
            dx2 = (u(i+1, j) - 2*u(i, j) + u(i-1, j)) / dx^2;
            dy2 = (u(i, j+1) - 2*u(i, j) + u(i, j-1)) / dy^2;
            u_new(i, j) = u(i, j)  + dt * (dx2 + dy2);
        end
    end

    u = u_new;
    drawnow
    surf(u)
end
