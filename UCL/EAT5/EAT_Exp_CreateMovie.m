function EAT_Exp_CreateMovie
%--------------------------------------------------------------------------
% EAT_Exp_CreateMovie: creates a movie of a trial of the "Emotional Action
% Task" based on version 4 of the EAT5 task
%
% Copyright (C) 2017, Inge Volman
% i.volman@ucl.ac.uk
%--------------------------------------------------------------------------

%% default actions

% Clear the workspace and the screen
close all;
%clear;
sca

%% task settings

cfg             = InitializeCfg;
cfg.version     = 1;
cfg.cmp         = 'WindowsXP';
%cfg.cmp         = [];

% Set option flags
cfg.flg.debug   = 0;  % debugging mode
cfg.flg.suppresschecks = 0;     % do I want to suppress all PsychToolbox quality checks?

% enforce script to run on a sytem supporting OpenGL
AssertOpenGL;

%if ~strcmp(cfg.cmp,'WindowsXP')
    PsychDefaultSetup(2); % Here we call some default settings for setting up Psychtoolbox
%end

% script with general settings 
cfg = EAT_BasicSetup(cfg); 
% buffer for setting up visualisation in seconds
cfg.dur.buffer = 0.006;


%% suppresscheck settings

% Screen is able to do a lot of configuration and performance checks on
% open, and will print out a fair amount of detailed information when
% it does. This checking behavior can be suppressed if you would like so.
pref = [];
if cfg.flg.suppresschecks > 0
    % change the testing parameters
    [p1, p2, p3, p4] = Screen('Preference','SyncTestSettings',0.001,50,0.1,5);
    pref.old.SyncTestSettings = num2cell([p1 p2 p3 p4]);
    if cfg.flg.suppresschecks > 1
        % and suppress them completely
        pref.old.SkipSyncTests = Screen('Preference','SkipSyncTests',1);
        pref.old.VisualDebugLevel = Screen('Preference','VisualDebugLevel',3);
        pref.old.SupressAllWarnings = Screen('Preference','SuppressAllWarnings',1);
    end
end


%% initialize variables and variable arrays

% reset the random number generator so that it is different for each matlab startup
rng shuffle;

log = [];
cfg.facedat = 'RFD_faces';
cfg = InitKeyboard(cfg);
cfg = EAT_vars_exp(cfg);
%[cfg, log] = EAT_log_vars(cfg,log);

% always perform CleanUp function, even after an error
obj_cleanup = onCleanup(@() CleanUp(cfg,pref));

% initiate variables
dur_stim         = round(0.2/cfg.dur.frame); % presentation time face in s/flip interval
dur_fix         = 0.2;
dur_feedback    = 1;
stim_count = cell(2,3,2); stim_count(:) = {0}; srt_dep = cell(3,2);
tim_temp        = GetSecs();

% % how to identify timing variables in the logfile
% log.tim.expr = '^T_';


%% Start

% new
moviePtr = Screen('CreateMovie', cfg.h.window, 'EAT5_movie', [],[], cfg.dur.frame);

% Prepare start screen
Screen('FillRect', cfg.h.window, cfg.color.white);
if strcmp(cfg.cmp,'WindowsXP'),   Screen('TextSize', cfg.h.window,20);
else   Screen('TextSize', cfg.h.window,30);
end
str = 'starting...';
[x, y] = CalcTextPos(cfg.h.window, str, cfg.pos.center_x, cfg.pos.center_y);
Screen('DrawText', cfg.h.window, str, x, y, cfg.color.black);

% Present start screen
log.tim.onset = Screen('Flip',cfg.h.window);
% 
% get stimuli
cfg = EAT_PrepStim(cfg);


%% Experiment start

% % present welcome
% cfg = Welcome(cfg);
% 
% % get measurement of maximum force
% cfg = MaxForce(cfg);
% 
% % chance to abort experiment
% [~,~,keycode] = KbCheck;
% if keycode(cfg.key.escape),   disp('experiment aborted')
%     return;
% end
% 
% % present welcome
% cfg = Welcome2(cfg);

%% store data
% % in logfile header
% log = LogHeader(cfg,log);
% 
% % write logfile header
% LogHeaderWrite(log);
% 
% % store fidget (force) data
% log = ForceHeader(cfg,log);
% 
% % write forcefile header
% ForceHeaderWrite(log);
% 
% % introduction
% cfg = Introduction(cfg);


%% loop over training & experiment
for exp = 2:2
%     % set block & trial nummers
%     if exp == 1,   block_nr = cfg.prac.n.block; trl_nr = cfg.prac.n.trialsperblock;
%     else   block_nr = cfg.exp.n.block; trl_nr = cfg.exp.n.trialsperblock;
%     end
    
%     if exp == 2
%         % reset Quest & clear SRT array of previous trial 
%         cfg = ResetQuest(cfg); srt_dep = cell(3,2);
%         
%         % check if fidget response is back to baseline before continuing
%         cfg = Wait_Fdgt_Back(cfg,cfg.color.black,cfg.color.white);
%         
%         % present info for start experiment
%         if strcmp(cfg.cmp,'WindowsXP'),   Screen('TextSize', cfg.h.window,20);
%         else   Screen('TextSize', cfg.h.window,30);
%         end
%         Screen('FillRect', cfg.h.window, cfg.color.white);
%         str1 = 'This was the training'; str2 = 'If you have any remaining questions, please ask them now';
%         str3 = 'Press the left or right button to continue';
%         [x, y] = CalcTextPos(cfg.h.window, str1, cfg.pos.center_x, cfg.pos.center_y-30);
%         Screen('DrawText', cfg.h.window, str1, x, y, cfg.color.black);
%         [x, y] = CalcTextPos(cfg.h.window, str2, cfg.pos.center_x, cfg.pos.center_y+20);
%         Screen('DrawText', cfg.h.window, str2, x, y, cfg.color.black);
%         [x, y] = CalcTextPos(cfg.h.window, str3, cfg.pos.center_x, cfg.pos.center_y+100);
%         Screen('DrawText', cfg.h.window, str3, x, y, cfg.color.black);
%         tim = Screen('Flip', cfg.h.window);
%         
%         % wait response before continuing
%         Wait_Fdgt(cfg); 
%         % check if fidget response is back to baseline before continuing
%         WaitSecs(2); cfg = Wait_Fdgt_Back(cfg,cfg.color.white,cfg.color.black);
%     end
%     
%     % announcement of task start
%     for x = fliplr(1:3)
%         Screen('FillRect', cfg.h.window, cfg.color.black);
%         Screen('DrawTexture', cfg.h.window,cfg.movie(1));
%         str1 = sprintf('The task will start in %d seconds',x);
%         [x, y] = CalcTextPos(cfg.h.window, str1, cfg.pos.center_x, cfg.pos.center_y);
%         Screen('DrawText', cfg.h.window, str1, x, y, cfg.color.white);
%         tim = Screen('Flip', cfg.h.window, tim+1-cfg.dur.buffer );
%     end
%     WaitSecs(1);
%     
    
    %% loop over blocks
    for c = 1:1
        
        % get block type
%         if exp == 1,   cfg.blktype = cfg.prac.block(c);
%         elseif exp == 2,   cfg.blktype = cfg.exp.block(c);
%         end
        % present block instruction
        %[cfg,Tstart_IBI] = Blck_Instr(cfg,exp,c);
        
        
        %% loop over trials
        for t = 1:1
            
             % get trial specifics
             % update counters & variables
             %tr_count = tr_count + 1; 
             count = 1; i = 1;  
