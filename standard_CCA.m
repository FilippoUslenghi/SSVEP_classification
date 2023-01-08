%% 5 Hz blinking light
clearvars;
clc;
close all

fs = 1000;
data_dir = "data/6hz-01.h5";
data = h5read(data_dir, "/20:15:12:22:81:60/raw/channel_4");
data = cast(data, "double");

% Filtering the signal
% data = bandpass(data, [2, 40], fs);

n_windows = 3;
windowTime = 24; % seconds
windowLength = windowTime*fs;

windows = zeros(windowLength, n_windows);
for ii = 1:n_windows
    windows(:, ii) = data(windowLength*(ii-1)+1:windowLength*ii);
end

%%er
first_window = windows(:, 1);

n_samples = 10;
sampleLength = windowLength/n_samples;
samples = reshape(first_window, [sampleLength, n_samples]);

targetFreqMatrix = zeros(size(samples));
for ii = 1:n_samples
    targetFreqMatrix(:, ii) = ;
end
