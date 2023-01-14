function [topPks,locsTopPks] = find_highest_peaks_v2(Y, X, perc, plots)
% Find the "perc"-th percentile of the sorted peaks

    [pks, locs] = findpeaks(Y, X, "SortStr", "descend");
    pksSum = sum(pks);
    topPks = zeros(size(pks));
    for ii = 1:pks
        if sum(topPks)/pksSum > perc/100
            break
        end
        topPks(ii) = pks(ii);
    end
    topPks = nonzeros(topPks)';
    [~,idxTopPks] = ismember(topPks, pks);
    locsTopPks = locs(idxTopPks);
    
    if plots
        P_idx = find(diff(pks>P));
        figure()
        plot(pks)
        hold on
        plot(P_idx, pks(P_idx), '-x', 'Color', 'r')
    end
end