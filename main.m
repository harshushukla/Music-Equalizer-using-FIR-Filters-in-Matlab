clc, clearvars, close all

[x, fs] = audioread('music.mp3');
x = x(:,1);

t = (0: length(x) - 1 )/ fs;

figure;
subplot(2,1,1);
plot(t,x);
title("Time Plotting of Music File")
xlabel('Time Axis (seconds)');
ylabel('Signal Amplitudes');

N = length(x);
xfft = fft(x);
xfreq = (0 : N - 1) * (fs / N);

subplot(2,1,2);
plot(xfreq,abs(xfft));
title("Magnitude of FFT of Music File")
xlabel('Frequency Axis (Hz)');
ylabel('Magnitude values');
xlim([0 fs / 2]);


% Equalizer Bands
fbass = 904;
fmid1 = 904;
fmid2 = 2400;
ftreble = 2400;


% Making required filters for each band
Nb = 300; % ORDER OF THE BASS FILTER
bbass = fir1(Nb, fbass / (fs / 2));

Nm = 300;
bmid = fir1(Nm, [fmid1 fmid2] ./ (fs / 2));

Nt = 300;
btreble = fir1(Nt, ftreble / (fs / 2) , "high");

% Computing frequency response for all this filters
figure;
[h1,w] = freqz(bbass,1,1024,fs);
[h2,~] = freqz(bmid,1,1024,fs);
[h3,~] = freqz(btreble,1,1024,fs);

subplot(3,1,1)
plot(w,abs(h1))
title("Bass Filter")

subplot(3,1,2)
plot(w,abs(h2))
title("Mid Filter")

subplot(3,1,3)
plot(w,abs(h3))
title("Treble Filter")

% Applying filters for our music file
xbass = filter(bbass,1,x);
xmid = filter(bmid, 1 , x);
xtreble = filter(btreble, 1 , x);

% Gains for different bands
gbass = 0;
gmid = 0.3;
gtreble = 3;

xbass = gbass * xbass;
xmid = gmid * xmid;
xtreble = gtreble * xtreble;

% Adding all the bands
y = xbass + xmid + xtreble;
y = y / max(abs(y));

% Computing fft of the final equalized signal
N2 = length(y);
yfft = fft(y);
yfreq = (0 : N2 - 1) *(fs / N2);

figure;
subplot(2,1,1);
plot(xfreq,abs(xfft));
xlim([0 fs / 2]);
xlabel('Frequency (Hz) limited to half the sampling frequency');
ylabel('Magnitude');
title('Magnitude Spectrum of FFT of Input Signal');

subplot(2,1,2);
plot(yfreq,abs(yfft));
xlim([0 fs / 2]);
xlabel('Frequency (Hz) limited to half the sampling frequency');
ylabel('Magnitude');
title('Magnitude Spectrum of FFT of Output Signal');

sound(y,fs);