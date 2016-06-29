
function [num, edge, V,L,x,y] = makelabyrinth (n,m, nx)
dx = 1;
dy = 1;
nm=n*m;
[x,y] = meshgrid(1:n, 1:m);
x = x(:);
y = m+1-y;
y = y(:);

nv=0;
V = 0;
Edge=0;
num = [reshape([1:n*m]',m, n), zeros(m,1);
       zeros(1,n),  0];
for k=1:length(nx),
  num(find(num==nx(k)))=0;
endfor;

for j=1:m,
  for l=1:n,
  ka = num(j,l);
  ne = num(j,l+1);
  ns = num(j+1,l);
  if (ka>0),
  if (ne>0),
  nv = nv+1;
  edge(nv,1)=ka;
  edge(nv,2)=ne;
  V(nv,ka)=-1;
  V(nv,ne) = 1;
  endif;
  if (ns>0),
  nv = nv+1;
  edge(nv,1)=ka;
  edge(nv,2)=ns;
  V(nv,ka)=-1;
  V(nv,ns) = 1;
  endif;
  endif;
  endfor;
endfor;
  
L = V'*V;
%L = L - diag(sum(L));
nk = num(find(num>0));
plot(x(nk),y(nk),'o');
axis([0 n+1 0 m+1]);
if (0),
for k=1:nv,
  line('xdata',[x(edge(k,1)),x(edge(k,2))], 'ydata', [y(edge(k,1)),y(edge(k,2))]);
endfor; 
endif;
if (1),
for k=1:length(nk),
 text(x(nk(k)),y(nk(k)),sprintf('%i',nk(k)));
endfor;
endif;

endfunction