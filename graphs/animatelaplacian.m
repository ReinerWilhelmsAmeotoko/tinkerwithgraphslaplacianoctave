## Copyright (C) 2016 reiner
## 
## Author: reiner <reiner@ameotoko>
## Created: 2016-06-08

function [retval] = animatelaplacian (pic,nrounds,nat)

[Lx,vertindex,edges,ix,iy] = laplacianfrompict(pic);

if (nat==1),
  dd = 1./sqrt(diag(Lx));
  LL = diag(dd)*Lx*diag(dd);
else 
  LL = Lx;
endif;

[Ue,ev] = eig(LL);
clf;
rgb = hot(256);
colormap(rgb);

mpx = (pic==0)*100;
image(mpx);

for k=1:nrounds,
  psi = Ue(:,k);
  pr = sqrt(abs(psi));
  ipr = max(1,min(round(pr*512)+1,255));
  for j = 1:length(pr),
    mpx(iy(j),ix(j)) = ipr(j);
  endfor;
  image(mpx);
  title(sprintf('Eigen mode %i',k));
  drawnow;
  pause(0.25);
endfor;
endfunction
