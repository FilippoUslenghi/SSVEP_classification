function threshold = find_best_threshold(X, Y, posClass)
% Returns the threshold with the ROC point nearest to (0,1)

    [fpr,tpr,T] = perfcurve(Y,X,posClass);            
    ROCpoints = cat(2,fpr,tpr);
    distanceToAngle = sqrt(sum((ROCpoints - [0 1]).^2, 2));
    threshold = T(min(distanceToAngle)==distanceToAngle);
end