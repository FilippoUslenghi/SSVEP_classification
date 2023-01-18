%% Create the dataset
clearvars
clc
close all

windowTime = 2;
freqRange = .1;

[X1,Y1] = createDataset(6, windowTime, freqRange);
bestThreshold6 = find_best_threshold(X1,Y1,1);

[X2,Y2] = createDataset(7.4, windowTime, freqRange);
bestThreshold7_4 = find_best_threshold(X2,Y2,1);

X = cat(2,X1,X2); % matrix of max value around 6 and 7.4 Hz
Y = Y1+2*Y2; % labels: 1=6Hz, 2=7.4Hz, 0=no_freq

y_pred = SSVEP_classifier(X, Y, bestThreshold6, bestThreshold7_4);
new_Y = changeLabels(Y);
new_y_pred = changeLabels(y_pred);

% Compute confusion matrix
C = confusionmat(new_Y, new_y_pred, "Order", ["6 Hz" "7.4 Hz" "null"]);
cm = confusionchart(C,["6 Hz" "7.4 Hz" "null"]);


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

function new_Y = changeLabels(Y)
    new_Y = strings(size(Y));
    
    for ii = 1:length(Y)
        y = Y(ii);

        if y == 0
            new_Y(ii) = 'null';
        elseif y == 1
            new_Y(ii) = '6 Hz';
        elseif y == 2
            new_Y(ii) = '7.4 Hz';
        end

    end
end