%             cfg.fdgt.resp = []; % reset file to store phidget data over trial
%             meas_max    = 0; % measure maximum force between face presentation and end 1st movie
%             max         = [0 0];
%             
%             % get trial info
%             if exp == 1;   side = cfg.prac.side{c}(t); stim = cfg.prac.stim{c}(t); iti = cfg.prac.iti{c}(t);
%             else   side = cfg.exp.side{c}(t); stim = cfg.exp.stim{c}(t); iti = cfg.exp.iti{c}(t);
%             end
            % new
            exp = 2; cfg.blktype= 2; side = 1; stim = 1;
            
            % prepare specifics for face presentation - resize & location
            stim_count{exp,cfg.blktype,stim} = stim_count{exp,cfg.blktype,stim} +1;
            stim_nr = cfg.stim.stim_nr{exp,cfg.blktype,stim}(stim_count{exp,cfg.blktype,stim});
            if cfg.blktype < 3,   size_stim = cfg.stim.size{exp,stim,stim_nr}(1:2);
            else   size_stim = cfg.stim.size{exp,stim+2,stim_nr}(1:2); % to get instrumental stimuli
            end
            if side == 1 % left
                position = [cfg.pos.center_x-size_stim(2) cfg.pos.center_y-(size_stim(1)/2)...
                    cfg.pos.center_x cfg.pos.center_y+(size_stim(1)/2)];
            elseif side == 2 % right
                position = [cfg.pos.center_x cfg.pos.center_y-(size_stim(1)/2)...
                    cfg.pos.center_x+size_stim(2) cfg.pos.center_y+(size_stim(1)/2)];
            end
            
%             % get SRT
%             % get 2nd value of SRT cell - differs for emotional or instrumental conditions
%             if cfg.blktype < 3,    srt_cond = stim; % stim
%             elseif cfg.blktype == 3 && ((cfg.blkInst== 1 && stim ==1) ||(cfg.blkInst== 2 && stim ==2))
%                 srt_cond = 1; % approach
%             elseif cfg.blktype == 3 && ((cfg.blkInst== 1 && stim ==2) ||(cfg.blkInst== 2 && stim ==1))
%                  srt_cond = 2; % avoid
%             end
%             % get SRT value
%             srt = QuestMean(cfg.q{cfg.blktype,srt_cond});
%             % check if new SRT is not an extreme value & adapt if it is
%             if ~isempty(srt_dep{cfg.blktype,srt_cond}) && srt - srt_dep{cfg.blktype,srt_cond} > 0.05   
%                 srt = srt_dep{cfg.blktype,srt_cond} + 0.05;
%             end
%             % assign SRT of trial to the general SRT of this condition
%             srt_dep{cfg.blktype,srt_cond} = srt; 
%               
            % onset of object stimulus based on SRT - rounded to the closest frame.
%             stim_onset  = round(length(cfg.movie)-srt/cfg.dur.frame);
%             if stim_onset < 1   
%                stim_onset = 1; % stim_onset cannot be earlier than first movie frame
%                srt = (length(cfg.movie)-1) * cfg.dur.frame; % if this is the case, update srt to this as well
%             end
              
            % new
            stim_onset = round(length(cfg.movie)-48);
            
            %% Stimulus loop
            
%             % Iti
%             Screen('FillRect', cfg.h.window, cfg.color.black);
%             Screen('DrawTexture', cfg.h.window,cfg.movie(1));
%             tim = Screen('Flip', cfg.h.window);
%             Titi_onset = tim;
%             WaitSecs(iti);
%             
%             % check if fidget response is back to baseline before continuing
%             cfg = Wait_Fdgt_Back(cfg,'maze',cfg.color.white);
%             
            % Present fixation cross
            Screen('FillRect', cfg.h.window, cfg.color.black);
            Screen('DrawTexture', cfg.h.window,cfg.movie(1));
            Screen('DrawLines', cfg.h.window, cfg.allCoords,2, cfg.color.white);
            Tfixation_onset = Screen('Flip', cfg.h.window);
            Screen('AddFrameToMovie', cfg.h.window)
            
            %% start loop within trial
            while count > 0
                
%                 % Get fidget data every 1ms or immediately after stim presentation
%                 if GetSecs() >= tim_temp + 0.001 && count < 5 
%                     cfg = GetPhidget(cfg); tim_temp = GetSecs();
%                 end
%                 
                % Prepare frame of 1st movie
                if count == 1
                    % get stimuli
                    Screen('FillRect', cfg.h.window, cfg.color.black);
                    Screen('DrawTexture', cfg.h.window,cfg.movie(i));
                    if sum(i == stim_onset:stim_onset+dur_stim) % frames with face
                        if cfg.blktype < 3,   Screen('DrawTexture', cfg.h.window,cfg.stim.stim{exp,stim,stim_nr},[],position);
                        else   Screen('DrawTexture', cfg.h.window,cfg.stim.stim{exp,stim+2,stim_nr},[],position); % to get instrumental stimuli
                        end
                    end
                    count = 2;
                    
                % Present frame & get response at end of movie
                elseif count == 2 && ((i == 1 && GetSecs()>=Tfixation_onset+dur_fix-cfg.dur.buffer)||...
                        (i > 1 && GetSecs()>=tim + cfg.dur.frame - cfg.dur.buffer))
                    % show stimuli
                    tim = Screen('Flip', cfg.h.window);
                    Screen('AddFrameToMovie', cfg.h.window)
            
                    % assign correct timing variables
                    if i == 1,   Tmovie_start = tim;   end % beginning movie
                    if i == stim_onset,   Tstim_onset = tim; % start face trials
                    elseif i == stim_onset+dur_stim,   Tstim_offset = tim; % end face trials
                    end
                    if i == length(cfg.movie),   Tmovie_offset = tim;   end % end movie
                    
                    % get response
                    if i == length(cfg.movie)   
                        %cfg = GetResp(cfg,Tstim_onset);
                        cfg.resp = 1; cfg.noresp = 0; % new
                        % get specifics of 2nd movie
                        if cfg.resp == 1,   movie2 = cfg.movie_left; 
                        elseif cfg.resp == 2,   movie2 = cfg.movie_right;
                        end
                        if cfg.noresp,   force_stamp = length(cfg.fdgt.resp);   end % get start extra force measurements
                        % get direction of movie for logfile & go to second movie & start new movie counter
                        cfg.movdir = cfg.resp; count = 3; j = 1;
                    else   count = 1; i = i +1; % go back to present next movie1 frame
                    end
                    
                % Prepare frame of 2nd movie
                elseif count == 3
                    Screen('FillRect', cfg.h.window, cfg.color.black); 
                    Screen('DrawTexture', cfg.h.window,movie2(j));
                    count = 4;
                    
                % Present frame
                elseif count == 4 && (GetSecs()>=tim + cfg.dur.frame - cfg.dur.buffer)
                    tim = Screen('Flip', cfg.h.window);
                    Screen('AddFrameToMovie', cfg.h.window)
                    
                    if j == 1,   Tmovie2_start = tim;   end
                    if j == length(movie2),   count = 5; % end of movie2 frames
                    else   count = 3; j = j +1; % go back to present next movie2 frame
                    end
                    
                % Prepare feedback
                elseif count == 5
                    % test for late response
                    if cfg.noresp,   stamp = cfg.fdgt.resp(force_stamp:length(cfg.fdgt.resp),:);
                        for s = 1:length(stamp)
                            if stamp(s,1) > cfg.respthr || stamp(s,3) > cfg.respthr,   cfg.noresp = 2;   end
                        end
                    end
                    
                    % get correct movement based on blocktype x stimulus x
                    % side (and for blocktype 3 also instrumental options)
                    if (cfg.blktype == 1 && stim == 1) || (cfg.blktype == 2 && stim == 2) ||...
                            (cfg.blktype == 3 && cfg.blkInst == 1 && stim == 1)||...
                            (cfg.blktype == 3 && cfg.blkInst == 2 && stim == 2)
                        corr_resp = side;
                    elseif (cfg.blktype == 1 && stim == 2) || (cfg.blktype == 2 && stim == 1) ||...
                            (cfg.blktype == 3 && cfg.blkInst == 1 && stim == 2)||...
                            (cfg.blktype == 3 && cfg.blkInst == 2 && stim == 1)
                        corr_resp = abs(side-2)+1; % the other side as picture presentation was correct
                    end
                    
                    % preload screen
                    Screen('FillRect', cfg.h.window, cfg.color.black);
                    Screen('DrawTexture',cfg.h.window,movie2(j));
                    if strcmp(cfg.cmp,'WindowsXP'),   Screen('TextSize', cfg.h.window,20);
                    else   Screen('TextSize', cfg.h.window,30);
                    end
                    if cfg.noresp ==1,   str1 = 'No response'; str2 = 'Arbitrary side choosen'; corr = 0;
                        [x, y] = CalcTextPos(cfg.h.window, str1, cfg.pos.center_x, cfg.pos.center_y-20);
                        Screen('DrawText', cfg.h.window, str1, x, y, cfg.color.red);
                        [x, y] = CalcTextPos(cfg.h.window, str2, cfg.pos.center_x, cfg.pos.center_y+20);
                        Screen('DrawText', cfg.h.window, str2, x, y, cfg.color.red);
                    elseif cfg.noresp ==2,   str1 = 'Too late'; str2 = 'Arbitrary side choosen'; corr = 0; 
                        [x, y] = CalcTextPos(cfg.h.window, str1, cfg.pos.center_x, cfg.pos.center_y-20);
                        Screen('DrawText', cfg.h.window, str1, x, y, cfg.color.red);
                        [x, y] = CalcTextPos(cfg.h.window, str2, cfg.pos.center_x, cfg.pos.center_y+20);
                        Screen('DrawText', cfg.h.window, str2, x, y, cfg.color.red);
                    elseif cfg.resp == corr_resp,   str1 = 'Correct'; corr = 1; 
                        [x, y] = CalcTextPos(cfg.h.window, str1, cfg.pos.center_x, cfg.pos.center_y);
                        Screen('DrawText', cfg.h.window, str1, x, y, cfg.color.green);
                    else   str1 = 'Wrong'; corr = 0;
                        [x, y] = CalcTextPos(cfg.h.window, str1, cfg.pos.center_x, cfg.pos.center_y);
                        Screen('DrawText', cfg.h.window, str1, x, y, cfg.color.red);
                    end
                    
                    count = 6;
                    
                % Present feedback
                elseif count == 6 && (GetSecs()>=tim + cfg.dur.frame - cfg.dur.buffer)
                    Tfeedback = Screen('Flip', cfg.h.window); count = 0; tim = WaitSecs(dur_feedback);
                    Screen('AddFrameToMovie', cfg.h.window)
            
                end
            end
            
