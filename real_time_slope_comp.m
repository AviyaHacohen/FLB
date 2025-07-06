n_psd=2^10; 
fs=1e9;
N = 2^16 - 1;          % Number of samples 
M = 8;


filename1 = 'sin_input_flb.txt';
data1 = readmatrix(filename1);
x1 = reshape(data1.', 1, []);
input_flb = reshape(repmat(x1(1:N),20,1),1,[]);


data = readlines('sin_output_flb_fix_oreder1.txt');
data = str2double(data); 
output_flb1 = data(1:20*N)';


data = readlines('sin_output_flb_fix_oreder2.txt');
data = str2double(data); 
output_flb2 = data(1:20*N)';

err_flb1= output_flb1(21:end) -1 - input_flb(1:end-20)/2^8;
err_flb2= output_flb2(21:end) -1 - input_flb(1:end-20)/2^8;

[psd1,f]=pwelch(err_flb1,hann(n_psd), n_psd/2,n_psd, fs, 'oneside');
psd1=psd1/2; 
%semilogx(f, 10*log10(psd1));
%hold on;

[psd2,f]=pwelch(err_flb2,hann(n_psd), n_psd/2,n_psd, fs, 'oneside');
psd2=psd2/2; 
%semilogx(f, 10*log10(psd2));
%hold on;

f1 = 1e7;  % 1 kHz
f2 = 1e8;  % 100 kHz
idx = (f >= f1) & (f <= f2);

psd1_dB = 10 * log10(psd1);
psd2_dB = 10 * log10(psd2);

p1 = polyfit(log10(f(idx)), psd1_dB(idx), 1);
slope_dB_per_decade1 = p1(1);

p2 = polyfit(log10(f(idx)), psd2_dB(idx), 1);
slope_dB_per_decade2 = p2(1);

fprintf('First order slope: %.2f dB/decade\n', slope_dB_per_decade1);
fprintf('Second order slope: %.2f dB/decade\n', slope_dB_per_decade2);