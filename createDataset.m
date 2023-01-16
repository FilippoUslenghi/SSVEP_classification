% TODO set windowTime parameter for windowing the signals
function [X,Y] = createDataset(targetFreq, zeroPadding, windowTime)
    fs = 1000;
    windowSize = windowTime * fs;
    dataDir = "data/";
    dataFiles = dir(dataDir);


    % Pre-allocate space
    totWindows = 0;
    for ii = 1:numel(dataFiles)
        fileName = dataFiles(ii).name;

        % Skip unwanted files
        if fileName(1) == '.'
            continue
        end

        data = load_data(strcat(dataDir,fileName));
        totWindows = totWindows + floor(length(data)/windowSize)+1;
    end
    X = zeros(totWindows, 1);
    Y = zeros(size(X, 1), 1);
    

    % Populate dataset
    for ii = 1:numel(dataFiles)
        fileName = dataFiles(ii).name;

         % Skip unwanted files
        if fileName(1) == '.'
            continue
        end

        data = load_data(strcat(dataDir,fileName));  
        [M, nWindows] = windowize(data, windowSize);

        for jj = 1:nWindows
            window = M(:, jj);

            % add zero padding if requested
            if zeroPadding
                window = cat(1, window, zeros(50000, 1));
            end

            % Filter the signal
%             filteredWindow = bandpass(window, [4 10], fs);
            
            idx = (ii-1)*nWindows+jj;
            % Populate X
            [coeff, ~] = findTargetFreq(window, targetFreq, fs, .1);
            X(idx) = coeff;

            % Populate Y
            Y(idx) = fileName(1) == string(targetFreq);
        end
    end
end