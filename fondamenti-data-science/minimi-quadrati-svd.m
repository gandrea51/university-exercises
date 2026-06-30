clear all; close all; clc;

x = 3;                                  % Pendenza vera dei dati
a = [-2:.25:2]';
b = a*x + 1*randn(size(a));             % Aggiungiamo del rumore gaussiano randn dati distributi in maniera normale
plot(a,x*a,'k','LineWidth',1.5)         % Plot dei dati corretti (lungo la retta)
hold on
plot(a,b,'rx','LineWidth',1.5)          % Plot dei dati con rumore

[U,S,V] = svd(a,'econ');                % Decomposizione SVD economica del vettore   
xtilde = V*inv(S)*U'*b;                 % Soluzione minimi quadrati con pseudo-inversa

plot(a,xtilde*a,'b--','LineWidth',1.5)   % Plot dela retta dei minim quadrati
l1=legend('retta dei dati','dati con rumore','Retta dei minimi quadrati');
grid on     
