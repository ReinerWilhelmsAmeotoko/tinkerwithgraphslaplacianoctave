## Copyright (C) 2016 reiner
## 
## Author: reiner <reiner@ameotoko>
## Created: 2016-06-07

function pict = makepictogram (pix)
pict = pix;
[n,m]=size(pict);
done = 0;

image(pict);
while done==0,
  [x,y,b]=ginput(1);
  ix = max(1,min(round(x),m));
  iy = max(1,min(round(y),n));
  if (b==1),
     pict(iy,ix)=255;
     image(pict);
  elseif (b==3),
     pict(iy,ix)=0;
     image(pict);
  elseif (b==2),
    done=1;
    break;
  endif;
endwhile;

endfunction
