%% This script shows the benefits of using zero padding for increasing
% the resolution of the FFT, thus allowing for a better search of 
% the maximum value around the frequency of interest

clearvars;
clc
close all

data = load_data("data/my_data/6hz_01.h5");
n_window = 1;
windowLength = 2*1000;
data = data((n_window-1)*windowLength+1:n_window*windowLength);

fs=1000;
N = length(data);
fAxis = (0:N-1)/N*fs;

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
ylim([0 5e4])
