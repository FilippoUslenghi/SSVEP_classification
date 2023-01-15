clearvars;
clc
close all


windowTimes = [1, 2, 3, 4, 5];
percentiles = [75, 80, 85, 90, 95, 99];
freqIntervals = [.1, .2, .3, .4, .5];

txt = '';
for windowTime = windowTimes
    for percentile = percentiles
        for freqInterval = freqIntervals
            [sixHz_accuracy, sevenHz_accuracy, null_accuracy] = run_algorithm(windowTime, percentile, freqInterval);

            result.windowTime = windowTime;
            result.percentile = percentile;
            result.freqInterval = freqInterval;
            result.sixHz_accuracy = sixHz_accuracy;
            result.sevenHz_accuracy = sevenHz_accuracy;
            result.null_accuracy = null_accuracy;

            txt = strcat(txt, jsonencode(result, PrettyPrint=true), ',');
        end
    end
end

fid = fopen('results.json','a');
fprintf(fid,'[%s]', txt);
fclose(fid);

%%
function [sixHz_accuracy, sevenHz_accuracy, null_accuracy] = run_algorithm(windowTime, percentile, freqInterval)
    fs = 1000;
    targetFreqs = [6, 7.4]; %Hz
    filterFreqs = [4, 40];
    
    sixHz_accuracy = [];
    sevenHz_accuracy = [];
    null_accuracy = [];
    
    dataDir = "../data/";
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
            accuracy = round(1-accuracy,2);
            null_accuracy(end+1) = accuracy;
        end
    end

end


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
