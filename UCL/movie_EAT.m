function movie_EAT

clear
clc

save_video = 1;

%% load movie frames

add_len = 100;
movie_dir = fullfile('EAT','EAT_faces','stimuli','maze');
face_dir = fullfile('EAT','EAT_faces','stimuli','RFD');
face_name = fullfile(face_dir,'Rafd090_07_Caucasian_male_angry_frontal.jpg');


       
%% create movie

if save_video
    writerObj = VideoWriter('straight.avi');
    %writerObj = VideoWriter('straight.mov');
    writerObj.FrameRate = 60; %60;
    open(writerObj);
end

% start with fixation cross on first screen
x = 2;
filename = ['mov_str_' num2str(x) '.png'];
name = fullfile(movie_dir,filename);
img = imread(name);
 % add fixation cross
%prepare fixation cross info
xCoords = [cfg.pos.center_x-10 cfg.pos.center_x+10 cfg.pos.center_x cfg.pos.center_x];
yCoords = [cfg.pos.center_y cfg.pos.center_y cfg.pos.center_y-10 cfg.pos.center_y+10];
cfg.allCoords = [xCoords; yCoords];


writeVideo(writerObj,img)

% get movie straight
for x=2:1:5+add_len
    filename = ['mov_str_' num2str(x) '.png'];
    name = fullfile(movie_dir,filename);
    img = imread(name);
    if x > 52 && x <= 70 % 18 frames for face
        face = imread(face_name,'jpg');
        face = imcrop(face,[50 60 size(face,2)-100 size(face,1)-200]);
        face = imresize(face,0.2);
        for i = 1:size(face,1)
            img(300+i,size(img,2)/2-size(face,2)+1:size(img,2)/2,:) = face(i,:,1:3);
        end
%         image([1 size(img,2)],[1 size(img,1)],img)
%         hold on
%         image(size(img,2)/2-size(face,2),300,face)
%         im = image;
%         frame = getframe;
%         writeVideo(writerObj,frame)
%     
        
    end
    writeVideo(writerObj,img)
end;

% get movie left
for i = 1:30
    filename = ['mov_left_' num2str(i) '.png'];
    name = fullfile(movie_dir,filename);
    img = imread(name);
    writeVideo(writerObj,img)
end
for j = 1:2
    filename = ['mov_str_' num2str(j) '.png'];
    name = fullfile(movie_dir,filename);
    img = imread(name);
    if j == 2   % add feedback on final screen
        
    
    end
    writeVideo(writerObj,img)
end

close(writerObj)


