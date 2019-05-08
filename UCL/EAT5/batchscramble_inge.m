%% --------------------------------------
% Init

clear all;
close all
clc

sourcedir = '/Users/iavolman/Library/Mobile Documents/com~apple~CloudDocs/UCL/matlab/EAT/EAT5/stimuli/RFD/';
%savedir = [sourcedir,'scramble/'];
savedir = [sourcedir,'scramble2/'];

%NB doesn't work for _example.png because smaller (800*500 not 800*600)
listIMG = dir([sourcedir,'*neutral_frontal.jpg']);


% --------------------------------------
% Converts all selected files
for i = 1:size(listIMG,1)
%for i = [27 31 39]
    
    % IMG file name
    nameIMG = fullfile(sourcedir, listIMG(i).name);
    %nameIMG2 = fullfile(sourcedir, listIMG2(1).name);
    %img2 = imread(nameIMG2);
    img = imread(nameIMG);
    
    % resize image
    img = imcrop(img,[50 60 size(img,2)-100 size(img,1)-200]);
    %img = imresize(img,0.11);
    
    % find center image
    %loc = [(size(img,1)/2)-5,size(img,2)/2];
    loc = [(size(img,1)/2)-70,size(img,2)/2];
    
    % create ellipse
    npts = 1e4; t = linspace(0,2*pi,npts); aspect = [225 300]; %aspect = [28 35]; % [x y]
    x = aspect(1)*sin(t)+loc(2); y = aspect(2)*cos(t)+loc(1);
    
    % display image & ellipse
    imshow(img); hold on; plot(x, y); hold off
    %imagesc(img); hold on; plot(x, y);
   
    % find coordinates inside ellipse
    mask = [];
    for j = 1:size(img,1) % coordinates y-axis
        for k = 1:size(img,2) % coordinates x-axis
            % find if coordinates are in ellipse. > 1 means outside ellipse
            X = (k-loc(2))*cos(max(t))+(j-loc(1))*sin(max(t)); % Translate and rotate coords.
            Y = -(k-loc(2))*sin(max(t))+(j-loc(1))*cos(max(t)); % to align with ellipse
            if X^2/aspect(1)^2+Y^2/aspect(2)^2 <=1,   mask = [mask; [k j]];   end
        end
    end
    
    % permut coordinates and apply to images
    permut = mask(randperm(length(mask)),:);
    
    img2 = img;
    for j = 1:length(mask)
        img2(mask(j,2),mask(j,1),1:3) = img(permut(j,2),permut(j,1),1:3);
    end
    
   
    %% make ellipse less bright? same smoothness as image itself?
    %Iblur = imgaussfilt(img2,0.5);
    Iblur = img2; % no smoothing

    
    %% get location of bows
    mid = (max(mask) - min(mask))/2 + min(mask);
    %loc_bow = [mid(1)-80 350; mid(1)+80 350];
    loc_bow = [mid(1) 350];
    
    %% overlay with bows & ellipses
    % create smaller mask to avoid ellipse leaving masked image
    npts = 1e4; t = linspace(0,2*pi,npts); aspect = [175 225]; %[200 250]; %aspect = [20 25]; % [x y]
    x = aspect(1)*sin(t)+loc(2); y = aspect(2)*cos(t)+loc(1);
    % find coordinates inside ellipse
    mask = [];
    for j = 1:size(img,1) % coordinates y-axis
        for k = 1:size(img,2) % coordinates x-axis
            % find if coordinates are in ellipse. > 1 means outside ellipse
            X = (k-loc(2))*cos(max(t))+(j-loc(1))*sin(max(t)); % Translate and rotate coords.
            Y = -(k-loc(2))*sin(max(t))+(j-loc(1))*cos(max(t)); % to align with ellipse
            if X^2/aspect(1)^2+Y^2/aspect(2)^2 <=1,   mask = [mask; [k j]];   end
        end
    end
    
%     % determine quadrants
%     q{1} = []; q{2} = []; q{3} = []; q{4} = []; nr_obj = 4;
%     for j = 1:length(mask)
%         if mask(j,1) < loc(2) && mask(j,2)  < loc(1),  q{1} = [q{1} j];   end
%         if mask(j,1) < loc(2) && mask(j,2)  > loc(1),  q{2} = [q{2} j];   end
%         if mask(j,1) > loc(2) && mask(j,2)  < loc(1),  q{3} = [q{3} j];   end
%         if mask(j,1) > loc(2) && mask(j,2)  > loc(1),  q{4} = [q{4} j];   end
%     end
    
    % display second image
   figure(2); imshow(Iblur);  hold on
