function params = do_read_video()

        [FileName,pname]=uigetfile( {'*.mp4';'*.avi'},'Pick sample image file' );


            cd (pname);
            FileName;
        
        %set(last_movie_read,'String', FileName)
        
            vr = VideoReader(FileName); %create VideoReader object
        
        %axes(video_axes)

%         if(Keep_Window == 1)
%             xbox(1) = str2double(get(x1,'String'));
%             xbox(2) = str2double(get(x2,'String'));
%             ybox(1) = str2double(get(y1,'String'));
%             ybox(2) = str2double(get(y2,'String'));
%         else
%             axes(video_axes)
            ReadStartFrame = 1;
            frame = read(vr, ReadStartFrame);
            image(frame);
            hold on
            [xbox,ybox] = ginput(2);
            xbox = round(xbox);
            ybox = round(ybox);
            hold off
%             set(x1,'String', num2str(xbox(1)))
%             set(x2,'String', num2str(xbox(2)))
%             set(y1,'String', num2str(ybox(1)))
%             set(y2,'String', num2str(ybox(2)))
       % end

%       highlight sample box
        frame = read(vr,ReadStartFrame);
        for xx = xbox(1):xbox(2)
            for yy = ybox(1):ybox(2)
                frame(yy,xx,:) = frame(yy,xx,:) +40 ;
            end
        end
       % axes(video_axes)
        image(frame)
        axis image
        totalpixels = 10;
%       report size of box into GUI
        
width = abs(1+xbox(2)-xbox(1));
        height = abs(1+ybox(2)-ybox(1));
        %set(totalpixels,'String', num2str(width*height))
%       allocate arrays
        [d1,d2,d3] = size(frame);
       % PSindex = d1*d2;
        Frame_Read = zeros(d1,d2,3);

        clear frame;
        TotalNumFrames = 120;

%       Determine max array size based on available memory
        if ispc
            user = memory; %Get the avaialble memory for WIN computers
        else
            user.MaxPossibleArrayBytes = e9; %Guess a max size for arrays for MAC or LINUX
        end
   
        
        StripeWidth = round(user.MaxPossibleArrayBytes/(TotalNumFrames*height));
        
        if StripeWidth <= width/2
            NumStripes = floor(width/StripeWidth);
            LeftOverPixels = width - (NumStripes*StripeWidth);
            StripeBegin = xbox(1);
            StripeEnd = StripeBegin + StripeWidth -1;
            Video_Data = zeros(height, StripeWidth, TotalNumFrames);

        else
            NumStripes = 1;
            StripeBegin = xbox(1);
            StripeEnd = xbox(2);
            StripeWidth = width;
            Video_Data = zeros(height, StripeWidth, TotalNumFrames);
        end

        for q = 1:NumStripes
         Index = 1;
         FrameReadIndex = 1;
         
%           convert image files into data
try
    FrameReadFrequency = 1;
            for y = ReadStartFrame : TotalNumFrames+ReadStartFrame-1
                
                Frame_Read = read(vr,FrameReadIndex);

                Video_Data(:,:,Index) = squeeze(mean(Frame_Read(ybox(1):ybox(2),StripeBegin:StripeEnd),3));
                clear Frame_Read;
                Index = Index + 1;
                FrameReadIndex = FrameReadIndex + FrameReadFrequency;
                

            end
catch
disp(strcat('Not enough frames. Only ',num2str(FrameReadIndex),' were read.'))
      end
            
%           save data to a file 
                Data_File_Name = ...
                    [FileName(1:length(FileName)-4) '_ImData_' num2str(q)];
%                 save (Data_File_Name,'-v7.3', 'Video_Data', '')
                save_DataFile = matfile(Data_File_Name,'Writable',true);
                save_DataFile.Video_Data= Video_Data;
                
                disp(['Stripe number ' num2str(q) ' of the data has been read.'])
                
                StripeBegin = StripeBegin + StripeWidth;
                StripeEnd = StripeBegin + StripeWidth -1;
        end
        %StorData = load(Data_File_Name)
        f = figure; clf
        f.Visible = true;
        f.Units = 'normalized';
        f.OuterPosition = [1/4 1/2 1/2 1/2];
        f.OuterPosition = [0.0973  0.1521  0.8348  0.8319];
        frame = read(vr,ReadStartFrame);
        image(frame)
        title('Select two locations for Diameter (D) of points')
        [Diax Diay] = ginput(2);
        D = (Diax(2)-Diax(1)).^2+(Diay(2)-Diay(1)).^2;
        D = D.^(1/2);
        w = D/2;
        save_DataFile.D = D;
        image(frame)
        title('Select two locations for minimum separation (minsep) between points')
        [sepx sepy] = ginput(2);
        minsep = (sepx(2)-sepx(1)).^2+(sepy(2)-sepy(1)).^2;
        minsep= minsep.^(1/2);
        save_DataFile.minsep = minsep;
        save_DataFile.StartFrame = ReadStartFrame;
        save_DataFile.FrameSkip = FrameReadFrequency;
        save_DataFile.TotalFrames = TotalNumFrames;
        save_DataFile.xbox = xbox;
        save_DataFile.ybox = ybox;