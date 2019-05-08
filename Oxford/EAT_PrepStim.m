function cfg = EAT_PrepStim(cfg)

%% prepare movies

add_len = 100;

% get rectangle size to crop the maze stimuli to size of screen
filename = 'mov_str_1.png';
name = fullfile('stimuli','maze',filename);
frame.cdata = imread(name);
rect_1 = (size(frame.cdata,2)-cfg.pos.width)/2;
rect_2 = (size(frame.cdata,1)-cfg.pos.height)/2;
%rect_1 = (cfg.pos.width/2)-size(frame.cdata,2);
%rect_2 = (cfg.pos.height/2)-size(frame.cdata,1);
if rect_1 > 0
    if rect_2 > 0
        rect = [rect_1 rect_2 cfg.pos.width cfg.pos.height];
    else
        rect = [rect_1 0 cfg.pos.width-2*rect_1 size(frame.cdata,1)];
    end
else
    if rect_2 > 0
        rect = [0 rect_2 size(frame.cdata,2) cfg.pos.height-2*rect_2];
    else
        % scale with size of screen
        %rect = [0 0 cfg.scale*size(frame.cdata,2) cfg.scale*size(frame.cdata,1)];
        rect = [0 0 2*size(frame.cdata,2) 2*size(frame.cdata,1)];
    end
end
% if strcmp(cfg.cmp,'WindowsXP') % to deal with memory issue
%     rect = [rect(1)+cfg.pos.scale rect(2)+cfg.pos.scale rect(3)-2*cfg.pos.scale rect(4)-2*cfg.pos.scale];% x-min, y-min, width, height
% end

% image rescaling based on cfg.scale
%rescaleSize = cfg.scale * 1.2;

% get movie straight
c = 0;
for x=2:1:5+add_len
    c = c+1;
    filename = ['mov_str_' num2str(x) '.png'];
    name = fullfile('stimuli','maze',filename);
    frame.cdata = imread(name);
    frame.cdata = imcrop(frame.cdata,rect);
    cfg.movie(c)=Screen('MakeTexture', cfg.h.window, frame.cdata);
end

% get movie left
for i = 1:30
    filename = ['mov_left_' num2str(i) '.png'];
    name = fullfile('stimuli','maze',filename);
    frame.cdata = imread(name);
    frame.cdata = imcrop(frame.cdata,rect);
    cfg.movie_left(i)=Screen('MakeTexture', cfg.h.window, frame.cdata);
end
for j = 1:2
    filename = ['mov_str_' num2str(j) '.png'];
    name = fullfile('stimuli','maze',filename);
    frame.cdata = imread(name);
    frame.cdata = imcrop(frame.cdata,rect);
    cfg.movie_left(i+j)=Screen('MakeTexture', cfg.h.window, frame.cdata);
end

% get movie right
for i = 1:30
    filename = ['mov_right_' num2str(i) '.png'];
    name = fullfile('stimuli','maze',filename);
    frame.cdata = imread(name);
    frame.cdata = imcrop(frame.cdata,rect);
    cfg.movie_right(i)=Screen('MakeTexture', cfg.h.window, frame.cdata);
end
for j = 1:2
    filename = ['mov_str_' num2str(j) '.png'];
    name = fullfile('stimuli','maze',filename);
    frame.cdata = imread(name);
    frame.cdata = imcrop(frame.cdata,rect);
    cfg.movie_right(i+j)=Screen('MakeTexture', cfg.h.window, frame.cdata);
end


%% prepare faces/objects

% get database
dir_prac = fullfile('stimuli','picturessmall','experiment'); 
dir_face = fullfile('stimuli','RFD');
%dir_obj = fullfile('stimuli','RFD','scramble2');

for exp = 1:2
    for stim = 1:2
        if stim == 1,   dir = dir_face; stim_names = cfg.stim.exp_happy;
        elseif stim == 2,   dir = dir_face; stim_names = cfg.stim.exp_angry;
        %elseif stim == 3,   dir = dir_obj; stim_names = cfg.stim.exp_hor;
        %elseif stim == 4,   dir = dir_obj; stim_names = cfg.stim.exp_vert;
        end
        % load stimuli and prepare
        for f = 1:length(stim_names)
            name = fullfile(dir,stim_names{f}); frame.cdata = imread(name);
            frame.cdata = imcrop(frame.cdata,[50 60 ...
               (size(frame.cdata,2)-100) (size(frame.cdata,1)-200)]);
%             frame.cdata = imresize(frame.cdata,cfg.scale * 0.11);
            frame.cdata = imresize(frame.cdata,cfg.scale * 0.14);
            cfg.stim.stim{exp,stim,f} = Screen('MakeTexture', cfg.h.window, frame.cdata); % exp, stim, face_nr
            cfg.stim.size{exp,stim,f} = size(frame.cdata); % exp, stim, face_nr
        end
    end
end


%% prepare fixation cross info
xCoords = [cfg.pos.center_x-(cfg.scale*10) cfg.pos.center_x+(cfg.scale*10) cfg.pos.center_x cfg.pos.center_x];
yCoords = [cfg.pos.center_y cfg.pos.center_y cfg.pos.center_y-(cfg.scale*10) cfg.pos.center_y+(cfg.scale*10)];
cfg.allCoords = [xCoords; yCoords];


%% prepare white screen
%if strcmp(cfg.cmp,'WindowsXP');   cfg.stim.white  = Screen('OpenOffscreenWindow', 0, 0,[],32,2);
%else
    cfg.stim.white  = Screen('OpenOffscreenWindow', cfg.screenNumber, 0,[],32,2);
%end
Screen('FillRect',cfg.stim.white, cfg.color.white);

