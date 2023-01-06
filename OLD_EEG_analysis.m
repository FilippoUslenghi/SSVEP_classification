clearvars;
clc;
close all;

data = h5read("EEG_2022-12-21_15-57-04.h5", "/20:15:12:22:81:60/raw/channel_4");

fs = 1000;
N = length(data);
t_axis = (0:N-1)/fs;
f_axis = (0:N-1)/N*fs;

figure()
plot(t_axis, data)

window = data(8491:34885);
t_axis_windowed = t_axis(8491:34885);
f_axis_windowed = (0:length(window)-1)/length(window)*fs;
window = cast(window, "double");
% window = bandstop(window, [45, 55], fs);
window = window/max(window);

figure()
plot(t_axis_windowed, window)

figure()
semilogy(f_axis_windowed, abs(fft(window)))

%%
clearvars;
clc;
close all

data = h5read("EEG_2022-12-21_16-35-50.h5", "/20:15:12:22:81:60/raw/channel_4");
plot(data)
data = data(5398:42340);

N = length(data);
fs = 1000;
f_axis = (0:N-1)/N*fs;
t_axis = (0:N-1)/fs;


data = cast(data, "double");
% data = data/max(data);
% data = lowpass(data, 2, fs);


figure()
plot(t_axis, data)

figure()
plot(f_axis, abs(fft(data)))


%%
clearvars;
clc;
close all

data = h5read("EEG_2022-12-21_16-57-54.h5", "/20:15:12:22:81:60/raw/channel_4");
events = h5read("EEG_2022-12-21_16-57-54.h5", "/20:15:12:22:81:60/digital/digital_1");
% data = data(5398:42340);

N = length(data);
fs = 1000;
f_axis = (0:N-1)/N*fs;
t_axis = (0:N-1)/fs;


data = cast(data, "double");
% data = data/max(data);
% data = lowpass(data, 2, fs);


figure()
plot(t_axis, data)
hold on
plot(t_axis(1:end-1), diff(events))

figure()
plot(f_axis, abs(fft(data)))

%%
clearvars;
clc;
close all

data = h5read("EEG_2022-12-21_19-00-57.h5", "/20:15:12:22:81:60/raw/channel_4");
figure()
plot(data)
data = data(18643:27262);

N = length(data);
fs = 1000;
f_axis = (0:N-1)/N*fs;
t_axis = (0:N-1)/fs;


data = cast(data, "double");
% data = data/max(data);
data = bandstop(data, [45, 55], fs);


figure()
plot(t_axis, data)

figure()
plot(f_axis, abs(fft(data)))


%%
clearvars;
clc;
close all

data = h5read("EEG_2022-12-21_19-11-00.h5", "/20:15:12:22:81:60/raw/channel_4");
figure()
plot(data)
% data = data(18643:27262);

N = length(data);
fs = 1000;
f_axis = (0:N-1)/N*fs;
t_axis = (0:N-1)/fs;


data = cast(data, "double");
% data = data/max(data);
data = bandstop(data, [45, 55], fs);


figure()
plot(t_axis, data)

figure()
plot(f_axis, abs(fft(data-mean(data))))

%%
clearvars;
clc;
close all

data = h5read("EEG_2022-12-21_19-34-04.h5", "/20:15:12:22:81:60/raw/channel_4");
figure()
plot(data)
% data = data(18643:27262);
data=data(40000:end);

N = length(data);
fs = 1000;
f_axis = (0:N-1)/N*fs;
t_axis = (0:N-1)/fs;


data = cast(data, "double");
% data = data/max(data);
[b, a] = butter(3, 2*[0.5, 40]/fs);
data = filtfilt(b, a, data);
data = bandstop(data, [45, 55], fs);


figure()
plot(data)

figure()
plot(f_axis, abs(fft(data-mean(data))))