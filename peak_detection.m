clearvars;
clc;
close all

% Loading the data
dataDir = "data/6hz_01.h5";
data = h5read(dataDir, "/20:15:12:22:81:60/raw/channel_4");
data = cast(data, "double")';

fs = 1000;
T = 1/fs;
N = length(data);
t_axis = (0:N-1)/fs;
f_axis = (0:N-1)/N*fs;

% Filtering the signal
data = bandpass(data, [2, 40], fs);

S_periodogram=T*abs(fft(data-mean(data))).^2/N;
S_periodogram(1)=nan;

figure
plot(f_axis(1:end/2), S_periodogram(1:end/2))
