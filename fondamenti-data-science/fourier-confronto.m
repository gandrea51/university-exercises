% Confronto tra DFT manuale - FFT (con costo computazionale)
clear all; close all; clc;

% Parametri
N = 8^4;            % Numero di campioni
Fs = 1000;          % Frequenza di campionamento (Hz)
t = (0:N-1)/Fs;     % Vettore temporale
f0 = 20;            % Frequenza del segnale (Hz)
f1=30;              % Frequenza del segnale (Hz)

% Segnale di prova
x = sin(2*pi*f0*t) + 0.5*sin(2*pi*2*f1*t);

% Calcolo della DFT (manuale)
n = 0:N-1;
k = n';
W = exp(-1j*2*pi*k*n/N);

% Misura tempo DFT manuale
tic;
X_dft = W * x'; 
tempo_dft = toc;

% Calcolo della FFT (Matlab) e misura tempo
tic;
X_fft = fft(x); 
tempo_fft = toc;

% Plot del confronto
figure;
f = (0:N-1)*(Fs/N);         % Asse delle frequenze

subplot(2,1,1);
stem(f, abs(X_dft), 'filled');
title(['DFT Manuale (tempo: ', num2str(tempo_dft, '%.6f'), ' s)']);
xlabel('Frequenza (Hz)');
ylabel('|X_{DFT}(f)|');
grid on;

subplot(2,1,2);
stem(f, abs(X_fft), 'filled');
title(['FFT Matlab (tempo: ', num2str(tempo_fft, '%.6f'), ' s)']);
xlabel('Frequenza (Hz)');
ylabel('|X_{FFT}(f)|');
grid on;

% Stampa costo computazionale
fprintf('Tempo di esecuzione DFT manuale: %.6f secondi\n', tempo_dft);
fprintf('Tempo di esecuzione FFT Matlab: %.6f secondi\n', tempo_fft);
fprintf('Rapporto tempo di esecuzione DFT manuale/FFT matlab: %.6f secondi\n', tempo_dft/tempo_fft);