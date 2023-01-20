%% Train classifier on my dataset
clearvars
clc
close all

fs = 512;
windowTime = 5;
freqRange = .2;

[X1,Y1] = createDataset(6, windowTime, freqRange, fs);
[X2,Y2] = createDataset(7.4, windowTime, freqRange, fs);
bestThreshold6 = find_best_threshold(X1, Y1, 1);
bestThreshold7_4 = find_best_threshold(X2, Y2, 1);

X = cat(2, X1, X2); % input matrix: maximum values of fft around targetFreqs
Y = Y1 + (2*Y2); % labels: 1=6Hz, 2=7.4Hz, 0=no_freq
y_pred = SSVEP_classifier(X, Y, bestThreshold6, bestThreshold7_4);

% Compute confusion matrix
figure()
subplot(2, 1, 1)
C = confusionmat(Y, y_pred, "Order", [1 2 0]);
cm = confusionchart(C,["6 Hz" "7.4 Hz" "null"]);
cm.RowSummary = 'row-normalized';
cm.Title = sprintf("WindowTime = %ds, freqRange = %.2fHz", windowTime, freqRange);
title("My dataset")

%% Create [X_test,Y_test] from AVI dataset and test the classifier
[X1_test,Y1_test] = createAVIDataset(6, windowTime, freqRange, fs);
[X2_test,Y2_test] = createAVIDataset(7.5, windowTime, freqRange, fs);

X_test = cat(2, X1_test, X2_test); % input matrix: maximum values of fft around targetFreqs
Y_test = Y1_test + (2*Y2_test); % labels: 1=6Hz, 2=7.4Hz
y_test_pred = SSVEP_classifier(X_test, Y_test, bestThreshold6, bestThreshold7_4);

% Compute confusion matrix
subplot(2, 1, 2)
C = confusionmat(Y_test, y_test_pred, "Order", [1 2]);
cm = confusionchart(C,["6 Hz" "7.5 Hz"]);
cm.RowSummary = 'row-normalized';
cm.Title = sprintf("WindowTime = %ds, freqRange = %.2fHz", windowTime, freqRange);
title("AVI dataset")

sgtitle(sprintf("SSVEP classification (windowTime = %ds, freqRange = %.2fHz)", windowTime, freqRange)) 

%%
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
    
                % Populate Y
                if (targetFreq == label)
                     Y(idx) = 1;
                end
    
                idx = idx + 1;
            end
        end
    end
end