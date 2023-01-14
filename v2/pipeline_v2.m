function targetFreqDetected = pipeline_v2(signal, targetFreqs, fs, filterFreqs, ...
    percentile, freqInterval)
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
[topPks, locsTopPks] = find_highest_peaks_v2(exp_PSD, freqs_PSD, percentile, 0);

detectedFreqs =[];
for ii = 1:length(targetFreqs)
    targetFreq = targetFreqs(ii);
    detectedFreqs = cat(2, detectedFreqs, locsTopPks(locsTopPks>targetFreq-freqInterval ...
        & locsTopPks<targetFreq+freqInterval));
end

if detectedFreqs 
    [~, indexDetectedFreqs] = ismember(detectedFreqs, locsTopPks); 
    detectedFreqsPower = topPks(indexDetectedFreqs);
    maxDetectedFreq = locsTopPks(topPks==max(detectedFreqsPower));
    
    [~,idx] = min(abs(targetFreqs-maxDetectedFreq));
    targetFreqDetected = targetFreqs(idx);
else
    targetFreqDetected = nan;
end

end
