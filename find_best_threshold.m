function threshold = find_best_threshold(X, Y, posClass)
% Returns the threshold with the ROC point nearest to (0,1)

    [fpr,tpr,T] = perfcurve(Y,X,posClass);            
    distances = abs(1-fpr-tpr);
    [~, idx] = min(distances);
    threshold = T(idx);
end