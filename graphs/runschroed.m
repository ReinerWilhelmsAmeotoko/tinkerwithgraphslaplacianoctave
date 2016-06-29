  
figure(1);
clf;
msize=24;

nixlist =[80:87, 103:108, 132,156,180,204, 265:268, 230:24:350, 234:24:378,320, 296:299, 205:212, 387:402, 418, 442, 462:470];
%nixlist=[];

[num, edge, A, L,x,y]=makelabyrinth(msize,msize,nixlist);
npoints = length(x);
xmean = mean(x);
ymean = mean(y);
Vpot = -5 + 0.02*((x-xmean).^2 + (y-ymean).^2);
Vpot = 1.0*Vpot;
Vpot = -exp(-((x-xmean).^2+(y-ymean).^2));

nbound = makebondaries(num);
mkb = num(find(nbound>0));
Vbound = zeros(npoints,1);
Vbound(mkb) = Vbound(mkb) + 0.5;

bump = 0.0*exp(-0.5*((x-2.0).^2+(y-2).^2));
Vpot = Vpot + Vbound + bump;

bump = exp(-0.5*((x-4.0).^2+(y-5).^2));
nk = num(find(num>0));
bump = bump(nk);
bump = bump/norm(bump);

Lx = L(nk,nk);
xx=x(nk);
yy=y(nk);
Vpot = Vpot(nk);


figure(2);
clf;

mousepos = 24;
rgb = gray(256);
nstate = length(xx);

withpotential=0;
usenormalisedL = 0;
massfact = 0.5;
dt = 1.0;
backwards = 0;
nruns = 50;

if (usenormalisedL),
  dd = 1./sqrt(diag(Lx));
  LL = diag(dd)*Lx*diag(dd);
else 
  LL = Lx;
endif;
ndim = length(dd);

%% compose initial picture by setting probabilities as gray shades.
mmim = ones(msize,msize);
%% mark labyrinth boundaries by white color.
for k = 1:length(nixlist),
   kp = nixlist(k);
   mmim(x(kp),y(kp)) = 255;
endfor;
image(mmim);
colormap(rgb);

Ham = -LL*massfact + diag(Vpot);
[EU,ev] = eig(Ham);
% unitary propagator
Ut = expm(-i*Ham*dt);
psi = zeros(nstate,1);
psi(mousepos) = 1.0;
kbul = [1,2,3,4,5,6,7,8,9];

fu = bump;
psi = ones(ndim,1);
%psi = bump;
psi = psi/norm(psi);
pr = abs(psi);
pr = max(1,min(round(pr*256*4)+1,255));
nbackruns = nruns;
for kk=1:nruns
  %psi = Ut*psi;
  psi = EU(:,kk);
  pr = sqrt(abs(psi));  % better visually for small pr
  pr = max(1,min(round(pr*256)+1,255));
  for k = 1:length(pr),
     mmim(xx(k),yy(k)) = pr(k);
  endfor;
  image(mmim);
  title(sprintf("Eigen state %i",kk));
  drawnow;
 pause(0.5);
endfor;

if (backwards) ,
  Ut = expm(i*Ham*dt);
  for kk=1:nbackruns,
  psi = Ut*psi;
  pr = sqrt(abs(psi));
  pr = max(1,min(round(pr*256)+1,255));
  
  for k = 1:length(pr),
     mmim(xx(k),yy(k)) = pr(k);
  endfor;
  image(mmim);
  drawnow;
  endfor;
endif;

