clear all
close all
clc

%A = [10 -1 2 0; -1 11 -1 3; 2 -1 10 -1; 0 3 -1 8];  % Matrice dei coefficienti
%b = [6; 25; -11; 15];                              % Vettore dei termini noti

A = [1 -2 2; -1 1 -1; -2 -2 1];             % Matrice dei coefficienti
b = [6; 25; -11];                           % Vettore dei termini noti
tol = 1e-6;                                 % Tolleranza
max_iter = 100;                             % Numero massimo di iterazioni

x = gauss_seidel(A, b, tol, max_iter);

disp('Soluzione approssimata:');
disp(x);
