clearvars;
clc
close all

data = load_data("data/6hz_03.h5");

fs = 1000;
targetFreqs = 6; %Hz
filterFreqs = [2, 40];

detectedFreqs = pipeline(data, targetFreqs, fs, filterFreqs);

if detectedFreqs
    for freq = detectedFreqs
        fprintf("You were looking at light blinking at %.1f Hz\n", freq)
    end
else
    disp("You were NOT looking at blinking light")
end