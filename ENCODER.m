function [col_off ,col_on ,row_p ,row_n] = ENCODER(n)
    num_lines = 16;
    col_off = ones(1,16);
    col_on = zeros(1,16);
    row_n = ones(1,16);
    row_p = zeros(1,16);

    col_on_line = floor(n/num_lines) + 1;
    row_on_num = mod(n, 16);

    for i = 1:(col_on_line)
      col_on(i) = 1;
      if i ~= 1
          col_off(i-1) = 0;
      end
    end
    if row_on_num == 0
        if mod(col_on_line, 2) == 0
            row_p = ~row_p;
            row_n = ~row_n;
        end 
    else
        if mod(col_on_line, 2) == 1
            for i=1:row_on_num
               row_p(i) = 1;
               row_n(i) = 0;
            end
        else
            for i=1:(num_lines-row_on_num)
               row_p(i) = 1;
               row_n(i) = 0;
            end
        end
    end
