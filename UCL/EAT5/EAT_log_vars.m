function [cfg, log]= EAT_log_vars(cfg,log)

%% log
log.subjname = cfg.subjname;
path = pwd;
log.path = fullfile(path,'logfile');
if ~exist(log.path,'dir'), mkdir(log.path); end

log.vars = {...
    'exp','block_nr','trl_nr','blocktype','blockInst','stim_side','stim_type','stim_nr','flip_int','ITI',...
    'T_fixation_onset','T_movie_start','T_stim_onset','T_stim_offset','T_movie_offset','T_movie2_start',...
    'T_feedback','T_start_ITI','T_start_IBI','SRT','corr','no_resp','resp','force'};

% pre-allocate memory for the logfile
log.data = zeros(cfg.prac.n.trl+cfg.exp.n.trl,length(log.vars));


%% logging of pre-determined variables

% General
exp         = [ones(1,cfg.prac.n.trl) 2*ones(1,cfg.exp.n.trl)]';
blk         = [];
trl         = [repmat(1:cfg.prac.n.trialsperblock,1,cfg.prac.n.block)...
    repmat(1:cfg.exp.n.trialsperblock,1,cfg.exp.n.block)];
blktype       = [];
sts         = [];
stim         = [];
iti         = [];
% Practice trials
for i       = 1:cfg.prac.n.block
    blk     = [blk;repmat(i,cfg.prac.n.trialsperblock,1)];
    blktype = [blktype;repmat(cfg.prac.block(i),cfg.prac.n.trialsperblock,1)];
    sts     = [sts; cfg.prac.side{i}'];
    stim     = [stim; cfg.prac.stim{i}'];
    iti     = [iti; cfg.prac.iti{i}'];
end
% Experimental trials
for i       = 1:cfg.exp.n.block
    blk     = [blk;repmat(i,cfg.exp.n.trialsperblock,1)];
    blktype = [blktype;repmat(cfg.exp.block(i),cfg.exp.n.trialsperblock,1)];
    sts     = [sts; cfg.exp.side{i}'];
    stim     = [stim; cfg.exp.stim{i}'];
    iti     = [iti; cfg.exp.iti{i}'];
end

log = LogAdd(log,'exp',exp );
log = LogAdd(log,'block_nr',blk);
log = LogAdd(log,'trl_nr',trl);
log = LogAdd(log,'blocktype',blktype);
log = LogAdd(log,'stim_side',sts);
log = LogAdd(log,'stim_type',stim);
log = LogAdd(log,'flip_int',cfg.dur.frame);
log = LogAdd(log,'ITI',iti);



function log = LogAdd(log,varname,x)
%% LogAdd
%------------------------
idx = ismember(log.vars,varname);
if ~any(idx),   warning('variable name ''%s'' not recognized',varname);    end

% store x in data matrix
log.data(:,idx) = x;