%             % write to log - TODO add force of movement in other direction
%             log = LogData(cfg,log,tr_count,'blockInst',cfg.blkInst);
%             log = LogData(cfg,log,tr_count,'stim_nr',stim_nr);
%             log = LogData(cfg,log,tr_count,'T_fixation_onset',Tfixation_onset);
%             log = LogData(cfg,log,tr_count,'T_movie_start',Tmovie_start);
%             log = LogData(cfg,log,tr_count,'T_stim_onset',Tstim_onset);
%             log = LogData(cfg,log,tr_count,'T_stim_offset',Tstim_offset);
%             log = LogData(cfg,log,tr_count,'T_movie_offset',Tmovie_offset);
%             log = LogData(cfg,log,tr_count,'T_movie2_start',Tmovie2_start);
%             log = LogData(cfg,log,tr_count,'T_feedback',Tfeedback);
%             log = LogData(cfg,log,tr_count,'T_start_ITI',Titi_onset);
%             log = LogData(cfg,log,tr_count,'T_start_IBI',Tstart_IBI);
%             log = LogData(cfg,log,tr_count,'SRT',srt);
%             log = LogData(cfg,log,tr_count,'corr',corr);
%             log = LogData(cfg,log,tr_count,'no_resp',cfg.noresp);
%             log = LogData(cfg,log,tr_count,'resp',cfg.resp);
%             log = LogData(cfg,log,tr_count,'force',cfg.fdgt.force);
%             
%             % Write this trial to the logfile on the hard-disk
%             LogDataWriteTrial(log,tr_count); ForceDataWriteTrial(log,exp,c,t,srt,cfg);
%             
%             % update SRT
% OLD            %cfg.q{cfg.blktype,stim} = QuestUpdate(cfg.q{cfg.blktype,stim},srt,corr);
%             cfg.q{cfg.blktype,srt_cond} = QuestUpdate(cfg.q{cfg.blktype,srt_cond},srt,corr);
            
%             % set Tstart_IBI for non IBI trials
%             Tstart_IBI  = 0;
            
            % give user a chance to abort the test by pressing escape key
            [~,~,keycode] = KbCheck;
            if keycode(cfg.key.escape),   disp('experiment aborted')
                return;
            end
        end
        if keycode(cfg.key.escape),   disp('experiment aborted')
            return;
        end
        
%         % reset Quest after all 3 blocks (each of other type)
%         if ~mod(c,3)
%             cfg = ResetQuest_block(cfg);
%         end
        
    end
end
Screen('FinalizeMovie', moviePtr);

% Screen('FillRect',cfg.h.window, cfg.color.white);
% [x, y] = CalcTextPos(cfg.h.window, 'End', cfg.pos.center_x, cfg.pos.center_y);
% Screen('DrawText', cfg.h.window, 'End',x,y, cfg.color.black);
% texp_end = Screen('Flip',cfg.h.window);
% WaitSecs(2);


%% end
%CleanUp(cfg,pref); % otherwise it is done twice, becuase automatically
%done at end


%% functions

function [cfg,Tstart_IBI] = Blck_Instr(cfg,exp,c)

% breaks
Screen('FillRect', cfg.h.window, cfg.color.white);
if exp == 2 && ~mod(c-1,5) && c > 1
    str1 = sprintf(' You are at %i/%i of the task. You have a 30 seconds break',(c-1)/5,cfg.exp.n.block/5 );
    [x, y] = CalcTextPos(cfg.h.window, str1, cfg.pos.center_x, cfg.pos.center_y);
    Screen('DrawText', cfg.h.window, str1, x, y, cfg.color.black);
    Tstart_break = Screen('Flip', cfg.h.window);
    WaitSecs(30);
end

% block information
Screen('FillRect', cfg.h.window, cfg.color.white);
if cfg.blktype == 1,   str1 = 'Move in the same direction'; str2 = 'as the happy face.';
    str3 = 'Move in the opposite direction'; str4 = 'to the angry face.';
    cfg.blkInst = 0;
elseif cfg.blktype == 2,   str1 = 'Move in the same direction'; str2 = 'as the angry face.';
    str3 = 'Move in the opposite direction'; str4 = 'to the happy face.';
    cfg.blkInst = 0;
elseif cfg.blktype == 3 && ((exp == 1 && cfg.prac.blkInst(find(cfg.prac.block ==3)==c)==1) ||...  
        (exp == 2 && cfg.exp.blkInst(find(cfg.exp.block ==3)==c)==1))
    str1 = 'Move in the same direction'; str2 = 'as the stimulus with horizontal bow tie.';
    str3 = 'Move in the opposite direction'; str4 = 'to the stimulus with vertical bow tie.';
    cfg.blkInst = 1;