%      %create horizontal bow
%     temp = randperm(floor(length(mask)/nr_obj),nr_obj); loc_bow = [];
%     for j = 1:length(temp)   
%         loc_bow = [loc_bow; mask(q{j}(temp(j)),:)];   
%     end
    npts = 1e4; t = linspace(0,2*pi,npts); aspect = [1.5 1]; % [x y], keep values as they are, for scaling work in plotting function
    x = aspect(1)*sin(t); y = aspect(2)*cos(t); y2 = y;
    for j = 1:npts
        if x(j) < 0 && y(j) < 0,   y2(j) =  sin(abs(x(j)) - aspect(1));   end
        if x(j) < 0 && y(j) > 0,   y2(j) =  -sin(abs(x(j)) - aspect(1));   end
    end
    for j = 1:size(loc_bow,1),
        plot((25*x)+25*aspect(1)+loc_bow(j,1),(75*y2)+loc_bow(j,2),'k','LineWidth',10) % was 10 and 30 at first
        plot((25*-x)-25*aspect(1)+loc_bow(j,1),(75*-y2)+loc_bow(j,2),'k','LineWidth',10)
    end
    hold off
    
    %write new image to file
    axis off; frame = getframe; 
    outputlabel = [listIMG(i).name(1:end-4),'_hor.jpg'];
    imwrite(frame.cdata, [savedir,outputlabel]);
    
    
    % display second image
    figure(3); imshow(Iblur);  hold on
    %create vertical bow
%     temp = randperm(floor(length(mask)/nr_obj),nr_obj); loc_bow = [];
%     for j = 1:length(temp)   
%         loc_bow = [loc_bow; mask(q{j}(temp(j)),:)];   
%     end
    
    npts = 1e4; t = linspace(0,2*pi,npts); aspect = [1.5 1]; % [x y], keep values as they are, for scaling work in plotting function
    x = aspect(1)*sin(t); y = aspect(2)*cos(t); y2 = y;
    for j = 1:npts
        if x(j) < 0 && y(j) < 0,   y2(j) =  sin(abs(x(j)) - aspect(1));   end
        if x(j) < 0 && y(j) > 0,   y2(j) =  -sin(abs(x(j)) - aspect(1));   end
    end
    for j = 1:size(loc_bow,1),
        plot((75*y2)+loc_bow(j,1),(25*x)+25*aspect(1)+loc_bow(j,2),'k','LineWidth',10)
        plot((75*-y2)+loc_bow(j,1),(25*-x)-25*aspect(1)+loc_bow(j,2),'k','LineWidth',10)
    end
    hold off
    
   %write new image to file
    axis off; frame = getframe; outputlabel = [listIMG(i).name(1:end-4),'_vert.jpg'];
    imwrite(frame.cdata, [savedir,outputlabel],'jpg');
        
    
%     % create horizontal ellipse
%     figure(4); imshow(Iblur);  hold on
% %     temp = randperm(floor(length(mask)/nr_obj),nr_obj); loc_bow = [];
% %     for j = 1:length(temp),   loc_ell = [loc_ell; mask(q{j}(temp(j)),:)];
% %     end
%     loc_ell = loc_bow;
%     npts = 1e4; t = linspace(0,2*pi,npts); aspect = [3 3]; % [x y]
%     for j = 1:size(loc_ell,1),
%        x = (18*aspect(2))*cos(t)+loc_ell(j,1); y = (15*aspect(1))*sin(t)+loc_ell(j,2);
%        % display image & ellipse
%        plot(x, y,'k','LineWidth',5);
%     end
%     hold off
end


%% check illuminance
sourcedir = '/Users/iavolman/Library/Mobile Documents/com~apple~CloudDocs/UCL/matlab/EAT/EAT_AAT2/stimuli/RFD/scramble/';

pictures = dir([sourcedir,'*.jpg']);
for i = 1:length(pictures)
    pictName = fullfile(sourcedir, pictures(i).name);
    pict = imread(pictName);
    
    % perceived illuminance
    rgb = mean(mean(pict));
    ill(i) = sqrt( 0.299*rgb(1,1,1)^2 + 0.587*rgb(1,1,2)^2 + 0.114*rgb(1,1,3)^2 );
    %other way
    illuminance(i) = mean(mean(mean(pict)));
