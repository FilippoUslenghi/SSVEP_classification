function [X,Y] = createDataset(targetFreq, windowTime, freqRange, fs)
% Creates arrays X and Y.
% X contains the maximum value around 'targetFreq' of the FFT of the 
% windowed signals present in my dataset.
% The parameter 'freqRange' specifies the range of values of
% the FFT to consider while searching for the maximum, i.e.
% (targetFreq-freRange, targetFreq+freRange).
%
% Y is a binary array of labels with the same length of X.
% At a given index 'i', it contains 1 if the value X[i] is extracted from a
% signal where I was looking at a visual stimuli of frequency 'targetFreq',
% 0 otherwise.

    windowSize = windowTime * fs;
    dataDir = "data/my_data/";
    dataFiles = dir(dataDir);
    
    % Remove unwanted files
    dataFiles = dataFiles(contains({dataFiles.name}, '.h5'));

    % Pre-allocate space
    totWindows = 0;
    for ii = 1:numel(dataFiles)
        % Load the data file
        fileName = dataFiles(ii).name;
        data = load_data(strcat(dataDir,fileName));

         % Resample if necessary
        if fs ~= 1000
            data = resample(data, fs, 1000);
        end

        totWindows = totWindows + floor(length(data)/windowSize);
    end
    X = zeros(totWindows, 1);
    Y = zeros(totWindows, 1);


    % Populate dataset
    idx = 1;
    for ii = 1:numel(dataFiles)
        % Load the data file
        fileName = dataFiles(ii).name;
        data = load_data(strcat(dataDir,fileName));

        % Normalize the data
        data = data./max(data);

        % Resample if necessary
        if fs ~= 1000
            data = resample(data, fs, 1000);
        end
        
        % Window the signal
        [M, nWindows] = windowize(data, windowSize);

        for jj = 1:nWindows
            window = M(:, jj);

            % Add zero padding
            window = cat(1, window, zeros(50*fs, 1));

            % Populate X
            [coeff, ~] = findTargetFreq(window, targetFreq, fs, freqRange);
            X(idx) = coeff;

            % Populate Y
            if (fileName(1) == '6' && targetFreq == 6 || fileName(1) == '7' ...
                    && targetFreq == 7.4)
                 Y(idx) = 1;
            end
            
            % Increase the index
            idx = idx + 1;
        end
    end
end