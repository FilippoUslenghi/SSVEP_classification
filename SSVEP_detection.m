%%
clearvars;
clc
close all

data = load_data("data/7.4hz_05.h5");
n_window = 4;
windowLength = 2*1000;
data = data((n_window-1)*windowLength+1:n_window*windowLength);

fs=1000;
N = length(data);
fAxis = (0:N-1)/N*fs;

% Filtering the signal
filteredData = bandpass(data, [4 10], fs);
dftData = abs(fft(filteredData));

% Plotting the DFT of the signal
ax = zeros(2,1);
figure()
ax(1) = subplot(2,1,1);
plot(fAxis, dftData)
title("Without zero padding")

zeroPadding = zeros(50000, 1);
zeroPaddedData = cat(1, filteredData, zeroPadding);
new_N = length(zeroPaddedData);
fAxis = (0:new_N-1)/new_N*fs;
ax(2) = subplot(2,1,2);
plot(fAxis, abs(fft(zeroPaddedData)))
title("With zero padding")

linkaxes(ax)
xlim([3 11])

%%
targetFreqs = [6, 7.4]; %Hz







%%
% intervalDetection = .5;
% detectedFreqs =[];
% for ii = 1:length(targetFreqs)
%     targetFreq = targetFreqs(ii);
%     detectedFreqs = cat(2, detectedFreqs, locsPerc(locsPerc>targetFreq-intervalDetection ...
%         & locsPerc<targetFreq+intervalDetection));
% end
% 
% if detectedFreqs 
%     [~, indexDetectedFreqs] = ismember(detectedFreqs, locsPerc); 
%     detectedFreqsPower = pksPerc(indexDetectedFreqs);
%     maxDetectedFreq = locsPerc(pksPerc==max(detectedFreqsPower));
%     
%     [~,idx] = min(abs(targetFreqs-maxDetectedFreq));
%     targetFreqDetected = targetFreqs(idx);
%     fprintf("You were looking at light blinking at %.1f Hz\n", targetFreqDetected)
% else
%         disp("You were NOT looking at blinking light")    
% end
