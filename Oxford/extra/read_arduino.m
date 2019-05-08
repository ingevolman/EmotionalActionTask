clear all;

% set the COM port of the arduino
%s = serial('COM8');
s = serial('COM14');
s.BaudRate = 57600;

% try to engage with the arduino
try
    fopen(s);
catch err
    fclose(instrfind);
    error('Please switch on the arduino and select the correct COM port');
end

%s.ReadAsyncMode = 'continuous';
%readasync(s);

% wait for the first data to come in
%tic
while s.BytesAvailable <= 0, end
%toc

% read the welcome header from the arduino
%tic
hdr = fgetl(s);
while ~strcmpi(hdr(1),'-')
    hdr = fgetl(s);
end
%toc

% get the time stamp for when arduino started by substracting the time from
% the first output line with current time
t_temp = GetSecs();
x = regexp(fgetl(s),'\t','split');
s_starttime = t_temp - (str2double(x{1})/1000);

tline = fgetl(s); % format sprintf('2\t[12]\t247')
if isempty(regexp(tline,'^\d+\t2\t\d{3,4}$', 'once'))
    tline = fgetl(s); % format sprintf('2\t[12]\t247')
end
% second check for just in case when first line was not full and second
% line could therefor be sensor 1
if isempty(regexp(tline,'^\d+\t2\t\d{3,4}$', 'once'))
    tline = fgetl(s); % format sprintf('2\t[12]\t247')
end
% tic
% for i = 1:s.BytesAvailable
% %     if regexp(tline,'^\d+\t2\t\d{3,4}$') % left response
% %     ardu.resp(end+1,1:2) = tline;
% %     elseif regexp(tline,'^\d+\t1\t\d{3,4}$') % right response
% %     end
%     tline = fgetl(s);
% end
% toc
% for both use textscan to make it into an array
%buff = fscanf(s,'%d\t%d\t%d\n', [3 Inf])'; % possibly with an enter at the end \n
s.BytesAvailable
tic
buff = char(fread(s,s.BytesAvailable))';
toc
% combine tline & buff
buff_com=[tline; buff];
% example on how to split on 2 and 1
A = [101 2 123
     102 1 455
     103 2 123
     104 1 455];
Aone = A(2:2:end,[3 1])
Atwo = A(1:2:end,[3 1])


% second option to use.
buff = fread(s,s.BytesAvailable,'*char')';





% % initialize the data
% nSamp = 1000;
% nSens = 2;
% data = nan(nSamp,nSens);

% read the data
% tic
% for c = 1:nSamp
%     %str = fgetl(s);
%     C = regexp(fgetl(s),'\t','split','once');
%     data(c,1) = str2double(C{1});
%     data(c,2) = str2double(C{2});
%     %data(c,:) = fscanf(s,'%d\t%f\n');
% end
% toc
% i = 1;
% 
% temp = regexp(char(fread(s))','\n','split')
% temp2 = cellfun(@(x)regexp(x,'\t','split'),temp,'UniformOutput',false)

% % this is the most recent code for EAT study
% tim_begin = GetSecs();
% check_right_resp = 1;
% temp = cell(20,2);
% flushinput(s);
% while check_right_resp
%     %flushinput(s);
%     tim = GetSecs();
%     %x = regexp(fgetl(s),'\t','split','once');
%     x = regexp(fgetl(s),'\t','split');  % update after changing arduino code to include time
%     if length(x) == 3 && strcmp(x(2),'1')
%         if str2double(x(3)) > 300
%             check_right_resp = 0; disp(tim - tim_begin)
%             disp(str2double(x(3)))
%             disp(x(1))
%         end
%     end
% end

% temp = cell(20,5);
% i = 1;
% for i = 1:40
%     %temp = [temp char(fread(s,5))'];
%     flushinput(s);
%     tim = GetSecs();
%     j = 1;
%     for j = 1:2
%         x = regexp(fgetl(s),'\t','split','once');
%         if strcmp(x(1),'1')
%             temp(i,1) = {tim}; temp(i,2:3) = x;
%         elseif  strcmp(x(1),'2')
%             temp(i,4:5) = x;
%         end
%         j = j+1;
%     end
%     i = i + 1;
% end


% for i = 1:20
% sSerialData = fgetl(s);
% t = strsplit(sSerialData,'\t');
% str2double(t(1))
% str2double(t(2))
% end

fclose(s);
delete(s);
clear s

% data;
% figure
% plot(data(data(:,1)==1,2),'r')
% hold on
% plot(data(data(:,1)==2,2),'b')
% ylim([250,270]);
