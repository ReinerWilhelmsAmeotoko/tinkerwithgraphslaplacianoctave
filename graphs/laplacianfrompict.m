## Copyright (C) 2016 reiner
## 
## input: a pixel map with 1 representing walls
## output graph laplacian
## Author: reiner <reiner@ameotoko>
## Created: 2016-06-07

function [L,vertindx,edges,ix,iy] = laplacianfrompict(pix)
[n,m] = size(pix);
nedges = 0;
edges = [];
nvert = 0;
vertices = [];
vertindx = pix*0;
ix=0;
iy=0;
for j=1:m,
  for k=1:n,
    if (pix(k,j)==0),
      nvert = nvert+1;
      vertindx(k,j) = nvert;
      iy(nvert)=k;
      ix(nvert)=j;
    endif;
  endfor;
endfor;  

for j=1:m,
  for k=1:n,
    if (pix(k,j)==0),
      if (j<m),
       if (pix(k,j+1)==0),
       nedges = nedges+1;
       edges(nedges,1) = vertindx(k,j);
       edges(nedges,2) = vertindx(k,j+1);
       endif 
      endif;
      if (k<n),
       if (pix(k+1,j)==0),
       nedges = nedges+1;
       edges(nedges,1) = vertindx(k,j);
       edges(nedges,2) = vertindx(k+1,j);
       endif 
      endif;
    endif;
  endfor;
endfor;
L = zeros(nvert,nvert);
for k =1:nedges,
  n1 = edges(k,1);
  n2 = edges(k,2);
  if (n1 != n2),
   L(n1,n1) += 1;
   L(n2,n2) += 1;
   L(n1,n2) = -1;
   L(n2,n1) = -1;
  endif;
endfor;
ix=ix';
iy=iy';
endfunction
