%%
clearvars;
clc
close all

data = load_data("data/6hz_01.h5");

fs = 1000;
T = 1/fs;
N = length(data);
t_axis = (0:N-1)/fs;
f_axis = (0:N-1)/N*fs;

% Filtering the signal
data = bandpass(data, [2, 40], fs);

% Compute the periodogram and then it's exponential version
[PSD, freqs_PSD] = compute_PSD(data, fs);
exp_PSD = PSD.^2;

figure()
plot(freqs_PSD, exp_PSD)

%% Find 99th percentile of the sorted peaks
[pks, locs] = findpeaks(exp_PSD, freqs_PSD, "SortStr", "descend");
P = prctile(pks, 99);
L = prctile(locs, 99);
pks_99perc = pks(pks>P);
locs_99perc = locs(pks>P);
P_idx = find(diff(pks>P));
plot(pks)
hold on
plot(P_idx, P, '-x')

%% Functions

function data = load_data(dataDir)
% Loads the data from the h5 file of the dataset

    data = h5read(dataDir, "/20:15:12:22:81:60/raw/channel_4");
    data = cast(data, "double")';
end


function [signal_periodogram, freqs_periodogram] = compute_PSD(signal, fs)
% Computes the periodogram of the signal 'signal' sampled with frequency 'fs'
    
    T = 1/fs;    
    N = length(signal);
    signal_periodogram = T*abs(fft(signal-mean(signal))).^2/N;
    signal_periodogram(1) = nan;
    signal_periodogram = signal_periodogram(1:end/2);
    freqs_periodogram = (0:N-1)/N*fs;
    freqs_periodogram = freqs_periodogram(1:end/2);
end
