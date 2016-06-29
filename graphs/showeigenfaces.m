## Copyright (C) 2016 reiner
## 
## Author: reiner <reiner@ameotoko>
## Created: 2016-06-08

function bigp = showeigenfaces(pic, nmul, mmul)
ke=0;
[Lx,vertindex,edges,ix,iy] = laplacianfrompict(pic);

if (0),
  dd = 1./sqrt(diag(Lx));
  LL = diag(dd)*Lx*diag(dd);
else 
  LL = Lx;
endif;

[Ue,ev] = eig(LL);

rgb = hot(256);
colormap(rgb);

mpx = pic*254+1;
[n,m]=size(mpx);

bigp = zeros(nmul*n,mmul*m);

image(mpx);
for kk=1:nmul,
  for jj = 1:mmul,
  ke=ke+1;
  psi = Ue(:,ke);
  pr = abs(psi);
  ipr = max(1,min(round(pr*1024)+1,255));
  for j = 1:length(pr),
    mpx(iy(j),ix(j)) = ipr(j);
  endfor;
  image(mpx);
  title(sprintf('Eigen mode %i',ke));
  drawnow;
  pause(1);
  kran=(kk-1)*n+1:kk*n;
  jran=(jj-1)*m+1:jj*m;
  bigp(kran',jran') = mpx;
  endfor;
endfor;

image(bigp);

endfunction