end
% perceived illuminance
rgb = mean(mean(img));
ill(3) = sqrt( 0.299*rgb(1,1,1)^2 + 0.587*rgb(1,1,2)^2 + 0.114*rgb(1,1,3)^2 );
%other way
illuminance(3) = mean(mean(mean(img)));


%% equalise illuminance - does not work

l = length(pictures)+1;

luminance = zeros(l-2,1);                       % prepare an array for individual luminance outputs 
for n = 1:l-1;                                    % starting from the 1st pic file
    i = n;
    pictName = fullfile(sourcedir, pictures(i).name);
    im = imread(pictName);
    im_gr = rgb2gray(im);                       % convert RGB into grayscale,which retains the luminance
    luminance(i) = sum(sum(im_gr));             % sum up the individual intensity image, yielding an overall luminance value
end
im_gr = rgb2gray(img);                       % convert RGB into grayscale,which retains the luminance
luminance(l) = sum(sum(im_gr));             % sum up the individual intensity image, yielding an overall luminance value

%lumi_base_real = mean(luminance);               % set up an baseline luminance value by averaging individual overall luminances
lumi_base_real = luminance(3);               % set up an baseline luminance value using original picture (luminance(3))
lumi_base = lumi_base_real*0.8;                % luminance baseline calculated as above is still too bright for some pics (with balck elements) to adjust, thus downscale a little

for n = 1:2;
    i = n;
    pictName = fullfile(sourcedir, pictures(i).name);
    im = imread(pictName); 
    im_gr = rgb2gray(im);
    lumi_indiv = sum(sum(im_gr));               % calculating luminance for an individual pic
    im_adj{n} = im.*(lumi_base/lumi_indiv);        %adjust the values for individual pic by mutipling a factor of (baseline/induvidual luminance)
    %imwrite(im_adj,fullfile(savedir,[pictures(i).name(1:end-4) 'new.jpg']))  %write the new pic file into new set folder (your target directory to store new pic files)
end
im_gr = rgb2gray(img);
    lumi_indiv = sum(sum(im_gr));               % calculating luminance for an individual pic
    im_adj{3} = img.*(lumi_base/lumi_indiv);        %adjust the values for individual pic by mutipling a factor of (baseline/induvidual luminance)
    

%compare the overall luminance changes before and after adjustment.
pic_set_af = dir('/mnt/home14/zhepu/test/stimuli_pic_new'); %here, input the NEW target directory, return pic files into structure array
addpath('/mnt/home14/zhepu/test/stimuli_pic_new');          %here, add the NEW target directory

luminance_af = zeros(1:3,1);                        % prepare an array for new pic luminance outputs 
for n = 1:3;                                        % starting from the 1st pic file
    %i = n-2;
    %file_name_af = pic_set_af(n).name;              % read pic file name into a string variable
    %im_af = imread(file_name_af);                   % read individual pic file
    im_af = im_adj{n};                   % read individual pic file
    im_gr_af = rgb2gray(im_af);                     % convert RGB into grayscale, retaining the luminance
    luminance_af(n) = sum(sum(im_gr_af));           % sum up the individual intensity image, yielding the new pic overall luminance
end

figure
subplot(1,2,1); plot(luminance); axis([0 160 0 200000000]); title('before');    % plot 2 graphs, left: luminance before, right: ;luminance after
subplot(1,2,2); plot(luminance_af); axis([0 160 0 200000000]); title('after');

lumi_base_ppx = lumi_base/(800*600);                                          % calculating baseline luminance per pixel*pixel
im_null = imread('/mnt/home14/zhepu/test/null/null_event.jpg');               % read prest null event pic
im_null_gr = rgb2gray(im_null);                                                
lumi_indiv_null = sum(sum(im_null_gr));                                       % calculating luminace
im_null_adj = im_null.*(lumi_base_ppx*(1024*768)/lumi_indiv_null);            % adjusting luminace by first expanding pic to 1024*768 pixel, then muitiple a factor as logic above
imwrite(im_null_adj,'/mnt/home14/zhepu/test/null/null_event_af.jpg');         % writing new null event event

im_null_af = imread('/mnt/home14/zhepu/test/null/null_event_af.jpg');         % reading and caluclating conveted new null event pic luminace as following
im_null_af_gr = rgb2gray(im_null_af);
lumi_null_af = sum(sum(im_null_af_gr));
[lumi_null_af; lumi_base]




