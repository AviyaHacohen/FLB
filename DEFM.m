function [y, v1, v2, y1, y2] = DEFM(x, v1_prev,v2_prev ,y1_prev, y2_prev)
M = 8;                      % Number of bits -> 0<x<15

v1 = v1_prev;
y1 = floor(v1/2^M);  
e1 = v1-(y1*(2^M)); 
v1 = e1 + x;

v2 = v2_prev;
y2 = floor(v2/2^M);  
e2 = v2-(y2*(2^M)); 
v2 = e1 + e2;

y = y1_prev + y2 - y2_prev;
end


