  
figure(1);
clf;
msize=24;

nixlist =[80:87, 103:108, 132,156,180,204, 265:272, 230:24:350, 234:24:378,320, 296:299, 205:212, 387:402, 418, 442, 462:479];
%%nixlist=[];

[num, edge, A, L,x,y]=makelabyrinth(msize,msize,nixlist);

nk = num(find(num>0));
Lx = L(nk,nk);
xx=x(nk);
yy=y(nk);

if (0),
  [a,b]=eig(Lx);
  e2=a(:,2);
  e3=a(:,3);
  e4=a(:,4);
  e5=a(:,2);
  e5 = (e5-min(e5));
  e5 = round((e5/max(e5))*254)+1;
  
  figure(2);
  clf;
  rgb = hsv(256);
  col = rgb(e5,:);
  plot3(e2,e3,e4,'.');
  for k=1:length(e2),
    line('xdata',e2(k), 'ydata', e3(k), 'zdata', e4(k), 'color', rgb(e5(k),:), 
    'marker','o', 'markersize',8);
  endfor;
endif;
  
figure(3);
clf;

mousepos = 24;
rgb = gray(256);
nstate = length(xx);

withpotential=0;
usenormalisedL = 1;
potential = -1;
massfact = 1;
dt = 2;
backwards = 1;
nruns = 100;
rewardat = [177];
reward   = [1];
rewardthreshold = 0.25;

if (usenormalisedL),
  dd = 1./sqrt(diag(Lx));
  LL = diag(dd)*Lx*diag(dd);
else 
  LL = Lx;
endif;
ndim = length(dd);
Vpot = zeros(ndim,1);

valuefunc = zeros(ndim,1);
for kr = 1:length(rewardat),
     valuefunc(rewardat(kr)) = valuefunc(rewardat(kr)) + reward(kr);
endfor;
RewardOperator = diag(valuefunc);

%% Ugly stamp out a potential
llmod = [151:24:271,152:24:272,153:24:273,154:24:274, 155:24:275];
if (withpotential),
  Vpot(llmod) = potential;
endif;
Vpot = Vpot - valuefunc;

ntotrun = 50;

%% compose initial picture by setting probabilities as gray shades.
mmim = ones(msize,msize);
%% mark labyrinth boundaries by white color.
for k = 1:length(nixlist),
   kp = nixlist(k);
   mmim(x(kp),y(kp)) = 255;
endfor;
image(mmim);
colormap(rgb);
%big loop

for krun = 1:ntotrun,
  Ham = -LL*massfact + diag(Vpot);
  % unitary propagator
  Ut = expm(-i*Ham*dt);
  thresholdreached = 0;
  
  psi = zeros(nstate,1);
  psi(mousepos) = 1.0;
  pr = abs(psi);
  pr = max(1,min(round(pr*256*4)+1,255));
  nbackruns = nruns;
  for kk=1:nruns
    psi = Ut*psi;
    pr = sqrt(abs(psi));  % better visually for small pr
    pr = max(1,min(round(pr*256)+1,255));
    for k = 1:length(pr),
       mmim(xx(k),yy(k)) = pr(k);
    endfor;
    image(mmim);
    drawnow;
     rew = psi'*RewardOperator*psi;
     if (rew>rewardthreshold) 
       printf("Iteration %i: Above threshold %f \n",kk,rew);
       thresholdreached = 1;
       nbackruns = kk;
     endif;
     if (thresholdreached),
        break;
     endif;
  endfor;
  printf("Last reward %f \n", rew);
  pr = abs(psi).^2;
  valuefunc = pr;
  for kr = 1:length(rewardat),
     valuefunc(rewardat(kr)) = valuefunc(rewardat(kr)) + reward(kr);
  endfor;
  psi = sqrt(valuefunc);
  psi = psi/norm(psi);

  thresholdreached = 0;
  
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
  valuefunc = valuefunc + rew*abs(psi).^2 ;
  for kr = 1:length(rewardat),
     valuefunc(rewardat(kr)) = valuefunc(rewardat(kr)) + reward(kr);
  endfor;
  RewardOperator = diag(valuefunc);
  Vpot = -valuefunc;
endfor;
