pic = loadlabyrinth;

barrier = [ones(1,12) 0 0 1 1 1 1 1 1 1 0 0 ones(1,12)]';
%m = length(barrier);
%pic = zeros(m,m);
%pic(:, 20) = barrier;
gunx = 2;
guny = 2;
kx = 2*pi/3;
ky = 1;
stx = 1.0;
sty = 4.0;
dt = 0.5;
nrounds=100;
[Lx,vertindex,edges,ix,iy] = laplacianfrompict(pic);

if (1),
  dd = 1./sqrt(diag(Lx));
  LL = diag(dd)*Lx*diag(dd);
else 
  LL = Lx;
endif;

Ham = -LL;

Ut = expm(-i*Ham*dt);
nodnum = vertindex(find(vertindex(:)>0));
ndim = length(nodnum);

bump = exp(-0.5*(((iy-guny)/sty).^2+((ix-gunx)/stx).^2) + i*(kx*ix+ky*iy));
%ptx = vertindex(12,1);

psi = bump;
psi = psi/norm(psi);

mpx = pic*255;
image(mpx);

for k=1:nrounds,
  psi = Ut*psi;
  pr = sqrt(abs(psi));
  ipr = max(1,min(round(pr*256)+1,255));
  for j = 1:length(pr),
    mpx(iy(j),ix(j)) = ipr(j);
  endfor;
  image(mpx);
  drawnow;
endfor;