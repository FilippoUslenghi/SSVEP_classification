function detectedFreqs = pipeline(signal, targetFreqs, fs, filterFreqs, percentile, freqInterval)
% The signal processing pipeline for the detection of evoked frequencies
% based on on SSVEP

% Filtering the signal
if filterFreqs
    signal = bandpass(signal, filterFreqs, fs);
end

% Compute the periodogram
[PSD, freqs_PSD] = compute_PSD(signal, fs);

% Square it
exp_PSD = PSD.^2;

% Detect the SSVEP component
[~, locs] = find_highest_peaks(exp_PSD, freqs_PSD, percentile, 0);

detectedFreqs = [];
for freq = targetFreqs
    detected = any(bitand(locs>freq-freqInterval, locs<freq+freqInterval));
    if detected
        detectedFreqs(end+1) = freq;
    end
end

end
