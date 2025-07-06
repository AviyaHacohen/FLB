function [num_cap] = DEC(col_off,col_on,row_p,row_n)
    num_cap = 0;
    for i = 1:16
        for j = 1:16
            if mod(i, 2) == 1
                num_cap =num_cap + ~(col_off(i) & (~(col_on(i) & row_p(j))));
            else 
                num_cap =num_cap + ~(col_off(i) & (~(col_on(i) & row_n(j))));
            end 
        end
    end


