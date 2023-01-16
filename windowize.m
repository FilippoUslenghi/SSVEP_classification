function [M,nWindows]=windowize(x,windowSize)
% [M,Nframes]=WINDOWIZE(Signal,WindowSize)
%
% Windowizes a signal, (last frame is cutted if not complete)
%

if size(x,2) ~= 1
    x = x';
end

xLength = size(x,1);
nWindows=floor(xLength / windowSize);
lines = (1:windowSize)';
cols = 0:windowSize:(nWindows - 1)*windowSize;
M = x(lines(:, ones(1,nWindows)) + cols(ones(windowSize,1), :));
