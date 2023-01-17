%% Computes and plots the ROC curve for both target frequency, considering
%  different values for the parameters
clearvars
clc
close all


fs = 1000;
targetFreqs = [6 7.4];
windowTimes = [1 2 3 4 5];
freqRanges = [.05 .1 .2 .3 .4];
zeroPadding = 1;


bestThresholds_6 = [];
bestThresholds_7 = [];
for targetFreq = targetFreqs
    figure()
    t = tiledlayout(5,5, TileSpacing="compact", Padding="compact");
    for windowTime = windowTimes
        for freqRange = freqRanges
            [X,Y] = createDataset(targetFreq, windowTime, freqRange, zeroPadding);
            [fpr,tpr,T,AUC] = perfcurve(Y,X,1);
            
            nexttile
            plot(fpr, tpr)
            title(sprintf("WindowTime = %ds, " + "freqRange = %.2f", ...
                windowTime, freqRange), sprintf("AUC = %.3f", AUC))
            xlabel('False positive rate')
            ylabel('True positive rate')

            ROCpoints = cat(2,fpr,tpr);
            
            distanceToAngleCooridnates = ROCpoints - [0 1];
            distanceToAngle = sqrt(sum(distanceToAngleCooridnates.^2, 2));
            idxMinDistanceToAngle = find(min(distanceToAngle)==distanceToAngle);
            bestThreshold = T(idxMinDistanceToAngle);

            if targetFreq == 6
                bestThresholds_6(end+1, 1) = bestThreshold;
            elseif targetFreq == 7.4
                bestThresholds_7(end+1, 1) = bestThreshold;
            end
            
            hold on
            plot(fpr(idxMinDistanceToAngle), tpr(idxMinDistanceToAngle), 'x')
        end
    end
    title(t, sprintf("ROC curves for %.1f Hz SSVEP detection.", targetFreq))
end