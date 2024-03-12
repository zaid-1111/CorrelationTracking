
ss=1;

hold off
tr=1;
xx=px(sub2ind([MaxBalls Nf],rawtraj(sum(Nptr(1:tr-1))+(1:Nptr(tr))),...
	      rawtime(sum(Nptr(1:tr-1))+(1:Nptr(tr)))));
yy=py(sub2ind([MaxBalls Nf],rawtraj(sum(Nptr(1:tr-1))+(1:Nptr(tr))),...
	      rawtime(sum(Nptr(1:tr-1))+(1:Nptr(tr)))));
tt=0:Nptr(tr)-1;
plot(yy,xx);
hold all;

mxNptr=max(Nptr);
sxx=zeros(Ntr,mxNptr);
syy=zeros(Ntr,mxNptr);
for tr=1:Ntr
  if (Nptr(tr)>5)
    xx=px(sub2ind([MaxBalls Nf],rawtraj(sum(Nptr(1:tr-1))+(1:Nptr(tr))),...
		                rawtime(sum(Nptr(1:tr-1))+(1:Nptr(tr)))));
    yy=py(sub2ind([MaxBalls Nf],rawtraj(sum(Nptr(1:tr-1))+(1:Nptr(tr))),...
		                rawtime(sum(Nptr(1:tr-1))+(1:Nptr(tr)))));
    tt=0:Nptr(tr)-1;

    sxx(tr,tt+1)=xx;
    syy(tr,tt+1)=yy;
    if(mod(tr,10)==0)
      plot(yy,xx);
    end
  end 
end

hold off;
axis ('equal')
