%% Classification of SSVEP signals using decision tree

clearvars
clc
close all

fs = 1000;
windowTimes = [1 2 3 4 5];
freqRanges = [.05 .1 .2 .3 .4];

figure()
t = tiledlayout(5,5, TileSpacing="compact", Padding="compact");
for windowTime = windowTimes
    for freqRange = freqRanges
        nexttile
        [X1,Y1] = createDataset(6, windowTime, freqRange, fs);
        [X2,Y2] = createDataset(7.4, windowTime, freqRange, fs);
        bestThreshold6 = find_best_threshold(X1,Y1,1);
        bestThreshold7_4 = find_best_threshold(X2,Y2,1);

        X = cat(2,X1,X2); % input matrix: maximum values of fft around targetFreqs
        Y = Y1 + (2*Y2); % labels: 1=6Hz, 2=7.4Hz, 0=no_freq
        y_pred = SSVEP_classifier(X, bestThreshold6, bestThreshold7_4);
        
        % Compute confusion matrix
        C = confusionmat(Y, y_pred, "Order", [1 2 0]);
        cm = confusionchart(C,["6 Hz" "7.4 Hz" "null"]);
        cm.RowSummary = 'row-normalized';
        cm.Title = sprintf("WindowTime = %ds, freqRange = %.2fHz", windowTime, freqRange);
    end
end
title(t, "SSVEP classification on my dataset")
