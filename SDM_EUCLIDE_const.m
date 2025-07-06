% Parameters
num=74;
n_psd=2^10; 
fs=1e9;
N = 4100;          % Number of samples 
M = 8;               % Number of bits -> 0<x<15

filename1 = 'SDM_RTL_order1_const.txt';
data1 = readmatrix(filename1);
y_1 = reshape(data1.', 1, []);
y1 = y_1(1:N);

filename2 = 'SDM_RTL_order2_const.txt';
data2 = readmatrix(filename2);
y_2 = reshape(data2.', 1, []);
y2 = y_2(1:N);

x = repmat(num,1, N) + randn(1,N);

err1=y1-1 -x/2^M;
err2=y2-1 -x/2^M;

figure;
[psd1,f]=pwelch(err1,hann(n_psd), n_psd/2,n_psd, fs, 'oneside');
psd1=psd1/2; 
semilogx(f, 10*log10(psd1));
title ('PSD (DEFM-RTL)');
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