elseif cfg.blktype == 3 && ((exp == 1 && cfg.prac.blkInst(find(cfg.prac.block ==3)==c)==2)  ||...  
        (exp == 2 && cfg.exp.blkInst(find(cfg.exp.block ==3)==c)==2))   
    str1 = 'Move in the same direction'; str2 = 'as the stimulus with vertical bow tie.';
    str3 = 'Move in the opposite direction'; str4 = 'to the stimulus with horizontal bow tie.';
    cfg.blkInst = 2;
end
str6 = 'Press the left or right button to continue';
[x, y] = CalcTextPos(cfg.h.window, str1, cfg.pos.center_x, cfg.pos.center_y-60);
Screen('DrawText', cfg.h.window, str1, x, y, cfg.color.black);
[x, y] = CalcTextPos(cfg.h.window, str2, cfg.pos.center_x, cfg.pos.center_y-20);
Screen('DrawText', cfg.h.window, str2, x, y, cfg.color.black);
[x, y] = CalcTextPos(cfg.h.window, str3, cfg.pos.center_x, cfg.pos.center_y+20);
Screen('DrawText', cfg.h.window, str3, x, y, cfg.color.black);
[x, y] = CalcTextPos(cfg.h.window, str4, cfg.pos.center_x, cfg.pos.center_y+60);
Screen('DrawText', cfg.h.window, str4, x, y, cfg.color.black);
[x, y] = CalcTextPos(cfg.h.window, str6, cfg.pos.center_x, cfg.pos.center_y+120);
Screen('DrawText', cfg.h.window, str6, x, y, cfg.color.black);
Tstart_IBI = Screen('Flip', cfg.h.window);

% wait response
Wait_Fdgt(cfg);

% check if fidget response is back to baseline before continuing
WaitSecs(0.5);
cfg = Wait_Fdgt_Back(cfg,cfg.color.white,cfg.color.black);

function [x, y] = CalcTextPos(h,str,x0,y0)
%% xc, yc is the geometric center of the text
textbox = Screen('TextBounds', h, str);
[x, y] = RectCenter(textbox);
x = x0-x; y = y0-y;

function CleanUp(cfg,pref)
%% CleanUp
%------------------------
if nargin < 1, cfg.h = []; end
if nargin < 2, pref = []; end

% enable keyboard for Matlab
ListenChar(0);

% close phidget
%calllib('phidget21', 'CPhidget_close', cfg.fdgt.phid);
%calllib('phidget21', 'CPhidget_delete', cfg.fdgt.phid);

% close and release cue
KbQueueStop(cfg.h.keyboard);
KbQueueRelease(cfg.h.keyboard);

% Shutdown realtime scheduling
Priority(0);

% Close window and restore cursor and other settings
sca;

% close all visible and hidden ports
IOPort('CloseAll');
if ~isempty(instrfindall), fclose(instrfindall); end

% restore preferences
if ~isempty(pref)
    if isfield(pref.old,'SyncTestSettings')
        Screen('Preference','SyncTestSettings',pref.old.SyncTestSettings{:});
    end
    if isfield(pref.old,'SkipSyncTests')
        Screen('Preference','SkipSyncTests',pref.old.SkipSyncTests);
        Screen('Preference','VisualDebugLevel',pref.old.VisualDebugLevel);
        Screen('Preference','SuppressAllWarnings',pref.old.SupressAllWarnings);
    end
end

function ForceDataWriteTrial(log,exp,c,trial,srt,cfg)
%% ForceDataWrite
%------------------------
format long g % to remove the floating data annotation and show to complete number

% filename for the actual data
fname = sprintf('forcefile_%s.txt',log.subjname);
fname = fullfile(log.path,fname);

% write the actual data
str = [];
str = sprintf('%s---- exp: %d --- block_nr: %d --- trial_nr: %d --- SRT: %.6f -------\n',str,exp,c,trial,srt);
resp = cfg.fdgt.resp';
for i = 1:length(resp); str = sprintf('%s%d\t',str,resp(1,i)); end
str = sprintf('%s\n',str);
for i = 1:length(resp); str = sprintf('%s%.6f\t',str,resp(2,i)); end
str = sprintf('%s\n',str);
for i = 1:length(resp); str = sprintf('%s%d\t',str,resp(3,i)); end
str = sprintf('%s\n',str);
for i = 1:length(resp); str = sprintf('%s%.6f\t',str,resp(4,i)); end
str = sprintf('%s\n',str);

dlmwrite(fname,str,'-append','delimiter','');

function log = ForceHeader(cfg,log)
%% ForceHeader
%------------------------
format long g % to remove the floating data annotation and show to complete number

str = '';
str = sprintf('%sDate: %s\n',str,datestr(now));
str = sprintf('%sExperiment: Emotional action task AAT2\n',str);
str = sprintf('%sVersion: %.2f\n',str,cfg.version);
str = sprintf('%sSubject: %s\n',str,cfg.subjname);
str = sprintf('%sTime start fidget: %.6f\n',str,cfg.fdgt.t_start);
str = sprintf('%sForce measurements left: %d, %d, %d, %d, %d\n',str,cfg.fdgt.maxleft(1),...
    cfg.fdgt.maxleft(2),cfg.fdgt.maxleft(3),cfg.fdgt.maxleft(4),cfg.fdgt.maxleft(5));
str = sprintf('%sForce measurements right: %d, %d, %d, %d, %d\n',str,cfg.fdgt.maxright(1),...
    cfg.fdgt.maxright(2),cfg.fdgt.maxright(3),cfg.fdgt.maxright(4),cfg.fdgt.maxright(5));
str = sprintf('%sForce threshold: %d\n',str,cfg.respthr);
str = sprintf('%sTime startup: %.6f\n',str,log.tim.onset);
str = sprintf('%sTime of start Experiment: %.6f\n\n',str,cfg.Texp_beg);
str = sprintf('%s======================================================\n',str);

% store in log structure
log.forceheader = str;

function ForceHeaderWrite(log)
%% ForceHeaderWrite
%------------------------
% filename for the header
fname = sprintf('forcefile_%s.txt',log.subjname);
fname = fullfile(log.path,fname);

% write the header
fid = fopen(fname,'w');
fprintf(fid,'%s',log.forceheader);
fclose(fid);

function cfg = GetPhidget(cfg)

temp  = zeros(length(cfg.fdgt.Resp_button),2);

smp = 1;
for i = 1:length(cfg.fdgt.Resp_button);
    button = cfg.fdgt.Resp_button(i); % i.e. it is now 2 & 4, other phidget it is 3-4
    %if calllib('phidget21', 'CPhidgetInterfaceKit_getSensorValue', cfg.fdgt.phid, button, cfg.fdgt.dataptr1)== 0;
    if calllib('phidget21', 'CPhidgetInterfaceKit_getSensorRawValue', cfg.fdgt.phid, button, cfg.fdgt.dataptr1)== 0;
        tim = GetSecs() - cfg.Texp_beg;
        temp(smp,:) = [double(cfg.fdgt.dataptr1.Value) tim]; % first becomes a dubble to save time string appropriately
    else
        calllib('phidget21', 'CPhidget_close', phid);        
        calllib('phidget21', 'CPhidget_delete', phid);
        error('Error getting data..');
    end
    smp = smp+1;
end
cfg.fdgt.resp(size(cfg.fdgt.resp,1)+1,:) = [temp(1,:) temp(2,:)];

function  cfg = GetResp(cfg,Tstim_onset)
%% measure movement response
% get most recent value
cfg = GetPhidget(cfg);
  
% get left & right movements
idx_mov = find(cfg.fdgt.resp(:,2) > Tstim_onset- cfg.Texp_beg+0.15);

