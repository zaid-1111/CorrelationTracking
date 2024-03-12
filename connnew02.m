Nsub=1;

Ntrack='001';

id='0008';

novel=1;

Prerec=3;                 % number of times to recurse with Nfac less frames
Nfac=16;
Nrec=1;                   % number of times to recurse

BADFR=99999;

[Mb Nf]=size(px);         % get Max balls and Number of frames
Nbm=max(Npf(find(Npf~=BADFR)))+4;           % get number of balls plus 4 walls
clip2=2;
%Nx=260;              % position of bottom wall
Ny=260;                   % position of side wall
NNy=Ny-clip2;              % position of bottom wall
bsx=3*D;                   % search block size in the x-direction
bsy=3*D;                   % search block size in the y-direction
maxcc=7;

good=find(px~=-9e99);

ymx=ceil(max(py(good)))+5;
ymn=floor(min(py(good)))-5;
Ny=ymx-ymn+1;
xmx=ceil(max(px(good)))+5;
xmn=floor(min(px(good)))-5;
Nx=xmx-xmn+1;

disp([Nx,Ny,Nsub])
velxb=zeros(Nsub*Nx,Nsub*Ny);
velyb=zeros(Nsub*Nx,Nsub*Ny);


X=[Nx; 1];                  % x-coord of walls
Y=[NNy; 1];                 % y-coord of walls

Nf=Nf/Nfac;

for nrec=1:Nrec+Prerec
if(nrec==Prerec+1)
  Nf=Nf*Nfac;
end
fprintf('pass %1d  Nf=%d ',nrec,Nf);

cc=zeros(maxcc,Nbm,Nf-1);     % initialize connection matrix
dd=zeros(maxcc,Nbm,Nf-1);     % initialize distance matrix
Ncc=zeros(Nbm,Nf-1);      % initialize Number of connections matrix
for nf=1:Nf-1           % loop over all frames
  l=1:Npf(nf);            % list of all particles in frame
  ll=1:Npf(nf+1);         % list of all particles in next frame
  vx=velxb(sub2ind([Nsub*Nx,Nsub*Ny],clip(fix(Nsub*px(l,nf)),1,Nx),clip(fix(Nsub*py(l,nf)),1,Ny)));
  vy=velyb(sub2ind([Nsub*Nx,Nsub*Ny],clip(fix(Nsub*px(l,nf)),1,Nx),clip(fix(Nsub*py(l,nf)),1,Ny)));
  npx=px(l,nf)+vx;
  npy=py(l,nf)+vy;

  for np=1:Npf(nf)        % loop over all particles in frame nf
    if (vy(np)~=0)
      sx=vx(np)./vy(np);
    else 
      sx=0;
    end
    if (vx(np)~=0)
      sy=vy(np)./vx(np);
    else 
      sy=0;
    end
    wallx=[X; npx(np)+sx*(Y-npy(np*ones(2,1)))];   % closest distance to wall
    wally=[npy(np)+sy*(X-npx(np*ones(2,1))); Y];   % for particle np along
						   % direction of velocity

% find all particles or walls within a square +- bsx x bsy pixels
    tmp=find((abs(npx(np)-[px(ll,nf+1); wallx])<bsx)...
	   & (abs(npy(np)-[py(ll,nf+1); wally])<bsy));   
    ncc=max(length(tmp));       % number of possible connections
    Ncc(np,nf)=ncc;                

    mm=tmp(tmp<=Npf(nf+1));              % list of ball connections
    inn=find(tmp>Npf(nf+1));                   % index to wall connections
    nn=tmp(inn)-Npf(nf+1);                     % list of wall connections
    tmp(inn)=-nn;                              % set wall to negitive values

