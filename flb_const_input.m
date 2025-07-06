
%input is 0
filename1 = 'FLB_RTL_const1.txt';
data1 = readmatrix(filename1);
RTL1 = reshape(data1.', 1, []);


%input is 0x2A = 42 >>>>  0.164
filename2 = 'FLB_RTL_const2.txt';
data2 = readmatrix(filename2);
RTL2 = reshape(data2.', 1, []);

%input is 0x81 = 129 >>>>  0.5039
filename3 = 'FLB_RTL_const3.txt';
data3 = readmatrix(filename3);
RTL3 = reshape(data3.', 1, []);