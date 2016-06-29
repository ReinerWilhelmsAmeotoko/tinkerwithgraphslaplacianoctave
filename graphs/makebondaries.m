## Copyright (C) 2016 reiner
## 
## Author: reiner <reiner@ameotoko>
## Created: 2016-06-06

function bound = makebondaries (num)

[n,m] = size(num);

h = zeros(1,m);
v = zeros(n,1);
M = num;
M0 = [ 0, h, 0;
       v, M, v;
       0, h, 0];
M1 = [ v, M, v;
       0, h, 0; 
       0, h, 0];
M2 = [ h, 0, 0; 
       M, v, v;
       h, 0, 0];
M3 = [ 0, 0, h;
       v, v, M;
       0, 0, h]; 
M4 = [ 0, h, 0;
       0, h, 0;
       v, M, v]; 
bb= ((M1+M2+M3+M4-4*M0).*M0)!=0;
bound = bb(2:n+1, 2:m+1);

endfunction