% sort particles by distance
    [tmpdd idd]=...
      sort(abs(npx(np*ones(1,ncc))-[px(mm,nf+1);wallx(nn)] + ...
      1i*(npy(np*ones(1,ncc))-[py(mm,nf+1);wally(nn)])));
    ncc=min([ncc maxcc]);             % examine at most the maxcc closest
    dd(1:ncc,np,nf)=tmpdd(1:ncc);
    cc(1:ncc,np,nf)=tmp(idd(1:ncc));  % sorted connection list
    % done np
  end    
  % done inital find connection for frame nf

  % eliminate multiple connections to the same particle in nf+1
  imm=find(cc(1,1:Npf(nf),nf)>0);   % list of ball connections
  [tmp itmp]=sort(cc(1,imm,nf));    % sorted list of ball connections
  bl=find(diff(tmp)==0);            % find repeated values
  bl=unique([bl bl+1]);             
  bl=imm(itmp(bl));                 % list of all multiple connections

  pr=unique(cc(1,bl,nf));            % list of unique connections
  na=setdiff(ll,cc(1,l,nf));
  for npc=1:length(pr)
    cbl=bl(cc(1,bl,nf)==pr(npc));
    uu=ismember(cc(:,cbl,nf),[na pr(npc)]).*cc(:,cbl,nf);
    luu=sum(uu>0);
    Ntot=prod(luu);
    siz=num2cell(luu);
    siz2=num2cell(size(uu));
    siz3=num2cell(size(dd));
    Nluu=length(luu);
    ii=cell(1,Nluu);
    mind=9e99;
    imind=num2cell(ones(1,Nluu));
    for ntt=1:Ntot
      [ii{:}]=ind2sub([siz{:}],ntt);
      cset=uu(sub2ind([siz2{:}],[ii{:}],1:Nluu));
      if (length(unique(cset))==Nluu)
	ddd=sum(dd(sub2ind([siz3{:}],[ii{:}],cbl(1:Nluu),nf*ones(1,Nluu))));
	[mind im]=min([mind ddd]);
	if (im==2)
	  imind=ii;
	end
      end
    end
    s1=sub2ind([siz3{:}],...
	       [ones(1,Nluu) imind{:}],...
	       cbl([1:Nluu 1:Nluu]),...
	       nf*ones(1,2*Nluu));
    s2=sub2ind([siz3{:}],...
	       [imind{:} ones(1,Nluu)],...
	       cbl([1:Nluu 1:Nluu]),...
	       nf*ones(1,2*Nluu));
    dd(s1)=dd(s2);
    cc(s1)=cc(s2);
  end
  % If a wall is closest but there is an unmatch particle in the next
  % frame which is in 2nd closest then use that instead.
  inn=find(cc(1,1:Npf(nf),nf)<0);  % index to wall connections
  na=setdiff(ll,cc(1,l,nf));       % not assigned connections in nf+1
  ddp=intersect(cc(2,inn,nf),na);  % list of 2nd closest connection
                                   % in na
  for ndp=1:length(ddp)
    imm=find(cc(2,inn,nf)==ddp(ndp));   % list of all possible connections
    [mtmp im]=min(dd(2,inn(imm),nf));   % connect to closest only
    cc([1 2],inn(imm(im)),nf)=cc([2 1],inn(imm(im)),nf);  % swap connection
    dd([1 2],inn(imm(im)),nf)=dd([2 1],inn(imm(im)),nf);  % swap distance
  end

  % remove multiple connections to same particle;
  imm=find(cc(1,1:Npf(nf),nf)>0);   % list of ball connections
  [tmp itmp]=sort(cc(1,imm,nf));    % sorted list of ball connections
  bl=find(diff(tmp)==0);            % find repeated values
  bl=unique([bl bl+1]);             
  bl=imm(itmp(bl));                 % list of all multiple connections
  pr=unique(cc(1,bl,nf));            % list of unique connections
  for npc=1:length(pr)
    cbl=bl(cc(1,bl,nf)==pr(npc)); % current bad connection 
    [mm im]=min(dd(1,cbl,nf));          % choose best
    cc(1,cbl(cbl~=cbl(im)),nf)=0; % zero others
    dd(1,cbl(cbl~=cbl(im)),nf)=0; % zero others
  end
  

  if (rem(nf,fix(Nf/10))==0)
    fprintf(1,'.');
  end 
  
end
fprintf(1,'done.\n');      

fprintf('calcfield');
calcfield
  
[xx yy]=ndgrid(-Nsub*D*2:Nsub*D*2,-Nsub*D*2:Nsub*D*2);    
rr=abs(xx+1i*yy);
dc=double(rr<Nsub*D*2);
densb=conv2(densi,dc,'same');
velxb=conv2(velxi,dc,'same')./(densb+eps);
velyb=conv2(velyi,dc,'same')./(densb+eps);
densb=densb/sum(sum(rr<Nsub*D*2));
if(nrec==1)
  velxb=velxb*0+mean(velxb(:));
  velyb=velyb*0+mean(velyb(:));
end
end









