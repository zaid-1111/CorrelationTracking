good=find(px~=-9e99);

ymx=ceil(max(py(good)))+5;
ymn=floor(min(py(good)))-5;
Ny=ymx-ymn+1;
xmx=ceil(max(px(good)))+5;
xmn=floor(min(px(good)))-5;
Nx=xmx-xmn+1;



densi=zeros(Nsub*Nx,Nsub*Ny);
velxi=zeros(Nsub*Nx,Nsub*Ny);
velyi=zeros(Nsub*Nx,Nsub*Ny);
vx=px*0-99;
vy=vx;

for nf=1:Nf-1	
  for np=1:Npf(nf)	
    if cc(1,np,nf)>0
      ix=fix(Nsub*px(np,nf))-xmn+1;
      iy=fix(Nsub*py(np,nf))-ymn+1;
      vx(np,nf)=px(cc(1,np,nf),nf+1)-px(np,nf);
      vy(np,nf)=py(cc(1,np,nf),nf+1)-py(np,nf);
      densi(ix,iy)=densi(ix,iy)+1;
      velxi(ix,iy)=velxi(ix,iy)+vx(np,nf);
      velyi(ix,iy)=velyi(ix,iy)+vy(np,nf);
    end
  end
  if (rem(nf,fix(Nf/10))==0)
    fprintf(1,'.');
  end
end
fprintf(1,'done.\n');

