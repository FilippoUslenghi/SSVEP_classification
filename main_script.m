clearvars;
clc
close all

data = load_data("data/6hz_03.h5");
fs = 1000;
targetFreqs = [6, 7.4]; %Hz
filterFreqs = [2, 40];
percentile = 90;
windowTime = 2; % seconds

windowLength = windowTime*fs;
n_window = round(length(data)/windowLength);
for ii = 1:n_window
    startPoint = (ii-1)*windowLength+1;
    endPoint = ii*windowLength;
    if ii == n_window
        endPoint = length(data);
    end

    window = data(startPoint:endPoint);
    detectedFreqs = pipeline(window, targetFreqs, fs, filterFreqs, percentile);

    fprintf("Window n: %d\n", ii)
    if detectedFreqs
        for freq = detectedFreqs
            fprintf("You were looking at light blinking at %.1f Hz\n", freq)
        end
    else
        disp("You were NOT looking at blinking light")
    end

end