%Nx=260;
%Ny=260;
eNf=Nf; % Nf is the number of frames
hold on
for nf=2:eNf
  hold off
  plot(cell2mat(TrackedPoints(nf,2)),cell2mat(TrackedPoints(nf,1)),'g.','MarkerSize',25);
  %plot(py(1:Npf(1),nf+1),px(1:Npf(1),nf+1),'g.','MarkerSize',25);
  hold on                     
  plot(cell2mat(TrackedPoints(nf-1,2)),cell2mat(TrackedPoints(nf-1,1)),'g.','MarkerSize',25);
  %axis ij;                 
  %axis([0 270 0 270]);
  %axis square;
  mm=find(cc(1,1:Npf(nf),nf)>0);
  plot([py(mm,nf) py(cc(1,mm,nf),nf+1)]',...
       [px(mm,nf) px(cc(1,mm,nf),nf+1)]','r')
  disp(nf);
  pause(.2);
end

