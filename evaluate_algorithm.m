clearvars;
clc
close all

fs = 1000;
targetFreqs = [6, 7.4]; %Hz
filterFreqs = [4, 40];
percentile = 90;
windowTime = 3; % seconds
freqInterval = .10;

sixHz_accuracy = [];
sevenHz_accuracy = [];
null_accuracy = [];

dataDir = "data/";
files = dir(dataDir);
for ii = 1:numel(files)
    fileName = files(ii).name;
    dataPath = strcat(dataDir, fileName);
    if fileName(1) == "6"
        realFreq = 6;
        data = load_data(dataPath);
        accuracy = main_script(data, realFreq, fs, targetFreqs, filterFreqs, percentile, windowTime, freqInterval);
        sixHz_accuracy(end+1) = accuracy;
    elseif fileName(1) == "7"
        realFreq = 7.4;
        data = load_data(dataPath);
        accuracy = main_script(data, realFreq, fs, targetFreqs, filterFreqs, percentile, windowTime, freqInterval);
        sevenHz_accuracy(end+1) = accuracy;
    elseif fileName(1) == "n"
        realFreq = 7.4;
        data = load_data(dataPath);
        accuracy = main_script(data, realFreq, fs, targetFreqs, filterFreqs, percentile, windowTime, freqInterval);
        accuracy = 1-accuracy;
        null_accuracy(end+1) = accuracy;
    end

end

fprintf("Accuracy on 6hz SSVEP: %.2f \n", mean(sixHz_accuracy))
fprintf("Accuracy on 7.4hz SSVEP: %.2f \n", mean(sevenHz_accuracy))
fprintf("Accuracy without SSVEP: %.2f \n", mean(null_accuracy))

%%
function accuracy = main_script(data, realFreq, fs, targetFreqs, filterFreqs, percentile, windowTime, freqInterval)
windowLength = windowTime*fs;
n_windows = round(length(data)/windowLength);
freqsPerWindow = cell(size(n_windows));
for ii = 1:n_windows
    startPoint = (ii-1)*windowLength+1;
    endPoint = ii*windowLength;
    if ii == n_windows
        endPoint = length(data);
    end

    window = data(startPoint:endPoint);
    detectedFreq = pipeline(window, targetFreqs, fs, filterFreqs, percentile, freqInterval);

    freqsPerWindow{ii} = detectedFreq;
end

successes = 0;
for detectedFreq = freqsPerWindow
    if isequal(detectedFreq{1}, realFreq)
        successes = successes+1;
    end
end

accuracy = round(successes/n_windows, 2);
end
