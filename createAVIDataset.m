function [X,Y] = createAVIDataset(targetFreq, windowTime, freqRange, fs)
    dataDir = "data/AVI_SSVEP_Dataset_MAT/single/";
    dataFiles = dir(dataDir);
    
    % Remove unwanted files
    dataFiles = dataFiles(contains({dataFiles.name}, '.mat'));
    
    if targetFreq == 7.4
        targetFreq = 7.5;
    end

    % Pre-allocate space
    windowSize = windowTime * fs;
    totWindows = 0;
    for ii = 1:numel(dataFiles)
        fileName = dataFiles(ii).name;
        load(strcat(dataDir,fileName), "Data");
        data = Data.EEG(:, targetFreq==Data.TargetFrequency);

        % For every signal of interest stored in the .mat file
        for jj = 1:size(data,2)
            signal = data(:,jj);
   
             % Resample if necessary
            if fs ~= 512
                data = resample(data, fs, 512);
            end

            totWindows = totWindows + floor(length(signal)/windowSize);
        end
        break
    end
    X = zeros(totWindows, 1);
    Y = zeros(totWindows, 1);


    % Populate dataset
    idx = 1;
    for ii = 1:numel(dataFiles)
        fileName = dataFiles(ii).name;
        load(strcat(dataDir,fileName), "Data");
        data = Data.EEG(:, Data.TargetFrequency==targetFreq);
        
        % For every signal of interest stored in the .mat file
        for jj = 1:size(data,2)
            signal = data(:,jj);

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
                if (targetFreq == 6 || targetFreq == 7.5)
                     Y(idx) = 1;
                end
    
                idx = idx + 1;
            end
            
        end
        break
    end
end