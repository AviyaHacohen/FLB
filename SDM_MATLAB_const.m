% Parameters
num=74;
n_psd=2^10; 
fs=1e9;
N = 2^16;          % Number of samples 
M = 8;               % Number of bits -> 0<x<15

% intialize  
x = repmat(num,1, N);

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

writematrix(y_order1' + 1, 'MATLAB_SDM_order1_const.txt');
writematrix(y_order2' + 1, 'MATLAB_SDM_order2_const.txt');

% for adding noise: +randn(size(x))
err1=y_order1(2:end)-x(1:end-1)/2^M;
err2=y_order2(3:end)-x(1:end-2)/2^M;



