%%
clearvars;
clc
close all

data = load_data("../data/6hz_01.h5");
n_window = 4;
windowLength = 2000;
% data = data((n_window-1)*windowLength+1:n_window*windowLength);
% data = data(20000:21000);

targetFreqs = [6, 7.4]; %Hz
filterFreqs = [4, 10];
fs = 1000;

% Filtering the signal
data = bandpass(data, filterFreqs, fs);

% Compute the periodogram
[PSD, freqs_PSD] = compute_PSD(data, fs);
exp_PSD = PSD; % squared it

figure()
plot(freqs_PSD, exp_PSD)
xlim([0,50])
ylim([0,max(exp_PSD)])

% Search the 'perc' percentile of the sorted peaks
perc = 90;
[pks, locs] = findpeaks(exp_PSD, freqs_PSD, "SortStr", "descend");
P = prctile(pks, perc);
pksPerc = pks(pks>P);
locsPerc = locs(pks>P);

P_idx = find(diff(pks>P));

figure()
plot(pks)
hold on
plot(P_idx, pks(P_idx), 'x', 'Color', 'r')

intervalDetection = .5;
detectedFreqs =[];
for ii = 1:length(targetFreqs)
    targetFreq = targetFreqs(ii);
    detectedFreqs = cat(2, detectedFreqs, locsPerc(locsPerc>targetFreq-intervalDetection ...
        & locsPerc<targetFreq+intervalDetection));
end

if detectedFreqs 
    [~, indexDetectedFreqs] = ismember(detectedFreqs, locsPerc); 
    detectedFreqsPower = pksPerc(indexDetectedFreqs);
    maxDetectedFreq = locsPerc(pksPerc==max(detectedFreqsPower));
    
    [~,idx] = min(abs(targetFreqs-maxDetectedFreq));
    targetFreqDetected = targetFreqs(idx);
    fprintf("You were looking at light blinking at %.1f Hz\n", targetFreqDetected)
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
