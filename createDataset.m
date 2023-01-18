function [X,Y,filenames] = createDataset(targetFreq, windowTime, freqRange)
    fs = 1000;
    windowSize = windowTime * fs;
    dataDir = "data/";
    dataFiles = dir(dataDir);
    
    % Remove unwanted files
    dataFiles = dataFiles(contains({dataFiles.name}, '.h5'));

    % Pre-allocate space
    totWindows = 0;
    for ii = 1:numel(dataFiles)
        fileName = dataFiles(ii).name;

        data = load_data(strcat(dataDir,fileName));
        totWindows = totWindows + floor(length(data)/windowSize);
    end
    X = zeros(totWindows, 1);
    Y = zeros(totWindows, 1);
    filenames = strings(totWindows, 1);


    % Populate dataset
    idx = 1;
    for ii = 1:numel(dataFiles)
        fileName = dataFiles(ii).name;

        data = load_data(strcat(dataDir,fileName));  
        [M, nWindows] = windowize(data, windowSize);

        for jj = 1:nWindows
            window = M(:, jj);

            % Add zero padding
            window = cat(1, window, zeros(50000, 1));
            
            % Filter the signal
%             window = bandpass(window, [4 10], fs);

            % Populate X
            [coeff, ~] = findTargetFreq(window, targetFreq, fs, freqRange);
            X(idx) = coeff;

            % Populate Y
            if (fileName(1) == '6' && targetFreq == 6 || fileName(1) == '7' ...
                    && targetFreq == 7.4)
                 Y(idx) = 1;
            end

%             if nClasses == 2
%                 if (fileName(1) == '6' && targetFreq == 6 || ...
%                         fileName(1) == '7' && targetFreq == 7.4)
%                     Y(idx) = 1;
%                 end
%             end
% 
%             if nClasses == 3
%                 if (fileName(1) == '6' && targetFreq == 6)
%                     Y(idx) = 1;
%                 elseif (fileName(1) == '7' && targetFreq == 7.4)
%                     Y(idx) = 2;
%                 end
%             end
            
            filenames(idx) = fileName;
            idx = idx + 1;
        end
    end
end