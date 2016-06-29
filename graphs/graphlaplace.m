
kk = 11;
n1 = 8;
n2 = 8;
n3 = 6;
n4 = 7;
n5 = 7;
n = n1+n2+n3+n4+n5;

vrs = [0.4;0.5;0.3;0.25;0.125]*1.0;

cl1 = randn(n1,2)*vrs(1);
cl2 = randn(n2,2)*vrs(2);
cl3 = randn(n3,2)*vrs(3);
cl4 = randn(n4,2)*vrs(4);
cl5 = randn(n5,2)*vrs(5);

xc = [ -1.0,   0.0;
       -0.2,  -0.5;
        0.5,   0.0;
        1.0,   1.0
        0.0    1.0];

if (keep==0),        
x0 = [cl1(:,1)+xc(1,1); 
      cl2(:,1)+xc(2,1); 
      cl3(:,1)+xc(3,1); 
      cl4(:,1)+xc(4,1); 
      cl5(:,1)+xc(5,1)];
y0 = [cl1(:,2)+xc(1,2); 
      cl2(:,2)+xc(2,2); 
      cl3(:,2)+xc(3,2); 
      cl4(:,2)+xc(4,2); 
      cl5(:,2)+xc(5,2)];
endif;
      
figure(1);

clf;
    
x=x0;
y=y0;
    
plot(x,y,'o');

xmi = min(x);
xma = max(x);
ymi = min(y);
yma = max(y);
dx = (xma-xmi);
dy = (yma-ymi);
axis([xmi-dx/5, xma+dx/5, ymi-dy/5, yma+dy/5]);

d = zeros(n,n);
for k=1:n,
  for j=1:(k-1),
  d(k,j) = sqrt((x(k)-x(j))^2+(y(k)-y(j))^2);
  d(j,k) = d(k,j);
  endfor;
endfor;
th = 4*exp(-2*d);
fx=1.0/mean(d(:));
A = (d*fx)<rand(n,n);
A = A-diag(diag(A));
A = max(A,A');

dd2 = sum(A);
L = diag(sum(A))-A;
if (prod(dd2)>0),
  if (keep==2)
   AX = A.*exp(-d);
   dd2 = 1./sqrt(sum(AX));
   LL = diag(dd2)*(diag(sum(AX))-AX)*diag(dd2);
  elseif (keep==3),
   AX = exp(-d);
   AX = AX - diag(diag(AX));
   LL = diag(sum(AX))-AX;
  else
   dd2 = 1./sqrt(dd2);
   LL = diag(dd2)*L*diag(dd2);
  endif;
else
  LL = L;
endif;

clf;
plot(x,y,'.');
for k=1:n,
for j=1:(k-1),
 if (A(k,j)>0),
  line('xdata',[x(k),x(j)],'ydata',[y(k),y(j)], 'linewidth', th(k,j),'color','k');
 endif;
endfor;
endfor;

if (keep==0),
  [U,B]=eig(L);
else
  [U,B]=eig(LL);
endif;

e2 = U(:,2);
e3 = U(:,3);
e4 = U(:,4);

ec = e2-min(e2);
ec = ec/max(ec);
[uu,ii]=sort(e2);

%line('xdata',x(ii), 'ydata',y(ii), 'linewidth', 1, 'color','r');

for k=1:n,
 %  line('xdata',x(k),'ydata',y(k),'marker','o','markersize',15,'linewidth',5,
 %  'color',[ec(k),1-ec(k),0.5]);
 ik=ii(k);
 text(x(ik),y(ik),sprintf('%i',k),'fontsize',16,'fontweight','bold','color',[ec(ik),1-ec(ik),0.25]);
endfor;

[uu,jj]=min(e2);
line('xdata',x(jj),'ydata',y(jj),'marker','o','markersize',20,'linewidth',4,'color','c');
[uu,jj]=max(e2);
line('xdata',x(jj),'ydata',y(jj),'marker','o','markersize',20,'linewidth',4,'color','b');

figure(2);
clf;
x = e2;
y = e3;
z = e4;

plot3(x,y,z,'o');
xmi = min(x);
xma = max(x);
ymi = min(y);
yma = max(y);
zmi = min(z);
zma = max(z);

dx = (xma-xmi);
dy = (yma-ymi);
dz = (zma-zmi);
axis([xmi-dx/5, xma+dx/5, ymi-dy/5, yma+dy/5, zmi-dz/5, zma+dz/5]);

for k=1:n,
for j=1:(k-1),
 if (A(k,j)>0),
  line('xdata',[x(k),x(j)],'ydata',[y(k),y(j)], 'zdata',[z(k),z(j)], 
  'linewidth', th(k,j) ,'color','k');
 endif;
endfor;
endfor;

for k=1:n,
 ik=ii(k);
 text(x(ik),y(ik),z(ik), sprintf('%i',k),'fontsize',16,'fontweight','bold','color',[ec(ik),1-ec(ik),0.25]);
endfor;

[uu,jj]=min(e2);
line('xdata',x(jj),'ydata',y(jj),'zdata',z(jj),'marker','o','markersize',20,'linewidth',4,'color','c');
[uu,jj]=max(e2);
line('xdata',x(jj),'ydata',y(jj),'zdata',z(jj),'marker','o','markersize',20,'linewidth',4,'color','b');
