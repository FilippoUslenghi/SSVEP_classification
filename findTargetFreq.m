function [targetPeak, targetLoc] = findTargetFreq(signal, targetFreq, fs, freqRange)
% Returns the maximum value of the DFT of the signal near targetFreq

N = length(signal);
signalDft = abs(fft(signal));
signalDft = signalDft(1:round(end/2));
fAxis = (0:N-1)/N*fs;
fAxis = fAxis(1:round(end/2));

targetPeak = max(signalDft(fAxis>targetFreq-freqRange & fAxis<targetFreq+freqRange));
targetLoc = fAxis(signalDft == targetPeak);

% figure()
% plot(fAxis, signalDft)
% hold on
% plot(targetLoc, targetPeak, 'x')

end
