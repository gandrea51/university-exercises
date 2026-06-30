% Confronto tra schemi alle Differenze finite (Esplicito, Implicito, Centrato)

%% Explicit scheme 
close all; clear all; clc;

lg = 10.;               % Length of the semi-space 
dx = 0.05;              % Mesh step
nx = lg/dx;             % Half number of points 
cfl = 0.1;              % CFL condition for stability
dt = dx * dx * cfl;     % Time step
Tfinal = 0.5;           % Final time
nt = floor(Tfinal/dt);  % Number of time iteration

% Inizializzazione

x = zeros(1, 2*nx+1);       % Mesh
u0 = zeros(1, 2*nx+1);      % Initial data
for i = 1 : 2*nx+1
  x(i) = (i - nx - 1) * dx;
  u0(i) = max(0., 1. - x(i)^2);
end

u = u0;         % Solution over time
up = u0;        % Right shifted vector
um = u0;        % Left shifted vector 
uexact = u0;

plot(x,u0,'linewidth',2)
title('initial data') 

pause();

%% Explicit scheme: cfl=0.4

for n = 1:nt
    up = shift(1, u);
    um = shift(-1, u);
        
    u= u  + dt/(dx * dx) * (up + um - 2 * u);
    
    if rem(n, 5) == 0
        clf()
        hold on
        plot(x,u,x,u0,'linewidth',2)
        %plot(x,u,'linewidth',2)
        title('Explicit scheme, cfl=0.4');
        pause(0.01);
    end
end

% Comparing the exact with the computed solution
uexact = zeros(1, 2 * nx + 1);          % 1/sqrt(4pit)int u_0(y)e(-(x-y)^2/4t)dy
for i = 1 : 2 * nx+1
    for j = 1 : 2 * nx+1
         uexact(i) = uexact(i) + u0(j) * dx * exp(-((i-j) * dx)^2 / (4*nt*dt));
    end
    uexact(i) = uexact(i) / sqrt(4*pi*nt*dt);
end

figure
plot(x,u,x,uexact,x,u0,'linewidth',2)
legend('computed','exact','initial')
title('Explicit scheme, cfl=0.4, 500 time steps');

pause()

%% Unstable centred scheme

cfl = 0.1;
dt = dx * dx * cfl;
u = u0;
u1= u0; 
u2 = u0;
nt=25;
up = shift(1, u0);
um = shift(-1, u0);
u1 = u0 + dt / (dx*dx) * (up+um-2*u0);

for n = 2 : nt
    up = shift(1, u1);
    um = shift(-1, u1);
    
    u = u2 + 2 * dt / (dx*dx) * (up+um-2*u1);
    u2 = u1;
    u1 = u;
    
    if rem(n, 1) == 0
        clf()
        plot(x,u,x,u0,'linewidth',2)                
        title('central scheme, cfl=0.1');
        pause(0.1);
    end
end

% Comparing the exact with the computed solution
uexact = zeros(1, 2*nx+1);
for i = 1 : 2 * nx+1
    for j = 1 : 2 * nx+1
         uexact(i) = uexact(i) + u0(j) * dx * exp(-((i-j) * dx)^2 / (4*nt*dt));
    end
    uexact(i) = uexact(i) / sqrt(4*pi*nt*dt);
end

clf()
figure
plot(x,u,x,uexact,x,u0,'linewidth',2)
legend('computed','exact','initial')
title('Central scheme, cfl=0.1, 25 time steps');
pause();

%% Implicit scheme: cfl=2
cfl = 2.;
dt = dx*dx*cfl;
u = u0;
nt=200;
mat = zeros(2*nx+1, 2*nx+1);

for i = 2 : 2 * nx
  mat(i,i) = 1. + 2*dt / (dx*dx);
  mat(i,i+1) =  -dt / (dx*dx);
  mat(i,i-1) = -dt / (dx*dx);
end

mat(1,1) = 1. + 2 * dt / (dx*dx);
mat(1,2) =  -dt / (dx*dx);
mat(2*nx+1,2*nx) = -dt / (dx*dx);
mat(2*nx+1,2*nx+1) = 1. + 2*dt / (dx*dx);

for n=1:nt
    u =(mat^-1 * u')'; 

    if rem(n,5) == 0
        clf()
        plot(x,u,x,u0,'linewidth',2)                
        title('implicit scheme, cfl=2');
        pause(0.1);
    end
end

% Comparing the exact with the computed solution
uexact = zeros(1, 2*nx+1);
for i = 1 : 2*nx+1
    for j = 1 : 2*nx+1
         uexact(i) = uexact(i) + u0(j)*dx*exp(-((i-j)*dx)^2/(4*nt*dt));
    end
    uexact(i) = uexact(i)/sqrt(4*pi*nt*dt) ;
end
clf()
plot(x,u,x,uexact,x,u0,'linewidth',2)
legend('computed','exact','initial')
title('Implicit scheme, cfl=2, 200 time steps');
pause(0.1);