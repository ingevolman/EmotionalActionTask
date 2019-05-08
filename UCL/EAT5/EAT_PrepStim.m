function cfg = EAT_PrepStim(cfg)

%% prepare movies

add_len = 100;

% get rectangle size to crop the maze stimuli to size of screen
filename = 'mov_str_1.png';
name = fullfile('stimuli','maze',filename);
frame.cdata = imread(name);
rect_1 = (size(frame.cdata,2)-cfg.pos.width)/2;
rect_2 = (size(frame.cdata,1)-cfg.pos.height)/2;
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
        rect = [0 0 size(frame.cdata,2) size(frame.cdata,1)];
    end
end
% if strcmp(cfg.cmp,'WindowsXP') % to deal with memory issue
%     rect = [rect(1)+cfg.pos.scale rect(2)+cfg.pos.scale rect(3)-2*cfg.pos.scale rect(4)-2*cfg.pos.scale];% x-min, y-min, width, height
% end

% get movie straight
c = 0;
for x=2:1:5+add_len
    c = c+1;
    filename = ['mov_str_' num2str(x) '.png'];
    name = fullfile('stimuli','maze',filename);
    frame.cdata = imread(name);
    frame.cdata = imcrop(frame.cdata,rect);
    cfg.movie(c)=Screen('MakeTexture', cfg.h.window, frame.cdata);
end;

% get movie left
for i = 1:30;
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
for i = 1:30;
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
dir_obj = fullfile('stimuli','RFD','scramble2');

for exp = 1:2
    for stim = 1:4
%         % get specifics per practice/experiment & emotion
%         if exp == 1 && emo == 1;   dir = dir_prac; stim = cfg.stim.prac_happy;
%         elseif exp == 1 && emo == 2;   dir = dir_prac; stim = cfg.stim.prac_angry;
%         elseif exp == 2 && emo == 1;   dir = dir_exp; stim = cfg.stim.exp_happy;
%         elseif exp == 2 && emo == 2;   dir = dir_exp; stim = cfg.stim.exp_angry;
%         end
        if stim == 1,   dir = dir_face; stim_names = cfg.stim.exp_happy;
        elseif stim == 2,   dir = dir_face; stim_names = cfg.stim.exp_angry;
        elseif stim == 3,   dir = dir_obj; stim_names = cfg.stim.exp_hor;
        elseif stim == 4,   dir = dir_obj; stim_names = cfg.stim.exp_vert;
        end
        % load stimuli and prepare
        for f = 1:length(stim_names)
            name = fullfile(dir,stim_names{f}); frame.cdata = imread(name);
            %if exp ==2
            if stim < 3
                frame.cdata = imcrop(frame.cdata,[50 60 size(frame.cdata,2)-100 size(frame.cdata,1)-200]);
            end
            frame.cdata = imresize(frame.cdata,0.11);
            %elseif exp == 1;   frame.cdata = imresize(frame.cdata,0.75);
            cfg.stim.stim{exp,stim,f} = Screen('MakeTexture', cfg.h.window, frame.cdata); % exp, stim, face_nr
            cfg.stim.size{exp,stim,f} = size(frame.cdata); % exp, stim, face_nr
        end
    end
end


%% prepare fixation cross info
xCoords = [cfg.pos.center_x-10 cfg.pos.center_x+10 cfg.pos.center_x cfg.pos.center_x];
yCoords = [cfg.pos.center_y cfg.pos.center_y cfg.pos.center_y-10 cfg.pos.center_y+10];
cfg.allCoords = [xCoords; yCoords];


%% prepare white screen
%if strcmp(cfg.cmp,'WindowsXP');   cfg.stim.white  = Screen('OpenOffscreenWindow', 0, 0,[],32,2);
%else
    cfg.stim.white  = Screen('OpenOffscreenWindow', cfg.screenNumber, 0,[],32,2);
%end
Screen('FillRect',cfg.stim.white, cfg.color.white);


% function frame = AdjFrame(frame,cfg)
% %% adjust image to size
% % Crop image if it is larger then screen size. There's no image scaling
% % in maketexture
% [iy, ix, iz]=size(frame.cdata); %#ok<NASGU>
% [wW, wH]=WindowSize(cfg.h.window);
% 
% % expand image to fit screen
% if ix<wW && iy < wH % expand picture - blow up the pixels
%     frame.cdata = imresize(frame.cdata,cfg.pos.win(3)/size(frame.cdata,2));
% end
