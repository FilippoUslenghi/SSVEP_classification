%%
clearvars;
clc
close all

data = load_data("data/6hz_01.h5");
n_window = 4;
windowLength = 2000;
% data = data((n_window-1)*windowLength+1:n_window*windowLength);
data = data(20000:25000);

targetFreqs = [6, 7.4]; %Hz
fs = 1000;

% Filtering the signal
data = bandpass(data, [4, 40], fs);

% Compute the periodogram
[PSD, freqs_PSD] = compute_PSD(data, fs);
exp_PSD = PSD; % squared it

figure()
plot(freqs_PSD, exp_PSD)
xlim([0,50])
ylim([0,max(exp_PSD)])

% Search the 90th percentile of the sorted peaks
perc = 90;
[pks, locs] = findpeaks(exp_PSD, freqs_PSD, "SortStr", "descend");
P = prctile(pks, perc);
pks_perc = pks(pks>P);
locs_perc = locs(pks>P);

P_idx = find(diff(pks>P));

figure()
plot(pks)
hold on
plot(P_idx, pks(P_idx), '-x', 'Color', 'r')

detectedFreqs =[];
for ii = 1:length(targetFreqs)
    freq = targetFreqs(ii);
    detected = any(bitand(locs>freq-.25, locs<freq+.25));
    if detected
        detectedFreqs(ii) = freq;
    end
end

if detectedFreqs
        for freq = detectedFreqs
            fprintf("You were looking at light blinking at %.1f Hz\n", freq)
        end
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
