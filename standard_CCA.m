%% 5 Hz blinking light
clearvars;
clc;
close all

fs = 1000;
dataDir = "data/6hz_01.h5";
data = h5read(dataDir, "/20:15:12:22:81:60/raw/channel_4");
data = cast(data, "double")';

% Filtering the signal
% data = bandpass(data, [2, 40], fs);

%%
% Creating the X matrix of signal for the CCA
windowTime = 2; % seconds
windowLength = windowTime*fs;
zeroPadding = zeros(windowLength-mod(length(data), windowLength), 1);
padded_data = cat(1, data, zeroPadding);

X = reshape(padded_data, [], windowLength);

% Creating the Y matrix of the target frequency for the CCA
targetFreq = 5; %Hz
n_harmonics = 8;
Y = zeros(n_harmonics*2, windowLength);
t = (0:windowLength-1)/fs;

for ii = 1:n_harmonics
    Y(2*(ii)-1, :) = sin(2*pi*targetFreq*ii*t);
    Y(2*(ii), :) = cos(2*pi*targetFreq*ii*t);
end


%%
[A,B] = canoncorr(X, Y);