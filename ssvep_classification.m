%% Create the dataset
clearvars
clc
close all

targetFreqs = [6 7.4];
windowTimes = [1 2 3 4 5];
freqRanges = [.05 .1 .2 .3 .4];

figure()
t = tiledlayout(5,5, TileSpacing="compact", Padding="compact");
for windowTime = windowTimes
    for freqRange = freqRanges
        nexttile
        [X1,Y1] = createDataset(6, windowTime, freqRange);
        [X2,Y2] = createDataset(7.4, windowTime, freqRange);
        bestThreshold6 = find_best_threshold(X1,Y1,1);
        bestThreshold7_4 = find_best_threshold(X2,Y2,1);

        X = cat(2,X1,X2); % input matrix: maximum values around targetFreqs
        Y = Y1+2*Y2; % labels: 1=6Hz, 2=7.4Hz, 0=no_freq
        y_pred = SSVEP_classifier(X, Y, bestThreshold6, bestThreshold7_4);
        
        % Compute confusion matrix
        C = confusionmat(Y, y_pred, "Order", [1 2 0]);
        cm = confusionchart(C,["6 Hz" "7.4 Hz" "null"]);
        cm.RowSummary = 'row-normalized';
        cm.ColumnSummary = 'column-normalized';
        cm.Normalization = 'total-normalized';
        cm.Title = sprintf("WindowTime = %ds, freqRange = %.2fHz", windowTime, freqRange);
    end
end
title(t, "Confusion matrices for SSVEP classification")

%% Create the decision tree classifier
function y_pred = SSVEP_classifier(X, Y, threshold6, threshold7_4)
    y_pred = zeros(size(Y));

    for ii = 1:length(X)
        x = X(ii,:);
        if x(1)>threshold6
            if x(2)>threshold7_4
                y_pred(ii) = find(x==max(x));
            else
                y_pred(ii) = 1;
            end
        else
            if x(2)>threshold7_4
                y_pred(ii) = 2;
            end
        end
    end
end
