N = 2^16;
x_not_limited = randi([10, 250], 1, N) + round(randn(1,N));
x = max(min(x_not_limited, 255), 0);
file = fopen('random_input.txt', 'w');
fprintf(file, '%d\n', x);
fclose(file);