% check which one was highest at the lastest possible moment
resp = 0;
for i = fliplr(1:length(idx_mov))
    if cfg.fdgt.resp(idx_mov(i),1) > cfg.respthr && cfg.fdgt.resp(idx_mov(i),1) > cfg.fdgt.resp(idx_mov(i),3) % left & larger than right
        cfg.resp = 1; cfg.noresp = 0; cfg.fdgt.force = max(cfg.fdgt.resp(idx_mov,1)); resp = 1; break
    elseif cfg.fdgt.resp(idx_mov(i),3) > cfg.respthr && cfg.fdgt.resp(idx_mov(i),3) > cfg.fdgt.resp(idx_mov(i),1) %right and larger than left
        cfg.resp = 2; cfg.noresp = 0; cfg.fdgt.force = max(cfg.fdgt.resp(idx_mov,3)); resp = 1; break
    end
end
if resp == 0 % randomly choose left or right key for random response, because either no resp above threshold or responses had same height
    cfg.noresp = 1; cfg.fdgt.force = 0;
    if randperm(2,1) == 1;   cfg.resp = 1;
    else   cfg.resp = 2;
    end
end

% % check which one was earlier and assign variables
% if (~isempty(left) && ~isempty(right) && left(1) < right(1)) || (~isempty(left) && isempty(right)) % left response
%     cfg.resp = 1; cfg.noresp = 0; cfg.fdgt.force = max(cfg.fdgt.resp(idx_mov(left),1));
% elseif   (~isempty(left) && ~isempty(right) && right(1) < left(1)) || ~isempty(right) % right response
%     cfg.resp = 2; cfg.noresp = 0; cfg.fdgt.force = max(cfg.fdgt.resp(idx_mov(right),3));
% else % randomly choose left or right key for random response
%     cfg.noresp = 1; cfg.fdgt.force = 0;
%     if randperm(2,1) == 1;   cfg.resp = 1;
%     else   cfg.resp = 2;
%     end
% end

function cfg = InitializeCfg
%% InitializeCfg
%------------------------
% initialize
cfg.quit = [];

% subject name
prompt = {'Please enter the subject name/code.'};
dlg_title = 'input'; num_lines = 1; default_ans = {''};
answer = inputdlg(prompt,dlg_title,num_lines,default_ans);
cfg.subjname = answer{1};

% check for duplicate subject ID
fileName=['logfile_' num2str(cfg.subjname) '.txt'];
if exist(fullfile('logfile',fileName),'file')
    if ~IsOctave
        resp=questdlg({['the file ' fileName ' already exists']; 'do you want to overwrite it?'},...
            'duplicate warning','no','ok','ok');
    else
        resp=input(['the file ' fileName ' already exitsts. do you want to overwrite it? [Type ok for overwrite]'],'s');
    end
    
    if ~strcmp(resp,'ok') % abort experiment if overwriting was not confirmed
        cfg.quit = 'yes'; disp('experiment aborted')
        return
    end
end

function cfg = InitKeyboard(cfg) 
%% Initialize keyboard settings
%------------------------
% start a keyboard queue to record the key presses and releases
cfg.h.keyboard = [];
cfg.h.keyboard = StartKeyBoardQueue(cfg.h.keyboard); 

% make sure that keynaming is similar across all operating systems
KbName('UnifyKeyNames');
% set target keys
cfg.key.escape      = KbName('ESCAPE');
cfg.key.left        = KbName('LeftArrow');
cfg.key.right       = KbName('RightArrow');

function cfg = InitPhidget(cfg)
%% Configure phidget
loadphidget21              % loads phidget library

cfg.fdgt.DataRate       = 8;                % phidget data rate (8 is precise, try playing around)
cfg.fdgt.totalbuttons   = 4;                % total number of buttons on phidget button box 
cfg.fdgt.Resp_button    = [3 2]; %[3 4];    % response buttons used - left, right

cfg.fdgt.phid = libpointer('int32Ptr');
calllib('phidget21', 'CPhidgetInterfaceKit_create', cfg.fdgt.phid);
calllib('phidget21', 'CPhidget_open', cfg.fdgt.phid, -1);
cfg.fdgt.t_start = GetSecs();

if calllib('phidget21', 'CPhidget_waitForAttachment', cfg.fdgt.phid, 500) == 0
    cfg.fdgt.dataptr1 = libpointer('int32Ptr', 0);
    for n1 = 1:cfg.fdgt.totalbuttons
        calllib('phidget21', 'CPhidgetInterfaceKit_setDataRate', cfg.fdgt.phid, n1, cfg.fdgt.DataRate); % Can adjust data rate but at default samples at 8 ms - 8 is precise, try playing around
    end
else
    calllib('phidget21', 'CPhidget_close', cfg.fdgt.phid);
    calllib('phidget21', 'CPhidget_delete', cfg.fdgt.phid);
    error('Could not open InterfaceKit');
end

function log = LogData(cfg,log,t,varname,x) 
%% LogData
%------------------------
idx = ismember(log.vars,varname);
if ~any(idx),   warning('variable name not recognized');    end

% adjust timing if needed
if ~isempty(regexp(varname,log.tim.expr,'once')) == 1 && x > 0
    x = x - cfg.Texp_beg;
end

% store x in data matrix
log.data(t,idx) = x;

function LogDataWriteTrial(log,t)
%% LogDataWrite
%------------------------
% take only the current trial
data = log.data(t,:);

% filename for the actual data
fname = sprintf('logfile_%s.txt',log.subjname);
fname = fullfile(log.path,fname);

% write the actual data
str = [];
for i = 1:length(data)
    if (data(i)-fix(data(i))) >0
        str = sprintf('%s%.6f\t',str,data(i));
    else   str = sprintf('%s%d\t',str,data(i));
    end
end
dlmwrite(fname,str,'-append','delimiter','');

function log = LogHeader(cfg,log)
%% LogHeader
%------------------------
format long g % to remove the floating data annotation and show to complete number

str = '';
str = sprintf('%sDate: %s\n',str,datestr(now));
str = sprintf('%sExperiment: Emotional action task - AAT2\n',str);
str = sprintf('%sVersion: %.2f\n',str,cfg.version);
str = sprintf('%sSubject: %s\n',str,cfg.subjname);
str = sprintf('%sTime startup: %.6f\n',str,log.tim.onset);
str = sprintf('%sTime of start Experiment: %.6f\n\n',str,cfg.Texp_beg);
str = sprintf('%s======================================================\n',str);

% add log.vars
temp = sprintf('%s\t',log.vars{:});
str = sprintf('%s%s\t',str,temp);
str = sprintf('%s\n\n',str);

% store in log structure
log.header = str;

function LogHeaderWrite(log)
%% LogHeaderWrite
%------------------------
% filename for the header
fname = sprintf('logfile_%s.txt',log.subjname);
fname = fullfile(log.path,fname);

% write the header
fid = fopen(fname,'w');
fprintf(fid,'%s',log.header);
fclose(fid);

function cfg = MaxForce(cfg)
%% Max force measurement
if strcmp(cfg.cmp,'WindowsXP');   Screen('TextSize', cfg.h.window,20);
else   Screen('TextSize', cfg.h.window,30);
end
Screen('FillRect', cfg.h.window, cfg.color.white);
str1 = 'Hold down both buttons and press as hard as possible'; str2 = 'for 3 seconds.';
str3 = 'This will be repeated 5 times'; str4 = 'Press a button to start';
[x, y] = CalcTextPos(cfg.h.window, str1, cfg.pos.center_x, cfg.pos.center_y-60);
Screen('DrawText', cfg.h.window, str1, x, y, cfg.color.black);
[x, y] = CalcTextPos(cfg.h.window, str2, cfg.pos.center_x, cfg.pos.center_y-20);
Screen('DrawText', cfg.h.window, str2, x, y, cfg.color.black);
[x, y] = CalcTextPos(cfg.h.window, str3, cfg.pos.center_x, cfg.pos.center_y+20);
Screen('DrawText', cfg.h.window, str3, x, y, cfg.color.black);
[x, y] = CalcTextPos(cfg.h.window, str4, cfg.pos.center_x, cfg.pos.center_y+100);
Screen('DrawText', cfg.h.window, str4, x, y, cfg.color.black);

