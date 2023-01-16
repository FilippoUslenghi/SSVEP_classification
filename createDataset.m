% TODO set windowTime parameter for windowing the signals
function [X,Y] = createDataset(targetFreq, zeroPadding) %, windowTime)
    fs = 1000;
    dataDir = "data/";
    dataFiles = dir(dataDir);
    dataFiles(1:3) = []; % remove '.', '..' and '.DS_Store' files
    X = zeros(numel(dataFiles), 1);
    Y = zeros(size(X));
    for ii = 1:numel(dataFiles)
        fileName = dataFiles(ii).name;
        data = load_data(strcat(dataDir,fileName));
        
        if zeroPadding
            data = cat(1, data, zeros(50000, 1));
        end

        % Filtering the signal
        filteredData = bandpass(data, [4 10], fs);
        
        [coeff, ~] = findTargetFreq(filteredData, targetFreq, fs, .1);
        X(ii) = coeff;
        if fileName(1) == string(targetFreq)
            Y(ii) = 1;
        end
    end

end