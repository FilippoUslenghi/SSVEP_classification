function [pks_perc,locs_perc] = find_highest_peaks(Y, X, perc, plots)
% Find the "perc"-th percentile of the sorted peaks

    [pks, locs] = findpeaks(Y, X, "SortStr", "descend");
    P = prctile(pks, perc);
    pks_perc = pks(pks>P);
    locs_perc = locs(pks>P);
    
    if plots
        P_idx = find(diff(pks>P));
        figure()
        plot(pks)
        hold on
        plot(P_idx, pks(P_idx), '-x', 'Color', 'r')
    end
end