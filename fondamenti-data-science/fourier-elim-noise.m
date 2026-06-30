% Fourier: Noise elimination 
clear all; close all; clc;

% Signal generation
dt = .001; 
t = 0 : dt : 1;
x = sin(2 * pi * 50 * t) + sin(2*pi*120*t);

% Add Gaussian noise
n = 2 * randn(size(t));
y = x + n;

% Perform Fourier Transformation (fft with length of x)
N = length(y);
Y = fft(y);
freq = (0: N-1) / (N*dt);

% Calculate Power Spectrum Density
PSD = abs(Y).^2 / (N*dt);       % The power spectrum is the squared magnitude of the FFT coefficients

% Filter the signal by thresholding the power spectrum
threshold = 100;                        % Define a threshold to filter out noise
indices = PSD < threshold;              % Find indices of coefficients with power below the threshold
PSDclean = PSD;                         % Initialize the cleaned power spectrum
PSDclean(indices) = 0;                  % Set the power of noisy frequencies to zero

Yclean = Y;                     % Initialize the cleaned Fourier coefficients
Yclean(indices) = 0;            % Set the coefficients of noisy frequencies to zero

% Compute the Inverse Fourier Transform
yfilt = ifft(Yclean);                   % Compute the inverse FFT to get the filtered signal

% Plotting results

% The first plot compares the original signal (without noise) to the noisy signal
figure;
plot(t, y, 'r', 'LineWidth', 1.2);          % Plot the noisy signal
hold on;
plot(t, x, 'k-o', 'LineWidth', 1.5);        % Plot the original signal
axis([0 .25 -5 5]);
legend('Noisy signal','Original signal');
title('Original vs. Noisy signal');
xlabel('Time (s)');
ylabel('Amplitude');


% The second plot compares the original signal to the filtered signal
figure;
plot(t, x, 'k', 'LineWidth', 1.5);          % Plot the original signal
hold on;
plot(t, yfilt, 'b', 'LineWidth', 1.2);      % Plot the filtered signal
axis([0 .25 -5 5]);
legend('Original Signal', 'Filtered Signal');
title('Original vs. Filtered Signal');
xlabel('Time (s)');
ylabel('Amplitude');

% The third plot compares the power spectrum of the noisy and filtered signals
figure;
plot(freq(2:end), PSD(2:end), 'r', 'LineWidth', 1.5);       % Plot noisy power spectrum (excluding DC component)
hold on;
plot(freq(2:end), PSDclean(2:end), '-b', 'LineWidth', 1.2); % Plot filtered power spectrum
legend('Noisy Power Spectrum', 'Filtered Power Spectrum');
title('Power Spectrum Analysis');
xlabel('Frequency (Hz)');
ylabel('Power');
grid on;
