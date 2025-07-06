for n=0
    [col_off, col_on, row_p, row_n] = ENCODER(n);
    n_res = DEC(col_off,col_on,row_p,row_n);
    fprintf("\n-- Test Case %d --\n", n);
    fprintf("Input number: %d\n", n);
    fprintf("Output number: %d\n", n_res);
    fprintf('col_off:');
    disp(col_off);
    fprintf('col_on: ');
    disp(col_on);
    fprintf('row_p:  ');
    disp(row_p);
    fprintf('row_n:  ');
    disp(row_n);
    fprintf("-----------------");
    
end