% Wait for a flip to synchronize clock with the screen and clock time begin experiment
tim = Screen('Flip',cfg.h.window);
% wait response
Wait_Fdgt(cfg); %WaitSecs(0.5); Wait_Fdgt_Back(cfg,cfg.color.white,cfg.color.black);

for i = 1:5
    tim_passed = 0; force = [0 0]; cfg.fdgt.resp = []; % clear fidget string
    % start screen
    str1 = sprintf('Time passed: %.2f s.',tim_passed); 
    str2 = sprintf('Force: %d and %d',force(1),force(2));
    str4 = 'Press a button to start';
    [x, y] = CalcTextPos(cfg.h.window, str1, cfg.pos.center_x, cfg.pos.center_y-50);
    Screen('DrawText', cfg.h.window, str1, x, y, cfg.color.black);
    [x, y] = CalcTextPos(cfg.h.window, str2, cfg.pos.center_x, cfg.pos.center_y+50);
    Screen('DrawText', cfg.h.window, str2, x, y, cfg.color.black);
    [x, y] = CalcTextPos(cfg.h.window, str4, cfg.pos.center_x, cfg.pos.center_y+100);
    Screen('DrawText', cfg.h.window, str4, x, y, cfg.color.black);
    tim = Screen('Flip',cfg.h.window);
    
    Wait_Fdgt(cfg);
    tim_start = GetSecs();
    
    while GetSecs()< tim_start+3
        cfg = GetPhidget(cfg);
        Screen('FillRect', cfg.h.window, cfg.color.white);
        tim_passed = GetSecs() - tim_start + 0.01;
        str1 = sprintf('Time passed: %.2f s.',tim_passed);
        force = [cfg.fdgt.resp(end,1) cfg.fdgt.resp(end,3)];
        str2 = sprintf('Force: %d and %d',force(1),force(2));
        [x, y] = CalcTextPos(cfg.h.window, str1, cfg.pos.center_x, cfg.pos.center_y-50);
        Screen('DrawText', cfg.h.window, str1, x, y, cfg.color.black);
        [x, y] = CalcTextPos(cfg.h.window, str2, cfg.pos.center_x, cfg.pos.center_y+50);
        Screen('DrawText', cfg.h.window, str2, x, y, cfg.color.black);
        tim = Screen('Flip',cfg.h.window);
    end
    cfg.fdgt.maxleft(i) = max(cfg.fdgt.resp(:,1));
    cfg.fdgt.maxright(i) = max(cfg.fdgt.resp(:,3));
    
    Screen('FillRect', cfg.h.window, cfg.color.white);
    str4 = 'Measurement done, release buttons';
    [x, y] = CalcTextPos(cfg.h.window, str4, cfg.pos.center_x, cfg.pos.center_y+60);
    Screen('DrawText', cfg.h.window, str4, x, y, cfg.color.black);
    tim = Screen('Flip',cfg.h.window);
    WaitSecs(0.5)
    Wait_Fdgt_Back(cfg,cfg.color.white,cfg.color.black);
end
% get threshold based on force measurements
cfg.respthr = round(0.04*max([cfg.fdgt.maxleft cfg.fdgt.maxright]));

function cfg = ResetQuest(cfg)
%% Reset Quest - create prior based on mean SRTs 
% if length(size(cfg.q)) ~=3
%     print('length q does not match resetting variables for Quest');
% end
% complicated way to get new tGuess is commented out - based on
% functionality of QuestMean & leads to exactly same result as other way.
% mean_var1 = []; mean_var2 = [];
mean_all = []; beta_all = [];
for i = 1:size(cfg.q,1)
    for j = 1:size(cfg.q,2)
        %    mean_var1 =[mean_var1 cfg.q{i,j,k}.pdf.*cfg.q{i,j,k}.x]; mean_var2 =[mean_var2 cfg.q{i,j,k}.pdf];
        mean_all = [mean_all QuestMean(cfg.q{i,j})];
        beta_all = [beta_all QuestBetaAnalysis(cfg.q{i,j})]; 
    end
end
% tGuess = cfg.q{i,j,k}.tGuess + sum(mean_var1)/sum(mean_var2);
tGuess = mean(mean_all); %beta = mean(beta_all); % if I want to reset the beta based on training

tGuessSd = 0.7;  % keep large to avoid getting stuck in local minimum
pThreshold = 0.7; % threshold correct/incorrect.
%beta = 6.6; % following solution from simulation
beta = 3.5; % following suggestion by Quest create script
delta = 0.01; % fraction of trials on which pp presses blindly, I followed script.
gamma = 0.5; % fraction of trials that generate response 1 when intensity == -inf, here would be chance.
for i = 1:size(cfg.q,1)
    for j = 1:size(cfg.q,2)
        cfg.q{i,j} = QuestCreate(tGuess,tGuessSd,pThreshold,beta,delta,gamma); 
    end
end

function cfg = ResetQuest_block(cfg)
%% Reset Quest - create prior based on mean SRTs 
% if length(size(cfg.q)) ~=3
%     print('length q does not match resetting variables for Quest');
% end
% complicated way to get new tGuess is commented out - based on
% functionality of QuestMean & leads to exactly same result as other way.
% mean_var1 = []; mean_var2 = [];

tGuessSd = 0.7;  % keep large to avoid getting stuck in local minimum
pThreshold = 0.7; % threshold correct/incorrect.
delta = 0.01; % fraction of trials on which pp presses blindly, I followed script.
gamma = 0.5; % fraction of trials that generate response 1 when intensity == -inf, here would be chance.
beta = 3.5; % following suggestion by Quest create script

for i = 1:size(cfg.q,1)
    for j = 1:size(cfg.q,2)
        tGuess = QuestMean(cfg.q{i,j});
        %beta = QuestBetaAnalysis(cfg.q{i,j}); 
        cfg.q{i,j} = QuestCreate(tGuess,tGuessSd,pThreshold,beta,delta,gamma); 
    end
end

function keyboard = StartKeyBoardQueue(keyboard) % from CP script of Lennart Verhagen
%% StartKeyBoardQueue
%------------------------
if nargin < 1, keyboard = []; end
% initialize cue
KbQueueCreate(keyboard);
% start recording
KbQueueStart(keyboard);

function cfg = Wait_Fdgt(cfg)
%% wait for fidget response
cfg.fdgt.resp = []; % clear fidget string
while isempty(cfg.fdgt.resp)
    cfg = GetPhidget(cfg);
    if ~isempty(cfg.fdgt.resp) && cfg.fdgt.resp(1) < cfg.respthr &&...
            cfg.fdgt.resp(3) < cfg.respthr
        cfg.fdgt.resp = [];
    end
end

function cfg = Wait_Fdgt_Back(cfg,col1,col2)
cfg.fdgt.resp = []; % clear fidget string
fst_meas = 1;
while isempty(cfg.fdgt.resp)
    cfg = GetPhidget(cfg);
    if ~isempty(cfg.fdgt.resp) && (cfg.fdgt.resp(1) > cfg.zerothr ||...
            cfg.fdgt.resp(3) > cfg.zerothr)
        if fst_meas
            % release button
            if strcmp(cfg.cmp,'WindowsXP');   Screen('TextSize', cfg.h.window,20);
            else   Screen('TextSize', cfg.h.window,30);
            end
            if strcmp(col1,'maze');   Screen('DrawTexture', cfg.h.window,cfg.movie(1));
            else   Screen('FillRect', cfg.h.window, col1);
            end
            str1 = 'Please release the button';
            [x, y] = CalcTextPos(cfg.h.window, str1, cfg.pos.center_x, cfg.pos.center_y);
            Screen('DrawText', cfg.h.window, str1, x, y, col2);
            tim = Screen('Flip', cfg.h.window);
            WaitSecs(0.05);
            fst_meas = 0;
        end
        cfg.fdgt.resp = [];
    end
