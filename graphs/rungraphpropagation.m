## Copyright (C) 2016 reiner
#
## Author: reiner <reiner@ameotoko>
## Created: 2016-06-10

function rungraphpropagation(pic, nrounds, gunx, guny, kx, ky)

stx = 5.0;
sty = 5.0
dt = 0.25;

[LL,vertindex,edges,ix,iy] = laplacianfrompict(pic);

Ham = -LL;

Ut = expm(-i*Ham*dt);
nodnum = vertindex(find(vertindex(:)>0));
ndim = length(nodnum);

bump = exp(-0.5*(((iy-guny)/sty).^2+((ix-gunx)/stx).^2) + i*(kx*ix+ky*iy));

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
endfunction
