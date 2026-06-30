% Fourier: Esempio serie
clear all; close all; clc;

kmax = 50;              % Numero di modi
dx = 0.0001;            % Dimensione griglia
L = pi;                 % Lunghezza dominio
x = (-1+dx:dx:1)*L;     % Griglia
f = 0*x;                % Inizializzazione funzione
n = length(f);          % Numero elementi della griglia
nquart = floor(n/4); 
nhalf = floor(n/2);
% Assegnamo i valori alla funzione f
f(nquart:nhalf) = 4*(1:nquart+1)/n;
f(nhalf+1:3*nquart) = 1-4*(0:nquart-1)/n;

%figure
clear ERR;
clear A;
A0 = sum(f.*ones(size(x)))*dx;      % Primo coeff. Fourier
fFS = A0/2;
A(1) = A0/2;
ERR(1) = norm(f-fFS);
kmax = 100;
for k=1:kmax
    A(k+1) = sum(f.*cos(pi*k*x/L))*dx;
    B(k+1) = sum(f.*sin(pi*k*x/L))*dx;
    fFS = fFS + A(k+1)*cos(k*pi*x/L) + B(k+1)*sin(k*pi*x/L);
    ERR(k+1) = norm(f-fFS)/norm(f);
end
title('Polinomi trigonometrici')

figure
hold on
plot(x,f,x,fFS,'-','LineWidth',1.2)
legend('   f  ','  f with fourier  ')
title('Rappresentazione funzione e polinomio di Fourier')

figure
thresh = 0.1;            % median(ERR);%*sqrt(kmax)*4/sqrt(3);
r = max(find(ERR>thresh));
r = floor(r)+1;
subplot(2,1,1)
semilogy(0:1:kmax,A,'k','LineWidth',1.5)
title('Coefficienti di Fourier a_k')
hold on
semilogy(r,A(r+1),'bo','LineWidth',1.5)
xlim([0 kmax])
ylim([10^(-7) 1])
subplot(2,1,2)
semilogy(0:1:kmax,ERR,'k','LineWidth',1.5)
hold on
semilogy(r,ERR(r+1),'bo','LineWidth',1.5)
title('Errore relativo')

figure
A0 = sum(f.*ones(size(x)))*dx; % primo coeff. Fourier
fFS = A0/2; 
hold on
for k=1:r
    A(k) = sum(f.*cos(pi*k*x/L))*dx;                        % Coeff. fourier
    B(k) = sum(f.*sin(pi*k*x/L))*dx;                        % Coeff. fourier
    plot(x,A(k)*cos(k*pi*x/L),'-','LineWidth',1.5);         % Plot dei polinomi trigonometrici
    fFS = fFS + A(k)*cos(k*pi*x/L) + 0*B(k)*sin(k*pi*x/L);  % Costruzione del polinomio di fourier
end
title('Polinomi trigonometrici')

figure
hold on
plot(x,f,x,fFS,'-','LineWidth',1.2)
legend('   f  ','  f with fourier  ')
title('Rappresentazione funzione e polinomio di Fourier')