
filename1 = 'MATLAB_SDM_order1_random.txt';
data1 = readmatrix(filename1);
MATLAB1 = reshape(data1.', 1, []);

filename2 = 'MATLAB_SDM_order2_random.txt';
data2 = readmatrix(filename2);
MATLAB2 = reshape(data2.', 1, []);


filename3 = 'SDM_RTL_order1_rand.txt';
data3 = readmatrix(filename3);
RTL1 = reshape(data3.', 1, []);


filename4 = 'SDM_RTL_order2_rand.txt';
data4 = readmatrix(filename4);
RTL2 = reshape(data4.', 1, []);

isEqual1 = isequal(MATLAB1(1:end-2), RTL1(2:end));
isEqual2 = isequal(MATLAB2(1:end-1), RTL2);