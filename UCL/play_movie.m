%% load straight movement
StraightObj = VideoReader('straight.avi');
vidWidth = StraightObj.Width;
vidHeight = StraightObj.Height;
mov = struct('cdata',zeros(vidHeight, vidWidth,3,'uint8'),...
'colormap',[]);
%% load turn
TurnObj = VideoReader('leftturn.avi');
%movleft = struct('cdata',zeros(vidHeight, vidWidth,3,'uint8'),...
%'colormap',[]);
%% prepare movie
k = 1;
while hasFrame(StraightObj)
    mov(k).cdata = readFrame(StraightObj);
    k = k+1;
end
%k = 1;
while hasFrame(TurnObj)
    %movleft(k).cdata = readFrame(TurnObj);
    mov(k).cdata = readFrame(TurnObj);
    k = k+1;
end
%% display
hf = figure;
set(hf,'position',[150 150 vidWidth vidHeight]);
movie(hf,mov,1,StraightObj.FrameRate);

% left = 1;
% right = 0;
% 
% % still update to remove the flick
% if left 
%     %hf = figure;
%     %set(hf,'position',[150 150 vidWidth vidHeight]);
%     movie(hf,movleft,1,StraightObj.FrameRate);
% % elseif right
% %     hf = figure;
% %     set(hf,'position',[150 150 vidWidth vidHeight]);
% %     movie(hf,mov,1,StraightObj.FrameRate);
% end

