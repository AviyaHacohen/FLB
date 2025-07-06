% Parameters
num=74;
n_psd=2^10; 
fs=1e9;
N = 2^16 - 1;          % Number of samples 
M = 8;               % Number of bits -> 0<x<15

filename1 = 'random_input.txt';
data1 = readmatrix(filename1);
x1 = reshape(data1.', 1, []);
x = x1(1:N);

%filename2 = 'order1.txt';
filename2 = 'SDM_RTL_order1_rand.txt';
data2 = readmatrix(filename2);
y_2 = reshape(data2.', 1, []);
y1 = y_2(1:N);

%filename3 = 'order2.txt';
filename3 = 'SDM_RTL_order1_rand.txt';
data3 = readmatrix(filename3);
y_3 = reshape(data3.', 1, []);
y2 = y_3(1:N);

err1=y1(3:end) -1 -x(1:end-2)/2^M;
err2=y2(3:end) -1 -x(1:end-2)/2^M;

figure;
[psd1,f]=pwelch(err1,hann(n_psd), n_psd/2,n_psd, fs, 'oneside');
psd1=psd1/2; 
semilogx(f, 10*log10(psd1));
title ('PSD - SDM block RTL');
hold on;

[psd2,f]=pwelch(err2,hann(n_psd), n_psd/2,n_psd, fs, 'oneside');
psd2=psd2/2; 
semilogx(f, 10*log10(psd2));

zm1 = exp(-2i*pi*f/fs);
psd_th1 = 1/sqrt(12*fs)*abs((1-zm1).^1);
psd_th2 = 1/sqrt(12*fs)*abs((1-zm1).^2);

semilogx(f, 20*log10(psd_th1));
semilogx(f, 20*log10(psd_th2));

legend('1st', '2nd','1st theory', '2nd theory');
xlabel("freq [Hz]");
ylabel("PSD [dB]");


