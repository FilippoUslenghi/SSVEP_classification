function [targetPeak, targetLoc] = OLD_findTargetFreq(signal, targetFreq, fs, freqRange)
% Returns the value of the peak of the DFT of the signal near targetFreq

N = length(signal);
signalDft = abs(fft(signal));
signalDft = signalDft(1:round(end/2));
fAxis = (0:N-1)/N*fs;
fAxis = fAxis(1:round(end/2));

[~, locs] = findpeaks(signalDft, fAxis);
targetLocs = locs(locs>=targetFreq-freqRange & locs<=targetFreq+freqRange);

if isempty(targetLocs)
    targetLoc = fAxis(abs(fAxis-targetFreq) == min(abs(fAxis-targetFreq)));
    targetPeak = signalDft(fAxis==targetLoc);
    return
end

[~, idx] = ismember(targetLocs, fAxis);
targetPeak = signalDft(idx);

if length(targetPeak) > 1
    targetPeak = max(signalDft(idx));
end
targetLoc = fAxis(signalDft==targetPeak);

% figure()
% plot(fAxis, signalDft)
% hold on
% plot(targetLoc, targetPeak, 'x')

end
