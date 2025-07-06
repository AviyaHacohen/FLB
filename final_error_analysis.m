%clear all;
%close all;
%clc;

num=74;
n_psd=2^10; 
fs=1e9;
N = 2^16 - 1;          % Number of samples 
M = 8;


filename1 = 'sin_input_flb.txt';
data1 = readmatrix(filename1);
x1 = reshape(data1.', 1, []);
input_flb = reshape(repmat(x1(1:N),20,1),1,[]);


data = readlines('sin_output_flb_fix.txt');
data = str2double(data); 
output_flb = data(1:20*N)';


filename3 = 'sin_input_sdm.txt';
data3 = readmatrix(filename3);
x3 = reshape(data3.', 1, []);
input_sdm = reshape(repmat(x3(1:N),20,1),1,[]);

data = readlines('sin_output_sdm_fix.txt');
data = str2double(data);  
output_sdm = data(1:20*N)';

filename5 = 'sin_input_dec.txt';
data5 = readmatrix(filename5);
x5 = reshape(data5.', 1, []);
input_dec = reshape(repmat(x5(1:N),20,1),1,[]);

data = readlines('sin_output_dec_fix.txt');
data = str2double(data);  
output_dec = data(1:20*N)';


err_flb= output_flb(21:end) -1 - input_flb(1:end-20)/2^8;
err_sdm= output_sdm(21:end) -1 -input_sdm(1:end-20)/2^8;
err_dec= output_dec(21:end) -1 -input_dec(1:end-20)/2^8; %-1 because os bin is 1
all_zeros = all(err_dec == 0);
disp(all_zeros) 


figure;


[psd3,f]=pwelch(err_sdm,hann(n_psd), n_psd/2,n_psd, fs, 'oneside');
psd3=psd3/2; 
semilogx(f, 10*log10(psd3));
hold on;

[psd1,f]=pwelch(err_flb,hann(n_psd), n_psd/2,n_psd, fs, 'oneside');
psd1=psd1/2; 
semilogx(f, 10*log10(psd1),'LineWidth', 1);
hold on;


title ('Power Spectral Density - FLB error');
xlabel("freq [Hz]");
ylabel("PSD [dB]");
legend('SDM - MATLAB model','FLB - RTL');


