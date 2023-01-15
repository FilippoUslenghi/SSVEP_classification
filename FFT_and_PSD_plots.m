%% 6Hz SSVEP
clearvars;
clc;
close all

figure()
ax = zeros(1, 10);
for ii = 1:5
    % Loading the data
    dataDir = sprintf("data/6hz_0%d.h5", ii);
    data = h5read(dataDir, "/20:15:12:22:81:60/raw/channel_4");
    data = cast(data, "double")';
    
    fs = 1000;
    T = 1/fs;
    N = length(data);
    t_axis = (0:N-1)/fs;
    f_axis = (0:N-1)/N*fs;
    
    % Filtering the signal
    filtered_data = bandpass(data, [4, 10], fs);
    
    % Plotting fft
    S_dft = fft(filtered_data);
    ax(2*ii-1) = subplot(5, 2, 2*ii-1);
    plot(f_axis(1:end/2), abs(S_dft(1:end/2)))
    title(sprintf("FFT of signal 6hz\\_0%d", ii))
    
    % Plotting periodogram
    S_periodogram=T*abs(fft(filtered_data-mean(filtered_data))).^2/N;
    S_periodogram(1)=nan;
    ax(2*ii) = subplot(5, 2, 2*ii);
    plot(f_axis(1:end/2), S_periodogram(1:end/2))
    title(sprintf("PSD of signal 6hz\\_0%d", ii))
end
linkaxes(ax, 'x');

%% 7.4Hz SSVEP

figure()
ax = zeros(1, 10);
for ii = 1:5
    % Loading the data
    dataDir = sprintf("data/7.4hz_0%d.h5", ii);
    data = h5read(dataDir, "/20:15:12:22:81:60/raw/channel_4");
    data = cast(data, "double")';
    
    fs = 1000;
    T = 1/fs;
    N = length(data);
    t_axis = (0:N-1)/fs;
    f_axis = (0:N-1)/N*fs;
    
    % Filtering the signal
    filtered_data = bandpass(data, [4, 10], fs);
    
    % Plotting fft
    S_dft = fft(filtered_data);
    ax(2*ii-1) = subplot(5, 2, 2*ii-1);
    plot(f_axis(1:end/2), abs(S_dft(1:end/2)))
    title(sprintf("FFT of signal 7.4hz\\_0%d", ii))
    
    % Plotting periodogram
    S_periodogram=T*abs(fft(filtered_data-mean(filtered_data))).^2/N;
    S_periodogram(1)=nan;
    ax(2*ii) = subplot(5, 2, 2*ii);
    plot(f_axis(1:end/2), S_periodogram(1:end/2))
    title(sprintf("PSD of signal 7.4hz\\_0%d", ii))
end
linkaxes(ax, 'x');

%% No SSVEP

figure()
ax = zeros(1, 10);
for ii = 1:5
    % Loading the data
    dataDir = sprintf("data/null_0%d.h5", ii);
    data = h5read(dataDir, "/20:15:12:22:81:60/raw/channel_4");
    data = cast(data, "double")';
    
    fs = 1000;
    T = 1/fs;
    N = length(data);
    t_axis = (0:N-1)/fs;
    f_axis = (0:N-1)/N*fs;
    
    % Filtering the signal
    filtered_data = bandpass(data, [4, 10], fs);
    
    % Plotting fft
    S_dft = fft(filtered_data);
    ax(2*ii-1) = subplot(5, 2, 2*ii-1);
    plot(f_axis(1:end/2), abs(S_dft(1:end/2)))
    title(sprintf("FFT of signal null\\_0%d", ii))
    
    % Plotting periodogram
    S_periodogram=T*abs(fft(filtered_data-mean(filtered_data))).^2/N;
    S_periodogram(1)=nan;
    ax(2*ii) = subplot(5, 2, 2*ii);
    plot(f_axis(1:end/2), S_periodogram(1:end/2))
    title(sprintf("PSD of signal null\\_0%d", ii))
end
linkaxes(ax, 'x');
