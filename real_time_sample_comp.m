
filename = 'FLB_RTL_order1_10000.txt';
data = readmatrix(filename);
order1_10000 = reshape(data.', 1, []);

filename = 'FLB_RTL_order1_50000.txt';
data = readmatrix(filename);
order1_50000 = reshape(data.', 1, []);

filename = 'FLB_RTL_order1_100000.txt';
data = readmatrix(filename);
order1_100000 = reshape(data.', 1, []);