function [X,Y] = createAVIDataset(targetFreq, windowTime, freqRange, fs)
% Creates arrays X and Y.
% X contains the maximum value around 'targetFreq' of the FFT of the 
% windowed signals present in the AVI dataset.
% The parameter 'freqRange' specifies the range of values of
% the FFT to consider while searching for the maximum, i.e.
% (targetFreq-freRange, targetFreq+freRange).
%
% Y is a binary array of labels with the same length of X.
% At a given index 'i', it contains 1 if the value X[i] is extracted from a
% signal where the subject was looking at a visual stimuli of frequency 'targetFreq',
% 0 otherwise.

    dataDir = "data/AVI_SSVEP_Dataset_MAT/single/";
    dataFiles = dir(dataDir);
    
    freqsOfInterest = [6 7.5];

    % Remove unwanted files
    dataFiles = dataFiles(contains({dataFiles.name}, '.mat'));

    % Pre-allocate space
    windowSize = windowTime * fs;
    totWindows = 0;
    for ii = 1:numel(dataFiles)
        fileName = dataFiles(ii).name;
        load(strcat(dataDir,fileName), "Data");
        data = Data.EEG(:, ismember(Data.TargetFrequency, freqsOfInterest));

        % For every signal of interest stored in the .mat file
        for jj = 1:size(data,2)
            signal = data(:,jj);
   
             % Resample if necessary
            if fs ~= 512
                data = resample(data, fs, 512);
            end

            totWindows = totWindows + floor(length(signal)/windowSize);
        end
    end
    X = zeros(totWindows, 1);
    Y = zeros(totWindows, 1);


    % Populate dataset
    idx = 1;
    for ii = 1:numel(dataFiles)
        fileName = dataFiles(ii).name;
        load(strcat(dataDir,fileName), "Data");
        data = Data.EEG(:, ismember(Data.TargetFrequency, freqsOfInterest));
        labels = Data.TargetFrequency(ismember(Data.TargetFrequency, freqsOfInterest));

        % Normalize the data
        data = data./max(data);
        
        % For every signal of interest stored in the .mat file
        for jj = 1:size(data,2)
            signal = data(:,jj);
            label = labels(jj);

            % Resample if necessary
            if fs ~= 512
                signal = resample(signal, fs, 512);
            end
            
            [M, nWindows] = windowize(signal, windowSize);
    
            for kk = 1:nWindows
                window = M(:, kk);
    
                % Add zero padding
                window = cat(1, window, zeros(50*fs, 1));
    
                % Populate X
                [coeff, ~] = findTargetFreq(window, targetFreq, fs, freqRange);
                X(idx) = coeff;
    
                % Populate Y
                if (targetFreq == label)
                     Y(idx) = 1;
                end
    
                idx = idx + 1;
            end
        end
    end
end