function [signal_periodogram, freqs_periodogram] = compute_PSD(signal, fs)
% Computes the periodogram of the signal 'signal' sampled with frequency 'fs'
    
    T = 1/fs;    
    N = length(signal);
    signal_periodogram = T*abs(fft(signal-mean(signal))).^2/N;
    signal_periodogram(1) = nan;
    signal_periodogram = signal_periodogram(1:round(end/2));
    freqs_periodogram = (0:N-1)/N*fs;
    freqs_periodogram = freqs_periodogram(1:round(end/2));
end