end
WaitSecs(0.5);

function cfg = Welcome(cfg)
%% Prepare welcome
if strcmp(cfg.cmp,'WindowsXP');   Screen('TextSize', cfg.h.window,15);
else   Screen('TextSize', cfg.h.window,20);
end
Screen('FillRect', cfg.h.window, cfg.color.white);
str1 = 'Welcome to this experiment'; str2 = 'You will first start with a force measurement';
str3 = 'Press the left or right arrow to start';
[x, y] = CalcTextPos(cfg.h.window, str1, cfg.pos.center_x, cfg.pos.center_y-60);
Screen('DrawText', cfg.h.window, str1, x, y, cfg.color.black);
[x, y] = CalcTextPos(cfg.h.window, str2, cfg.pos.center_x, cfg.pos.center_y-20);
Screen('DrawText', cfg.h.window, str2, x, y, cfg.color.black);
[x, y] = CalcTextPos(cfg.h.window, str3, cfg.pos.center_x, cfg.pos.center_y+20);
Screen('DrawText', cfg.h.window, str3, x, y, cfg.color.black);

% Wait for a flip to synchronize clock with the screen and clock time begin experiment
tim = Screen('Flip',cfg.h.window); cfg.Texp_beg = tim;

% wait for keypress
KbWait(-1,2);

function cfg = Welcome2(cfg)
%% Prepare welcome
if strcmp(cfg.cmp,'WindowsXP');   Screen('TextSize', cfg.h.window,15);
else   Screen('TextSize', cfg.h.window,20);
end
Screen('FillRect', cfg.h.window, cfg.color.white);
str1 = 'That was the force measurement'; str2 = 'Next will be an introduction to the main experiment';
str3 = 'Press one of the buttons to start';
[x, y] = CalcTextPos(cfg.h.window, str1, cfg.pos.center_x, cfg.pos.center_y-60);
Screen('DrawText', cfg.h.window, str1, x, y, cfg.color.black);
[x, y] = CalcTextPos(cfg.h.window, str2, cfg.pos.center_x, cfg.pos.center_y-20);
Screen('DrawText', cfg.h.window, str2, x, y, cfg.color.black);
[x, y] = CalcTextPos(cfg.h.window, str3, cfg.pos.center_x, cfg.pos.center_y+20);
Screen('DrawText', cfg.h.window, str3, x, y, cfg.color.black);

% Wait for a flip to synchronize clock with the screen and clock time begin experiment
tim = Screen('Flip',cfg.h.window);

% % wait for keypress
% KbWait(-1,2);
% wait response
Wait_Fdgt(cfg); WaitSecs(0.5); Wait_Fdgt_Back(cfg,cfg.color.white,cfg.color.black);


