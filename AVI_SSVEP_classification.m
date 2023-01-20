%% Train classifier on my dataset
clearvars
clc
close all

fs = 512;
windowTime = 5;
freqRange = .1;

[X1,Y1] = createDataset(6, windowTime, freqRange, fs);
[X2,Y2] = createDataset(7.4, windowTime, freqRange, fs);
bestThreshold6 = find_best_threshold(X1, Y1, 1);
bestThreshold7_4 = find_best_threshold(X2, Y2, 1);

X = cat(2, X1, X2); % input matrix: maximum values of fft around targetFreqs
Y = Y1 + (2*Y2); % labels: 1=6Hz, 2=7.4Hz, 0=no_freq
y_pred = SSVEP_classifier(X, bestThreshold6, bestThreshold7_4);

% Compute confusion matrix
figure()
C = confusionmat(Y, y_pred, "Order", [1 2 0]);
cm = confusionchart(C,["6 Hz" "7.4 Hz" "null"]);
cm.RowSummary = 'row-normalized';
cm.Title = sprintf("WindowTime = %ds, freqRange = %.2fHz", windowTime, freqRange);
title("My dataset")

%% Create [X_test,Y_test] from AVI dataset and test the classifier

fs = 512;
windowTimes = [1 2 3 4 5];
freqRanges = [.05 .1 .2 .3 .4];

figure()
t = tiledlayout(5, 5, TileSpacing="compact", Padding="compact");
for windowTime = windowTimes
    for freqRange = freqRanges
        nexttile
        [X1_test,Y1_test] = createAVIDataset(6, windowTime, freqRange, fs);
        [X2_test,Y2_test] = createAVIDataset(7.5, windowTime, freqRange, fs);
        
        X_test = cat(2, X1_test, X2_test); % input matrix: maximum values of fft around targetFreqs
        Y_test = Y1_test + (2*Y2_test); % labels: 1=6Hz, 2=7.4Hz
        y_test_pred = SSVEP_classifier(X_test, bestThreshold6, bestThreshold7_4);
        
        % Compute confusion matrix
        C = confusionmat(Y_test, y_test_pred, "Order", [1 2 0]);
        cm = confusionchart(C,["6 Hz" "7.5 Hz" "null"]);
        cm.RowSummary = 'row-normalized';
        cm.Title = sprintf("WindowTime = %ds, freqRange = %.2fHz", windowTime, freqRange);
%         sgtitle(sprintf("SSVEP classification (windowTime = %ds, freqRange = %.2fHz)", windowTime, freqRange))
    end
end
title(t, "SSVEP classification on AVI dataset")
