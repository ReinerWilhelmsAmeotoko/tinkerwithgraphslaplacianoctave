n = 100;
n1=45;
n2=55;
high=0.75;
dt = 0.5;
nrun=1000;
x0=n/4;
xcent=n/2;
x10 = n/4;
x20 = 3*n/4;

sig=5;
kx = 1;  % wave vector
evalu=0;
nev=1;
rep=1;
L = diag(2*ones(n,1))-diag(ones(n-1,1),1)-diag(ones(n-1,1),-1);

%node n+1 = node 1
if (rep),
L(1,n)=-1;
L(n,1)=-1;
endif;

clf;
x = 0:n-1;
x = x(:);

dd=zeros(n,1);
dd(n1:n2)=high;

dd = exp(-0.0017*(x-xcent).^2).*(x-x10).^4.*(x-x20).^4;
dd = high*dd/dd(n/2);
plot(x,dd,'r');

axis([0 n -0.25 1]);
L = L+diag(dd);

if (evalu),
[ue,ev] = eig(L);
psi = ev(nev,nev)*ue(:,nev).*exp(i*kx*x);
else
psi = exp(-0.5*((x-x0)/sig).^2 + i*kx*x);
psi = psi/norm(psi);
endif;


hr = line('xdata',x,'ydata',psi,'color','b');
hi = line('xdata',x,'ydata',imag(psi),'color','m');
ha = line('xdata',x,'ydata',abs(psi),'color','k');
U = expm(-i*L*dt);


for k=1:nrun,
 psi = U*psi;
 set(hr,'ydata',real(psi));
 set(hi,'ydata',imag(psi));
 set(ha,'ydata',abs(psi));
 axis([0 n -0.25 1]);
 drawnow;
endfor;