function cfg = Introduction(cfg)
%% introduction
count = 0; delay = 8; tim = GetSecs();
while count < 5
    % show 1st movie
    for i = 1:length(cfg.movie)
        % get stimuli
        Screen('FillRect', cfg.h.window, cfg.color.black);
        Screen('DrawTexture', cfg.h.window,cfg.movie(i));
        if strcmp(cfg.cmp,'WindowsXP'),   Screen('TextSize', cfg.h.window,20);
        else   Screen('TextSize', cfg.h.window,30);
        end
        if count == 0
            str1 = 'At each trial'; str2 = 'you will be running'; str3 = 'fast in this maze';
        elseif count == 1
            str1 = 'this is'; str2 = 'the actual speed'; str3 = 'of running in this maze';
        end
        [x, y] = CalcTextPos(cfg.h.window, str1, cfg.pos.center_x, cfg.pos.center_y-60);
        Screen('DrawText', cfg.h.window, str1, x, y, cfg.color.white);
        [x, y] = CalcTextPos(cfg.h.window, str2, cfg.pos.center_x, cfg.pos.center_y-20);
        Screen('DrawText', cfg.h.window, str2, x, y, cfg.color.white);
        [x, y] = CalcTextPos(cfg.h.window, str3, cfg.pos.center_x, cfg.pos.center_y+20);
        Screen('DrawText', cfg.h.window, str3, x, y, cfg.color.white);
        
        % show stimuli
        tim = Screen('Flip', cfg.h.window,tim + delay*cfg.dur.frame - cfg.dur.buffer);
    end
    
    % show movie 2
    movie2 = cfg.movie_left;
    for i = 1:length(movie2),   Screen('FillRect', cfg.h.window, cfg.color.black); 
        Screen('DrawTexture', cfg.h.window,movie2(i));
        tim = Screen('Flip', cfg.h.window,tim + delay*cfg.dur.frame - cfg.dur.buffer);
    end
    
    %final screen
    Screen('FillRect', cfg.h.window, cfg.color.black); Screen('DrawTexture', cfg.h.window,movie2(i));
    str1 = 'Press button:'; str2 = 'Left to continue with the introduction'; 
    str3 = 'Right to repeat this part of the introduction';
    [x, y] = CalcTextPos(cfg.h.window, str1, cfg.pos.center_x, cfg.pos.center_y-60);
    Screen('DrawText', cfg.h.window, str1, x, y, cfg.color.white);
    [x, y] = CalcTextPos(cfg.h.window, str2, cfg.pos.center_x, cfg.pos.center_y-20);
    Screen('DrawText', cfg.h.window, str2, x, y, cfg.color.white);
    [x, y] = CalcTextPos(cfg.h.window, str3, cfg.pos.center_x, cfg.pos.center_y+20);
    Screen('DrawText', cfg.h.window, str3, x, y, cfg.color.white);
    tim = Screen('Flip', cfg.h.window,tim + 2*cfg.dur.frame - cfg.dur.buffer);
    
    % wait for fidget response- left response --> continue
    cfg = Wait_Fdgt(cfg);
    if cfg.fdgt.resp(1) > cfg.fdgt.resp(3),   count = count + 1; delay = 1;   end
    
    % check if fidget response is back to baseline before continuing
    WaitSecs(1); cfg = Wait_Fdgt_Back(cfg,cfg.color.black,cfg.color.white);
    
    if count == 2
        Screen('FillRect', cfg.h.window, cfg.color.white);
        str1 = 'The following informative stimuli can be presented';
        str2 = 'at the left or right side of the maze';
        str3 = 'The instructions given before each block indicate';
        str4 = 'whether to move in same or opposite direction as the stimulus';
        str5 = 'Press a button to continue with the introduction';
        str6 = 'happy face'; str7 = 'angry face'; str8= 'horizontal bow tie'; str9 = 'vertical bow tie';
        
        temp = [randperm(length(cfg.stim.exp_happy),2) randperm(length(cfg.stim.exp_vert),2)];
        size_stim = cfg.stim.size{2,1,temp(1)}(1:2);
        Screen('DrawTexture', cfg.h.window,cfg.stim.stim{2,1,temp(1)},[],[cfg.pos.center_x-300....
            cfg.pos.center_y-60-(size_stim(1)/2) cfg.pos.center_x-300+size_stim(2) cfg.pos.center_y-60+(size_stim(1)/2)]);
        size_stim = cfg.stim.size{2,2,temp(2)}(1:2);
        Screen('DrawTexture', cfg.h.window,cfg.stim.stim{2,2,temp(2)},[],[cfg.pos.center_x-100 ....
            cfg.pos.center_y-60-(size_stim(1)/2) cfg.pos.center_x-100+size_stim(2) cfg.pos.center_y-60+(size_stim(1)/2)]);
        size_stim = cfg.stim.size{2,3,temp(3)}(1:2);
        Screen('DrawTexture', cfg.h.window,cfg.stim.stim{2,3,temp(3)},[],[cfg.pos.center_x+100 ....
            cfg.pos.center_y-60-(size_stim(1)/2) cfg.pos.center_x+100+size_stim(2) cfg.pos.center_y-60+(size_stim(1)/2)]);
        size_stim = cfg.stim.size{2,4,temp(4)}(1:2);
        Screen('DrawTexture', cfg.h.window,cfg.stim.stim{2,4,temp(4)},[],[cfg.pos.center_x+300 ....
            cfg.pos.center_y-60-(size_stim(1)/2) cfg.pos.center_x+300+size_stim(2) cfg.pos.center_y-60+(size_stim(1)/2)]);
        
        [x, y] = CalcTextPos(cfg.h.window, str1, cfg.pos.center_x, cfg.pos.center_y-220);
        Screen('DrawText', cfg.h.window, str1, x, y, cfg.color.black);
        [x, y] = CalcTextPos(cfg.h.window, str2, cfg.pos.center_x, cfg.pos.center_y-180);
        Screen('DrawText', cfg.h.window, str2, x, y, cfg.color.black);
        [x, y] = CalcTextPos(cfg.h.window, str3, cfg.pos.center_x, cfg.pos.center_y+40);
        Screen('DrawText', cfg.h.window, str3, x, y, cfg.color.black);
        [x, y] = CalcTextPos(cfg.h.window, str4, cfg.pos.center_x, cfg.pos.center_y+80);
        Screen('DrawText', cfg.h.window, str4, x, y, cfg.color.black);
        [x, y] = CalcTextPos(cfg.h.window, str5, cfg.pos.center_x, cfg.pos.center_y+140);
        Screen('DrawText', cfg.h.window, str5, x, y, cfg.color.black);
        [x, y] = CalcTextPos(cfg.h.window, str6, cfg.pos.center_x-270, cfg.pos.center_y-130);
        Screen('DrawText', cfg.h.window, str6, x, y, cfg.color.black);
        [x, y] = CalcTextPos(cfg.h.window, str7, cfg.pos.center_x-80, cfg.pos.center_y-130);
        Screen('DrawText', cfg.h.window, str7, x, y, cfg.color.black);
        [x, y] = CalcTextPos(cfg.h.window, str8, cfg.pos.center_x+140, cfg.pos.center_y-130);
        Screen('DrawText', cfg.h.window, str8, x, y, cfg.color.black);
        [x, y] = CalcTextPos(cfg.h.window, str9, cfg.pos.center_x+360, cfg.pos.center_y-130);
        Screen('DrawText', cfg.h.window, str9, x, y, cfg.color.black);
        
        tim = Screen('Flip',cfg.h.window);
        
        % wait for fidget response
        cfg = Wait_Fdgt(cfg); count = count + 1; 
        % check if fidget response is back to baseline before continuing
        WaitSecs(1); cfg = Wait_Fdgt_Back(cfg,cfg.color.black,cfg.color.white);
    end
    
    if count == 3
        Screen('FillRect', cfg.h.window, cfg.color.white);
        str1 = 'You get feedback at the end of each trial'; str2 = 'These are:'; 
        str3 = 'Correct'; str4 = 'Wrong --> movement in wrong direction';
        str5 = 'Too late --> response was too late and arbitrary direction will be choosen';
        str6 = 'No response --> either no response was made or the force on the button was too low';
        str7 = 'Press a button to continue with the introduction';
        
        [x, y] = CalcTextPos(cfg.h.window, str1, cfg.pos.center_x, cfg.pos.center_y-200);
        Screen('DrawText', cfg.h.window, str1, x, y, cfg.color.black);
        [x, y] = CalcTextPos(cfg.h.window, str2, cfg.pos.center_x, cfg.pos.center_y-160);
        Screen('DrawText', cfg.h.window, str2, x, y, cfg.color.black);
        [x, y] = CalcTextPos(cfg.h.window, str3, cfg.pos.center_x, cfg.pos.center_y-120);
        Screen('DrawText', cfg.h.window, str3, x, y, cfg.color.black);
        [x, y] = CalcTextPos(cfg.h.window, str4, cfg.pos.center_x, cfg.pos.center_y-80);
        Screen('DrawText', cfg.h.window, str4, x, y, cfg.color.black);
        [x, y] = CalcTextPos(cfg.h.window, str5, cfg.pos.center_x, cfg.pos.center_y-40);
        Screen('DrawText', cfg.h.window, str5, x, y, cfg.color.black);
        [x, y] = CalcTextPos(cfg.h.window, str6, cfg.pos.center_x, cfg.pos.center_y);
        Screen('DrawText', cfg.h.window, str6, x, y, cfg.color.black);
        [x, y] = CalcTextPos(cfg.h.window, str7, cfg.pos.center_x, cfg.pos.center_y+60);
        Screen('DrawText', cfg.h.window, str7, x, y, cfg.color.black);
        
        tim = Screen('Flip',cfg.h.window);
        
        % wait for fidget response
        cfg = Wait_Fdgt(cfg); count = count + 1; 
        % check if fidget response is back to baseline before continuing
        WaitSecs(1); cfg = Wait_Fdgt_Back(cfg,cfg.color.black,cfg.color.white);
    end
    
    if count == 4
        Screen('FillRect', cfg.h.window, cfg.color.white);
        str1 = 'This was the introduction'; str2 = 'Next will be a training of 4 blocks';
        str3 = 'If you have any remaining questions, please ask the experimenter';
        str4 = 'Otherwise'; str5 = 'Good luck!';
        str7 = 'Press a button to continue with the training';
        
        [x, y] = CalcTextPos(cfg.h.window, str1, cfg.pos.center_x, cfg.pos.center_y-200);
        Screen('DrawText', cfg.h.window, str1, x, y, cfg.color.black);
        [x, y] = CalcTextPos(cfg.h.window, str2, cfg.pos.center_x, cfg.pos.center_y-160);
        Screen('DrawText', cfg.h.window, str2, x, y, cfg.color.black);
        [x, y] = CalcTextPos(cfg.h.window, str3, cfg.pos.center_x, cfg.pos.center_y-120);
        Screen('DrawText', cfg.h.window, str3, x, y, cfg.color.black);
        [x, y] = CalcTextPos(cfg.h.window, str4, cfg.pos.center_x, cfg.pos.center_y-80);
        Screen('DrawText', cfg.h.window, str4, x, y, cfg.color.black);
        [x, y] = CalcTextPos(cfg.h.window, str5, cfg.pos.center_x, cfg.pos.center_y-40);
        Screen('DrawText', cfg.h.window, str5, x, y, cfg.color.black);
%         [x, y] = CalcTextPos(cfg.h.window, str6, cfg.pos.center_x, cfg.pos.center_y);
%         Screen('DrawText', cfg.h.window, str6, x, y, cfg.color.black);
        [x, y] = CalcTextPos(cfg.h.window, str7, cfg.pos.center_x, cfg.pos.center_y+60);
        Screen('DrawText', cfg.h.window, str7, x, y, cfg.color.black);
        
        tim = Screen('Flip',cfg.h.window);
        
        % wait for fidget response
        cfg = Wait_Fdgt(cfg); count = count + 1; 
        % check if fidget response is back to baseline before continuing
        WaitSecs(1); cfg = Wait_Fdgt_Back(cfg,cfg.color.black,cfg.color.white);
    end
    
end