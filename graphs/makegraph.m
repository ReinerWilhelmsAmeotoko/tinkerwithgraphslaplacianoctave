## Copyright (C) 2016 reiner
## 
## Author: reiner <reiner@ameotoko>
## Created: 2016-06-07
function [con, L] = makegraph
con = [1 2;
1 3;
1 4;
2 5;
2 6;
2 7;
7 14;
7 15;
6 8;
6 9;
9 10;
9 11;
11 12;
11 13;
3 16;
3 17;
4 18; 
18 21;
4 19;
4 20;
4 22;
22 23;
22 24;
24 25;
25 26;
1 27;
27 28;
27 29;
27 30;
27 31; 
27 32; 
6 22 ;
5 13;
26 27;
17 27;
18 7];

mm = max(max(con));
A = zeros(mm,mm);
for k=1:length(con),
   A(con(k,1),con(k,2)) = 1;
endfor;
%L = diag(sum(A+A'))-A-A';
L = diag(sum(A+A'))-A-A';
dd = diag(1./sqrt(diag(L)));
Lx = dd*L*dd;
[u,v] = eig(L);
x = u(:,2);
y = u(:,3);
z = u(:,4);
clf;
plot3(x,y,z,'.');
for k=1:length(con),
  line('xdata',[x(con(k,1)),x(con(k,2))],
  'ydata',[y(con(k,1)),y(con(k,2))],
  'zdata',[z(con(k,1)),z(con(k,2))], 'linewidth',2);
 endfor;
 for k=1:mm,
   text(x(k),y(k),z(k),sprintf('%i',k),'fontsize',16);
 endfor;
endfunction;
