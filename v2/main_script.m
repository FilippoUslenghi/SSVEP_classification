clearvars;
clc
close all

data = load_data("../data/6hz_03.h5");
realFreq = 6;
fs = 1000;
targetFreqs = [6, 7.4]; %Hz
filterFreqs = [2, 10];
percentile = 90;
windowTime = 2; % seconds
freqInterval = .10;

windowLength = windowTime*fs;
n_windows = round(length(data)/windowLength);
freqPerWindow = cell(size(n_windows));
for ii = 1:n_windows
    startPoint = (ii-1)*windowLength+1;
    endPoint = ii*windowLength;
    if ii == n_windows
        endPoint = length(data);
    end

    window = data(startPoint:endPoint);
    detectedFreq = pipeline_v2(window, targetFreqs, fs, filterFreqs, percentile, freqInterval);

%     fprintf("Window n: %d\n", ii)
%     if detectedFreqs
%         for freq = detectedFreqs
%             fprintf("You were looking at light blinking at %.1f Hz\n", freq)
%         end
%     else
%         disp("You were NOT looking at blinking light")
%     end

    freqPerWindow{ii} = detectedFreq;
end

successes = 0;
for detectedFreq = freqPerWindow
    if isequal(detectedFreq{1}, realFreq)
        successes = successes+1;
    end
end

accuracy = successes/n_windows;

fprintf("Detection accuracy with window of %d seconds, %d percentile and %.2f " + ...
    "Hz frequency detection interval is %.2f\n", windowTime, percentile, freqInterval, accuracy);
