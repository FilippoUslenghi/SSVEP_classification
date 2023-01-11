%%
clearvars;
clc
close all

data = load_data("data/6hz_03.h5");
data = data(1:2000-1);

targetFreq = 6; %Hz
fs = 1000;

% Filtering the signal
data = bandpass(data, [2, 40], fs);

% Compute the periodogram
[PSD, freqs_PSD] = compute_PSD(data, fs);
exp_PSD = PSD.^2; % squared it

% Detect the SSVEP component
perc = 90; % percentile of the sorted peaks
[pks, locs] = find_highest_peaks(exp_PSD, freqs_PSD, perc, 0);

detection = any(bitand(locs>targetFreq-.25, locs<targetFreq+.25));
if detection
    fprintf("You were looking at light blinking at %.1f Hz\n", targetFreq)
else
    disp("You were NOT looking at blinking light")
end

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
    signal_periodogram = signal_periodogram(1:round(end/2));
    freqs_periodogram = (0:N-1)/N*fs;
    freqs_periodogram = freqs_periodogram(1:round(end/2));
end

function [pks_perc,locs_perc] = find_highest_peaks(Y, X, perc, plots)
% Find the "perc"-th percentile of the sorted peaks

    [pks, locs] = findpeaks(Y, X, "SortStr", "descend");
    P = prctile(pks, perc);
    pks_perc = pks(pks>P);
    locs_perc = locs(pks>P);
    
    if plots
        P_idx = find(diff(pks>P));
        figure()
        plot(pks)
        hold on
        plot(P_idx, pks(P_idx), '-x', 'Color', 'r')
    end
end
