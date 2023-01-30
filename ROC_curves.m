%% Computes and plots the ROC curve of each target frequency, considering
%  all the combination of window lengths and frequency ranges.
clearvars
clc
close all


fs = 1000;
targetFreqs = [6 7.4];
windowTimes = [1 2 3 4 5];
freqRanges = [.05 .1 .2 .3 .4];

% For every target frequency
for targetFreq = targetFreqs
    figure()
    t = tiledlayout(5,5, TileSpacing="compact", Padding="compact");
    % For every window length
    for windowTime = windowTimes
        % For every frequancy range
        for freqRange = freqRanges
            % Create the [X,Y] matrices from my dataset
            [X,Y] = createDataset(targetFreq, windowTime, freqRange, fs);

            % Compute the ROC curve
            [fpr,tpr,T,AUC] = perfcurve(Y,X,1);
            
            nexttile
            plot(fpr, tpr)
            title(sprintf("WindowTime = %ds, " + "freqRange = %.2fHz", ...
                windowTime, freqRange), sprintf("AUC = %.3f", AUC))
            xlabel('False positive rate')
            ylabel('True positive rate')
            
            % Plot the second diagonal and the point of intersection with
            % the ROC curve
            distances = abs(1-fpr-tpr);
            [~, idx] = min(distances);
            hold on
            plot([0 1], [1 0], 'k--')
            scatter(fpr(idx), tpr(idx), 'rd', 'filled')
        end
    end
    title(t, sprintf("ROC curves for %.1f Hz SSVEP detection.", targetFreq))
end
