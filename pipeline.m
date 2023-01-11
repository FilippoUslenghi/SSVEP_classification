function detectedFreqs = pipeline(signal, targetFreqs, fs, filterFreqs)
% The signal processing pipeline for the detection of evoked frequencies
% based on on SSVEP

% Filtering the signal
if filterFreqs
    signal = bandpass(signal, [filterFreqs(1), filterFreqs(2)], fs);
end

% Compute the periodogram
[PSD, freqs_PSD] = compute_PSD(signal, fs);

% Square it
exp_PSD = PSD.^2;

% Detect the SSVEP component
perc = 90; % percentile of the sorted peaks
[~, locs] = find_highest_peaks(exp_PSD, freqs_PSD, perc, 0);

detectedFreqs = [];
for ii = 1:length(targetFreqs)
    freq = targetFreqs(ii);
    detected = any(bitand(locs>freq-.25, locs<freq+.25));
    if detected
        detectedFreqs(ii) = freq;
    end
end

end
