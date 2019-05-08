function EAT_MakeMovie_v2
%--------------------------------------------------------------------------
% EAT_makemovie: Used to make the movies from the "Emotional Action Task"
% experiment using matlab and PsychToolbox
%
% This file is part of the EAT experiment
% Copyright (C) 2015, Inge Volman
% i.volman@ucl.ac.uk
%--------------------------------------------------------------------------

%% default actions

% Clear the workspace and the screen
close all;


% enforce script to run on a sytem supporting OpenGL
AssertOpenGL;

%% get movie stimuli

add_len = 100;
add_back = 20;


% % get structure of maze
% Z = [repmat(6,1,52+add_len);...
%     [repmat(6,62+add_len,19+add_len) zeros(62+add_len,31) repmat(6,62+add_len,2)];...
%     [repmat(6,1,18+add_len) zeros(1,32) repmat(6,1,2)];[repmat(6,1,17+add_len) zeros(1,33) repmat(6,1,2)];...
%     [repmat(6,1,16+add_len) zeros(1,34) repmat(6,1,2)];[repmat(6,1,15+add_len) zeros(1,35) repmat(6,1,2)];...
%     [repmat(6,1,14+add_len) zeros(1,36) repmat(6,1,2)];[zeros(31,50+add_len) repmat(6,31,2)];...
%     [repmat(6,1,14+add_len) zeros(1,36) repmat(6,1,2)];[repmat(6,1,15+add_len) zeros(1,35) repmat(6,1,2)];...
%     [repmat(6,1,16+add_len) zeros(1,34) repmat(6,1,2)];[repmat(6,1,17+add_len) zeros(1,33) repmat(6,1,2)];...
%     [repmat(6,1,18+add_len) zeros(1,32) repmat(6,1,2)];...
%     [repmat(6,62+add_len,19+add_len) zeros(62+add_len,31) repmat(6,62+add_len,2)];...
%     repmat(6,1,52+add_len)];

Z = [repmat(6,1,52+add_len+add_back);...
    [repmat(6,31,2) zeros(31,31+17+add_len+add_back) repmat(6,31,2)];...
    [repmat(6,62+add_len-31,19+add_len) zeros(62+add_len-31,31) repmat(6,62+add_len-31,2+add_back)];...
    [repmat(6,1,18+add_len) zeros(1,32) repmat(6,1,2+add_back)];[repmat(6,1,17+add_len) zeros(1,33) repmat(6,1,2+add_back)];...
    [repmat(6,1,16+add_len) zeros(1,34) repmat(6,1,2+add_back)];[repmat(6,1,15+add_len) zeros(1,35) repmat(6,1,2+add_back)];...
    [repmat(6,1,14+add_len) zeros(1,36) repmat(6,1,2+add_back)];[zeros(31,50+add_len) repmat(6,31,2+add_back)];...
    [repmat(6,1,14+add_len) zeros(1,36) repmat(6,1,2+add_back)];[repmat(6,1,15+add_len) zeros(1,35) repmat(6,1,2+add_back)];...
    [repmat(6,1,16+add_len) zeros(1,34) repmat(6,1,2+add_back)];[repmat(6,1,17+add_len) zeros(1,33) repmat(6,1,2+add_back)];...
    [repmat(6,1,18+add_len) zeros(1,32) repmat(6,1,2+add_back)];...
    [repmat(6,62+add_len-31,19+add_len) zeros(62+add_len-31,31) repmat(6,62+add_len-31,2+add_back)];...
    [repmat(6,31,2) zeros(31,31+17+add_len+add_back) repmat(6,31,2)];...
    repmat(6,1,52+add_len+add_back)];

fig = figure('Position',[1 1 1152 870],'visible','on');
set(gca,'color','none');

% prepare colormap
colormap default
map = colormap;

