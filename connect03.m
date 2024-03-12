nshow=fix(Nf/10);

[MaxBalls,Nf]=size(px);

NNp=sum(Npf(:));
Nbm=max(Npf);
rawtraj=zeros(1,NNp);
rawtime=zeros(1,NNp);
avail=(px(1:Nbm,:)~=0);

imagesc(avail); drawnow;

Ntr=0;
Nptr=0;
NN=0;
for nf=1:Nf-1
  for nb=find(avail(:,nf)==1)'
    Ntr=Ntr+1;
    Nptr(Ntr)=0; %#ok<SAGROW>
    cnb=nb;
    cnf=nf;
    NN=sum(Nptr);
    avail(cnb,cnf)=avail(cnb,cnf)-1;
    Nptr(Ntr)=Nptr(Ntr)+1; %#ok<SAGROW>
    rawtraj(NN+Nptr(Ntr))=cnb;
    rawtime(NN+Nptr(Ntr))=cnf;
%    while ((cnf<Nf) & (cc(1,cnb,cnf)~=0) & avail(cc(1,cnb,cnf),cnf+1)==1)
    while ((cnf<Nf) && (cc(1,cnb,cnf)>0))
      cnb=cc(1,cnb,cnf);
      cnf=cnf+1;
      Nptr(Ntr)=Nptr(Ntr)+1; %#ok<SAGROW>
      rawtraj(NN+Nptr(Ntr))=cnb;
      rawtime(NN+Nptr(Ntr))=cnf;
      avail(cnb,cnf)=avail(cnb,cnf)-1;
    end
  end
  if (rem(nf,nshow)==0)
    imagesc(avail); drawnow;
    fprintf(1,'.');
  end
  if (sum(avail(:))==0)
    break;
  end
end
fprintf(1,'done\n');      
imagesc(avail); drawnow;


