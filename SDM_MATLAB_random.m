% Parameters
n_psd=2^10; 
fs=1e9;
N = ;          % Number of samples 
M = 8;               % Number of bits -> 0<x<15

% intialize  
%x = repmat(num,1, N) + randn(1,N);

data = readmatrix('random_input.txt');
x = data';

%x = 128+64*sin(2*pi()*(1:N)/(2^13));

y1 = zeros(1, N);        
y2 = zeros(1, N);
y = zeros(1, N);         
v1 = zeros(1, N);          
v2 = zeros(1, N);          
         

for k=1:N
    if k==1
        [y(k),v1(k), v2(k), y1(k), y2(k)] =DEFM(x(k), 0, 0, 0, 0);
    else
        [y(k),v1(k), v2(k), y1(k), y2(k)] =DEFM(x(k), v1(k-1), v2(k-1), y1(k-1), y2(k-1));  
    end
end

y_order1 = y1;
y_order2 = y;

writematrix(y_order1' + 1, 'MATLAB_SDM_order1_random.txt');
writematrix(y_order2' + 1, 'MATLAB_SDM_order2_random.txt');

% for adding noise: +randn(size(x))
err1=y_order1(2:end)-x(1:end-1)/2^M;
err2=y_order2(3:end)-x(1:end-2)/2^M;

figure;
[psd1,f]=pwelch(err1,hann(n_psd), n_psd/2,n_psd, fs, 'oneside');
psd1=psd1/2; 
semilogx(f, 10*log10(psd1));
title ('PSD (DEFM)');
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