len_firstpartmaze = 19+add_len;
len_openpartmaze = 31;
len_secondpartmaze = add_back+2;
index = [ones(size(Z,1),len_firstpartmaze) [50*ones(1,len_openpartmaze)' ones(size(Z,1)-2,len_openpartmaze)'...
    50*ones(1,len_openpartmaze)']' [ones((size(Z,1)-31)/2,1)' 50*ones(31,1)' ones((size(Z,1)-31)/2,1)']'...
    ones(size(Z,1),len_secondpartmaze-1)];

% create figure & set camera
h = bar3(Z, 1);

% assign color
for jj = 1:length(h)
    cnt = 0;
    xd = get(h(jj),'xdata');
    yd = get(h(jj),'ydata');
    zd = get(h(jj),'zdata');
    delete(h(jj))    
    idx = [0;find(all(isnan(xd),2))];
    if jj == 1
        S = zeros(length(h)*(length(idx)-1),1);
    end
    for ii = 1:length(idx)-1
        cnt = cnt + 1;
        S(cnt) = surface(xd(idx(ii)+1:idx(ii+1)-1,:),...
                         yd(idx(ii)+1:idx(ii+1)-1,:),...
                         zd(idx(ii)+1:idx(ii+1)-1,:),...
                         'facecolor',map(randperm(3,1)+index(cnt,jj),:));
    end
end

% get camera into position
%axis vis3d
caxis([30+add_len 34+add_len]) %caxis([30+add_len 44+add_len])
camproj('perspective'); daspect();
camtarget([45+add_len,round(size(Z,1)/2),1]); campos([1,round(size(Z,1)/2),1]); camva(100);
set(gcf,'renderer','opengl');
axis vis3d off


%% make movie straight
c = 0;
% move the camera and save frames
for x=1:1:5+add_len
    c = c+1;
    campos([x,round(size(Z,1)/2),1]);
    frame = getframe; 
    frame = CropFrame(frame);
    filename = ['mov_str_' num2str(c) '.png'];
    name = fullfile('stimuli2',filename);
    imwrite(frame.cdata,name,'png')
end;

%% make movie left
%campos([20+add_len,round(size(Z,1)/2),1]);
% get camera positions
viewpoint = camtarget;
orig_position = campos;
c = 0;

% rotate/move the camera and save frames
for i = 1:30;
    c = c+1;
    camtarget([viewpoint(1)-10,viewpoint(2)-1*i,1]);
    campos([orig_position(1)+i,orig_position(2)-0.5*i,1]);
    frame = getframe; 
    frame = CropFrame(frame);
    filename = ['mov_left_' num2str(c) '.png'];
    name = fullfile('stimuli2',filename);
    imwrite(frame.cdata,name,'png')
end
%65+add_len
camtarget([viewpoint(1)-10,viewpoint(2)-(65+add_len),1]);
position = campos;
for j = 1:20
    c = c+1;
    campos([position(1),position(2)-j,1]);
    frame = getframe; 
    frame = CropFrame(frame);
    filename = ['mov_left_' num2str(c) '.png'];
    name = fullfile('stimuli2',filename);
    imwrite(frame.cdata,name,'png')
end

%% make movie right
% campos([28+add_len,round(size(Z,1)/2),1]);
% viewpoint = camtarget;
% orig_position = campos;

% return camera to original position
campos(orig_position);
c = 0;

% rotate/move the camera and save frames
for i = 1:30;
    c = c+1;
    camtarget([viewpoint(1)-10,viewpoint(2)+1*i,1]);
    campos([orig_position(1)+i,orig_position(2)+0.5*i,1]);
    frame = getframe; frame = CropFrame(frame);
    filename = ['mov_right_' num2str(c) '.png'];
    name = fullfile('stimuli2',filename);
    imwrite(frame.cdata,name,'png')
end
camtarget([viewpoint(1)-10,viewpoint(2)+(65+add_len),1]); 
position = campos;
for j = 1:20
    c = c+1;
    campos([position(1),position(2)+j,1]);
    frame = getframe; 
    frame = CropFrame(frame);
    filename = ['mov_right_' num2str(c) '.png'];
    name = fullfile('stimuli2',filename);
    imwrite(frame.cdata,name,'png')
end

% close figure window
close;



function frame = CropFrame(frame)
%% crop image
[iy, ix, iz]=size(frame.cdata); %#ok<NASGU>
wW = 1152;
wH = 870;

recrop = 0;
if recrop ==1
    % new windowsize
    wWcrop = wW-600;
    
    if ix>wWcrop
        cl=round((ix-wWcrop)/2);
        cr=(ix-wWcrop)-cl;
    else
        cl=0;
        cr=0;
    end
    if iy>wH
        ct=round((iy-wH)/2);
        cb=(iy-wH)-ct;
    else
        ct=0;
        cb=0;
    end
    frame.cdata = frame.cdata(1+ct:iy-cb, 1+cl:ix-cr,:);
end

% resize to real window size
frame.cdata = imresize(frame.cdata,wW/size(frame.cdata,2));

% crop height to window size keeping bottom part stable 
[iy, ix, iz]=size(frame.cdata); %#ok<NASGU>
if iy > wH
    ct=iy-wH;
    %cb=0;
    %     cl = 0;
    %     cr = 0;
    frame.cdata = frame.cdata(1+ct:iy, :,:);
end

