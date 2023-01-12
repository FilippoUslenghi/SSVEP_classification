function targetFreqDetected = pipeline(signal, targetFreqs, fs, filterFreqs, percentile, freqInterval)
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
[pks, locs] = find_highest_peaks(exp_PSD, freqs_PSD, percentile, 0);

detectedFreqs =[];
for targetFreq = targetFreqs
    detectedFreqs = cat(2, detectedFreqs, locs(locs>targetFreq-freqInterval ...
        & locs<targetFreq+freqInterval));
end

if detectedFreqs 
    [~, indexDetectedFreqs] = ismember(detectedFreqs, locs); 
    detectedFreqsPower = pks(indexDetectedFreqs);
    maxDetectedFreqPower = locs(pks==max(detectedFreqsPower));
    
    [~,idx] = min(abs(targetFreqs-maxDetectedFreqPower));
    targetFreqDetected = targetFreqs(idx);
else
    targetFreqDetected = nan;
end

end
