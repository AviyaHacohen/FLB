
filename1 = 'MATLAB_SDM_order1_const.txt';
data1 = readmatrix(filename1);
MATLAB1 = reshape(data1.', 1, []);

filename2 = 'MATLAB_SDM_order2_const.txt';
data2 = readmatrix(filename2);
MATLAB2 = reshape(data2.', 1, []);


filename3 = 'SDM_RTL_order1_const.txt';
data3 = readmatrix(filename3);
RTL1 = reshape(data3.', 1, []);


filename4 = 'SDM_RTL_order2_const.txt';
data4 = readmatrix(filename4);
RTL2 = reshape(data4.', 1, []);

isEqual1 = isequal(MATLAB1(1:end-1), RTL1(2:end));
isEqual2 = isequal(MATLAB2, RTL2);

mean1 = mean(RTL1-1);
mean2 = mean(RTL2-1);



