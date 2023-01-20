function [X,Y] = createAVIDataset(targetFreq, windowTime, freqRange, fs)
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

%                 if idx == 42
%                     fAxis = (0:length(window)-1)/length(window)*fs;
%                     plot(fAxis,abs(fft(window)))
%                 end
    
                % Populate Y
                if (targetFreq == label)
                     Y(idx) = 1;
                end
    
                idx = idx + 1;
            end
        end
    end
end