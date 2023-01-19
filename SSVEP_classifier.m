function y_pred = SSVEP_classifier(X, Y, threshold6, threshold7_4)
% Create the decision tree classifier based on both threshold values
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