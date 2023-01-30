function y_pred = SSVEP_classifier(X, threshold6, threshold7_4)
% Create the decision tree classifier based on the thresholds values
% labels: 1=6Hz, 2=7.4Hz, 0=no_freq
    y_pred = zeros(length(X),1);

    for ii = 1:length(X)
        x = X(ii,:);
        if x(1)>threshold6
            if x(2)>threshold7_4
                % Use the label of the maximum between the two
                % frequencies
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