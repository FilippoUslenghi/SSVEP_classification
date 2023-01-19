%%
clearvars;
clc
close all

data = load_data("data/6hz_01.h5");
n_window = 1;
windowLength = 2*1000;
data = data((n_window-1)*windowLength+1:n_window*windowLength);

fs=1000;
N = length(data);
fAxis = (0:N-1)/N*fs;

% Filtering the signal
% data = bandpass(data, [4 10], fs);

% Plotting the DFT of the signal
ax = zeros(2,1);
figure()
ax(1) = subplot(2,1,1);
plot(fAxis, abs(fft(data)))
title("Without zero padding")

zeroPadding = zeros(50000, 1);
zeroPaddedData = cat(1, data, zeroPadding);
new_N = length(zeroPaddedData);
fAxis = (0:new_N-1)/new_N*fs;
ax(2) = subplot(2,1,2);
plot(fAxis, abs(fft(zeroPaddedData)))
title("With zero padding")

linkaxes(ax)
xlim([3 11])
