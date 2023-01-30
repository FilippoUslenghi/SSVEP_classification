function threshold = find_best_threshold(X, Y, posClass)
% Returns the threshold of the ROC point the intercept the second diagonal

    [fpr,tpr,T] = perfcurve(Y,X,posClass);            
    distances = abs(1-fpr-tpr);
    [~, idx] = min(distances);
    threshold = T(idx);
end