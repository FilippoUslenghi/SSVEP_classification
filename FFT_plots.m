%% This script shows the FFT of each recording, grouped by the visual stimuli

% 6Hz SSVEP

clearvars;
clc;
close all

figure()
ax = zeros(1, 5);
for ii = 1:5
    % Loading the data
    dataDir = "data/my_data/";
    filename =  sprintf("6hz_0%d.h5", ii);
    data = h5read(strcat(dataDir,filename), "/20:15:12:22:81:60/raw/channel_4");
    data = cast(data, "double")';
    
    fs = 1000;
    T = 1/fs;
    N = length(data);
    t_axis = (0:N-1)/fs;
    f_axis = (0:N-1)/N*fs;

    % Plotting fft
    S_dft = fft(data);
    ax(ii) = subplot(5, 1, ii);
    plot(f_axis(1:end/2), abs(S_dft(1:end/2)))
    title(sprintf("FFT of signal 6hz\\_0%d", ii))

end
linkaxes(ax, 'x');
xlim([3 11])

%% 7.4Hz SSVEP

figure()
ax = zeros(1, 5);
for ii = 1:5
    % Loading the data
    dataDir = "data/my_data/";
    filename =  sprintf("7.4hz_0%d.h5", ii);
    data = h5read(strcat(dataDir,filename), "/20:15:12:22:81:60/raw/channel_4");
    data = cast(data, "double")';
    
    fs = 1000;
    T = 1/fs;
    N = length(data);
    t_axis = (0:N-1)/fs;
    f_axis = (0:N-1)/N*fs;
    
    % Plotting fft
    S_dft = fft(data);
    ax(ii) = subplot(5, 1, ii);
    plot(f_axis(1:end/2), abs(S_dft(1:end/2)))
    title(sprintf("FFT of signal 7.4hz\\_0%d", ii))
end
linkaxes(ax, 'x');
xlim([3 11])

%% No SSVEP

figure()
ax = zeros(1, 5);
for ii = 1:5
    % Loading the data
    dataDir = "data/my_data/";
    filename =  sprintf("null_0%d.h5", ii);
    data = h5read(strcat(dataDir,filename), "/20:15:12:22:81:60/raw/channel_4");
    data = cast(data, "double")';
    
    fs = 1000;
    T = 1/fs;
    N = length(data);
    t_axis = (0:N-1)/fs;
    f_axis = (0:N-1)/N*fs;
    
    % Plotting fft
    S_dft = fft(data);
    ax(ii) = subplot(5, 1, ii);
    plot(f_axis(1:end/2), abs(S_dft(1:end/2)))
    title(sprintf("FFT of signal null\\_0%d", ii))
end
linkaxes(ax, 'x');
xlim([3 11])
