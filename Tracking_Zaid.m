 clear all
 close all
 %Initial Variables appointed by mark S:
 
% w=1.3;
% D=12;

%%NOTES
%Hq is tested and exhausted
%Hq_2: 8-15 pixels for D is a GOOD range. use this


%% Code Starts

 S = load('tls_hq_ImData_1.mat');       %Load Video Data File
 testvid = VideoReader('tls_hq.mp4');   %Load Video
    dims = size(S.Video_Data);
    D = 10;               % enter for precise value; remove for rough value in data set
    w= D*0.11;           % Width  (ADJUST THIS ACCORDING TO RESOLUTION)
      Cutoff=4;          % minimum peak intensity
    MinSep= S.minsep ;   % minimum separation between peaks
       %MinSep= 10*D ;
  TrackedPoints = {};    % Initiate Tracked Data cells location
  
  
  
  %% First Frame
  framepic = read(testvid,S.StartFrame); %video frame of tracked data
       cropped1frame = framepic(S.ybox(1):S.ybox(2),S.xbox(1):S.xbox(2));
       % SHOW THE FRAME

       %imshow( croppedframe );
       c1dims = size(cropped1frame); %get dims of cropped frame
   
    raw = S.Video_Data(1:c1dims(1),1:c1dims(2),1); %Data being worked with for tracking
    [Nx Ny]=size(raw);       % image size
    hi=250;  % hi and lo values come the image histogram
    lo=10;   % hi/lo=typical pixel value outside/inside
    ri=(hi-double(raw))/(hi-lo);  % normalize image
    ss=2*fix(D/2+4*w/2)-1;          % size of ideal particle image
    os=(ss-1)/2;                    % (size-1)/2 of ideal particle image
    [xx yy]=ndgrid(-os:os,-os:os);  % ideal particle image grid
    r=hypot(xx,yy);                 % radial coordinate
    
    [Np px py]=findpeaks(1./chiimg(ri,ipf(r,D,w)),1,Cutoff,MinSep);
    
    TrackedPoints(1,:)= {px,py};
    figure(2)
    axis([0 dims(1)+10 0 dims(2)+10],'manual');
    set(axes, 'YDir','reverse');
    %% For - loop
   for i = 2:dims(3);
       framepic = read(testvid,S.StartFrame*S.FrameSkip*i); %video frame of tracked data
       croppedframe = framepic(S.ybox(1):S.ybox(2),S.xbox(1):S.xbox(2));
       % SHOW THE FRAME
       hold on
       figure(2)
       imshow(croppedframe);
       
%        axis([0 dims(1)+10 0 dims(2)+10],'manual');
%        set(axes, 'YDir','reverse');
       cdims = size(croppedframe); %get dims of cropped frame
        
   
    raw = S.Video_Data(1:cdims(1),1:cdims(2),i); %Data being worked with for tracking
    [Nx Ny]=size(raw);       % image size
    hi=250;  % hi and lo values come the image histogram
    lo=10;   % hi/lo=typical pixel value outside/inside
    ri=(hi-double(raw))/(hi-lo);  % normalize image
    ss=2*fix(D/2+4*w/2)-1;          % size of ideal particle image
    os=(ss-1)/2;                    % (size-1)/2 of ideal particle image
    [xx yy]=ndgrid(-os:os,-os:os);  % ideal particle image grid
    r=hypot(xx,yy);                 % radial coordinate
    
    [Np px py]=findpeaks(1./chiimg(ri,ipf(r,D,w)),1,Cutoff,MinSep);% find maxima
    
    TrackedPoints(i,:)= {px,py};
     %Npf = 6 + zeros(1, dims(3));
     %Nf = dims(3);
   
    %% Velocity based tracking:
    
    dx=bsxfun(@minus,cell2mat(TrackedPoints(i,1)),cell2mat(TrackedPoints(i-1,1))'); %Get X distance between frames
    dy=bsxfun(@minus,cell2mat(TrackedPoints(i,2)),cell2mat(TrackedPoints(i-1,2))'); %Get Y distance between frames
    [mn ii]=min(hypot(dx,dy));
    hold on
    
   % plot([cell2mat(TrackedPoints(i-1,2)) py(ii)]' ,...
       % [cell2mat(TrackedPoints(i-1,1)) px(ii)]','b.-');
    TrackedPoints(i,:)= {px(ii),py(ii)}; %Resort by array of smallest distances
    
    %Note: Exclusion of boundary points is done at the end of Chiimg
    %function (Line 34-> end)
%% Position-based sorting here:

% NOTE: positional sorting is done here for drawing lines and finding angles

    P = sort([px py]);
     px = P(:,1);
     py = P(:,2);

   %% Plotting Tracked Points and lines on Video
   hold on
     xrange = (px(3):1:px(4)); %Range of lines
   pM = polyfit([px(3),px(4)],[py(3),py(4)],1)  %Middle Line
   pM1 = polyval(pM,xrange);
   plot(pM1,xrange,'b-')
    xrange = px(1):1:px(2);
   pL = polyfit([px(1),px(2)],[py(1),py(2)],1) %Left Segment Line
   pL1 = polyval(pL,xrange);
   plot(pL1,xrange,'b-')
    xrange = px(5):1:px(6);
   pR = polyfit([px(5),px(6)],[py(5),py(6)],1) %Right Segment Line
   pR1 = polyval(pR,xrange);
   plot(pR1,xrange,'b-');
          colors = jet(length(px));
         %figure(2);
         for j = 1:length(px)
        plot(py(j),px(j),'o','Color',colors(j,:)); 
        hold on 
         end
    hold off
     %% Resort according to original stored data
    px = cell2mat(TrackedPoints(i,1));
    py = cell2mat(TrackedPoints(i,2));
    pause(1/50)  %Tracked Video Framerate setter
   end
  
