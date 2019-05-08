function cfg = EAT_vars_exp(cfg)

%% general variables
cfg.n.blocktype     = 2; % congruent, incongruent
%cfg.n.blkInst       = 2; % ap hor, av vert; or ap vert, av hor
cfg.stimoptions     = 1:2; % hap, ang          %%%%or hor, vert depending on blocktype
cfg.side            = 1:2; % left, right
cfg.n.cond          = length(cfg.stimoptions) * length(cfg.side);
cfg.n.rep           = 3; % max nr of repetitions per condition type (side, stimulus)

% experimental variables
cfg.exp.n.trl       = 240; % if trials exceed 1000 per condition - look at quest input to avoid underflow
cfg.exp.n.trialsperblock = 40; 
cfg.exp.n.block     = cfg.exp.n.trl/cfg.exp.n.trialsperblock;

% practice variables
cfg.prac.n.trl      = 64; % 4 trial type X 16 training trials
cfg.prac.n.trialsperblock = 32;
cfg.prac.n.block    = cfg.prac.n.trl/cfg.prac.n.trialsperblock;

% range ITI & IBI
iti = 0.6:0.1:1;
%ibi = 2.1:0.1:3;


%% block type randomization over blocks
cfg.exp.block = randperm(cfg.n.blocktype);
for i = 1:(cfg.exp.n.block-cfg.n.blocktype)/cfg.n.blocktype
    temp = randperm(cfg.n.blocktype);
    while cfg.exp.block(end) == temp(1)
        temp = randperm(cfg.n.blocktype);
    end
    cfg.exp.block = [cfg.exp.block temp];
end
cfg.prac.block =randperm(cfg.n.blocktype); 
%cfg.exp.blkInst = repmat(randperm(cfg.n.blkInst),1,ceil(cfg.exp.n.block/cfg.n.blocktype/2)); % assign different instrumental instructions - app horizontal, avoid horizontal
%cfg.prac.blkInst = randperm(cfg.n.blkInst); % assign different instrumental instructions - app horizontal, avoid horizontal

%% condition randomization accross each block
conditions = [repmat(cfg.stimoptions,1,cfg.n.cond/(length(cfg.stimoptions)));...
    [repmat(cfg.side(1),1,cfg.n.cond/length(cfg.side)) repmat(cfg.side(2),1,cfg.n.cond/length(cfg.side))]]; % congruent x stimulus x side

% experiment
cond_string = repmat(conditions,1,cfg.exp.n.trialsperblock/length(conditions));
for i = 1:cfg.exp.n.block
    cond = cond_string(:,randperm(length(cond_string)));
    while any(diff([0 find(diff(cond(1,:))) length(cond)]) > cfg.n.rep) ||... % no more than 4 repetitions of stimulus type
            any(diff([0 find(diff(cond(2,:))) length(cond)]) > cfg.n.rep) ||... % no more than 4 repetitions of stimulus side
            any(diff([0 find(diff(cond(1,:)-cond(2,:)*2)) length(cond)])> cfg.n.rep-1) %no more than 3 repetitions of condition type
        cond = cond_string(:,randperm(length(cond_string)));
    end
    cfg.exp.stim{i} = cond(1,:);
    cfg.exp.side{i} = cond(2,:);
    
    remd = rem(cfg.exp.n.trialsperblock,length(iti));
    rep = (cfg.exp.n.trialsperblock-remd)/length(iti);
    iti_new = [repmat(iti,1,rep) iti(randperm(length(iti),remd))];
    cfg.exp.iti{i} = iti_new(randperm(length(iti_new)));
end

% practice
cond_string = repmat(conditions,1,cfg.prac.n.trialsperblock/length(conditions));
for i = 1:cfg.prac.n.block
    cond = cond_string(:,randperm(length(cond_string)));
    while any(diff([0 find(diff(cond(1,:))) length(cond)]) > cfg.n.rep) ||... % no more than 3 repetitions of presentation side
            any(diff([0 find(diff(cond(2,:))) length(cond)]) > cfg.n.rep) ||... % no more than 3 repetitions of arrow direction
            any(diff([0 find(diff(cond(1,:)-cond(2,:)*2)) length(cond)])> cfg.n.rep-1) %no more than 2 repetitions of condition type
        cond = cond_string(:,randperm(length(cond_string)));
    end
    cfg.prac.stim{i} = cond(1,:);
    cfg.prac.side{i} = cond(2,:);
    
    remd = rem(cfg.prac.n.trialsperblock,length(iti));
    rep = (cfg.prac.n.trialsperblock - remd)/length(iti);
    iti_new = [repmat(iti,1,rep) iti(randperm(length(iti),remd))];
    cfg.prac.iti{i} = iti_new(randperm(length(iti_new)));
end


%% get face variables

% happy faces for experiment
cfg.stim.prac_happy = [{'af01has.bmp'},{'af02has.bmp'},{'af03has.bmp'},{'af05has.bmp'},...
    {'af14has.bmp'},{'af18has.bmp'},{'af20has.bmp'},{'af21has.bmp'},{'af26has.bmp'},...
    {'af29has.bmp'},{'af35has.bmp'},{'am01has.bmp'},{'am02has.bmp'},{'am03has.bmp'},...
    {'am06has.bmp'},{'am08has.bmp'},{'am09has.bmp'},{'am10has.bmp'},{'am11has.bmp'},...
    {'am14has.bmp'},{'am21has.bmp'},{'am22has.bmp'},{'am29has.bmp'},{'am34has.bmp'},...
    {'efs001.bmp'},{'efs007.bmp'},{'efs022.bmp'},{'efs029.bmp'},{'efs035.bmp'},...
    {'efs042.bmp'},{'efs048.bmp'},{'efs057.bmp'},{'efs066.bmp'},{'efs074.bmp'},...
    {'efs085.bmp'},{'efs101.bmp'}];
% angry faces for experiment
cfg.stim.prac_angry = [{'af01ans.bmp'},{'af02ans.bmp'},{'af03ans.bmp'},{'af05ans.bmp'},...
    {'af14ans.bmp'},{'af18ans.bmp'},{'af20ans.bmp'},{'af21ans.bmp'},{'af26ans.bmp'},...
    {'af29ans.bmp'},{'af35ans.bmp'},{'am01ans.bmp'},{'am02ans.bmp'},{'am03ans.bmp'},...
    {'am06ans.bmp'},{'am08ans.bmp'},{'am09ans.bmp'},{'am10ans.bmp'},{'am11ans.bmp'},...
    {'am14ans.bmp'},{'am21ans.bmp'},{'am22ans.bmp'},{'am29ans.bmp'},{'am34ans.bmp'},...
    {'efs003.bmp'},{'efs010.bmp'},{'efs025.bmp'},{'efs030.bmp'},{'efs038.bmp'},...
    {'efs044.bmp'},{'efs052.bmp'},{'efs062.bmp'},{'efs069.bmp'},{'efs080.bmp'},...
    {'efs089.bmp'},{'efs105.bmp'}];
cfg.stim.exp_happy = [{'Rafd090_01_Caucasian_female_happy_frontal.jpg'},{'Rafd090_02_Caucasian_female_happy_frontal.jpg'},...
    {'Rafd090_04_Caucasian_female_happy_frontal.jpg'},{'Rafd090_08_Caucasian_female_happy_frontal.jpg'},...
    {'Rafd090_12_Caucasian_female_happy_frontal.jpg'},{'Rafd090_14_Caucasian_female_happy_frontal.jpg'},...
    {'Rafd090_16_Caucasian_female_happy_frontal.jpg'},{'Rafd090_18_Caucasian_female_happy_frontal.jpg'},...
    {'Rafd090_19_Caucasian_female_happy_frontal.jpg'},{'Rafd090_22_Caucasian_female_happy_frontal.jpg'},...
    {'Rafd090_26_Caucasian_female_happy_frontal.jpg'},{'Rafd090_27_Caucasian_female_happy_frontal.jpg'},...
    {'Rafd090_31_Caucasian_female_happy_frontal.jpg'},{'Rafd090_32_Caucasian_female_happy_frontal.jpg'},...
    {'Rafd090_37_Caucasian_female_happy_frontal.jpg'},{'Rafd090_56_Caucasian_female_happy_frontal.jpg'},...
    {'Rafd090_57_Caucasian_female_happy_frontal.jpg'},{'Rafd090_58_Caucasian_female_happy_frontal.jpg'},...
    {'Rafd090_61_Caucasian_female_happy_frontal.jpg'},...
    {'Rafd090_03_Caucasian_male_happy_frontal.jpg'},{'Rafd090_05_Caucasian_male_happy_frontal.jpg'},...
    {'Rafd090_07_Caucasian_male_happy_frontal.jpg'},{'Rafd090_09_Caucasian_male_happy_frontal.jpg'},...
    {'Rafd090_10_Caucasian_male_happy_frontal.jpg'},{'Rafd090_15_Caucasian_male_happy_frontal.jpg'},...
    {'Rafd090_20_Caucasian_male_happy_frontal.jpg'},{'Rafd090_21_Caucasian_male_happy_frontal.jpg'},...
    {'Rafd090_23_Caucasian_male_happy_frontal.jpg'},{'Rafd090_24_Caucasian_male_happy_frontal.jpg'},...
    {'Rafd090_25_Caucasian_male_happy_frontal.jpg'},{'Rafd090_28_Caucasian_male_happy_frontal.jpg'},...
    {'Rafd090_30_Caucasian_male_happy_frontal.jpg'},{'Rafd090_33_Caucasian_male_happy_frontal.jpg'},...
    {'Rafd090_36_Caucasian_male_happy_frontal.jpg'},{'Rafd090_46_Caucasian_male_happy_frontal.jpg'},...
    {'Rafd090_47_Caucasian_male_happy_frontal.jpg'},{'Rafd090_49_Caucasian_male_happy_frontal.jpg'},...
    {'Rafd090_71_Caucasian_male_happy_frontal.jpg'}];
cfg.stim.exp_angry = [{'Rafd090_01_Caucasian_female_angry_frontal.jpg'},{'Rafd090_02_Caucasian_female_angry_frontal.jpg'},...
    {'Rafd090_04_Caucasian_female_angry_frontal.jpg'},{'Rafd090_08_Caucasian_female_angry_frontal.jpg'},...
    {'Rafd090_12_Caucasian_female_angry_frontal.jpg'},{'Rafd090_14_Caucasian_female_angry_frontal.jpg'},...
    {'Rafd090_16_Caucasian_female_angry_frontal.jpg'},{'Rafd090_18_Caucasian_female_angry_frontal.jpg'},...
    {'Rafd090_19_Caucasian_female_angry_frontal.jpg'},{'Rafd090_22_Caucasian_female_angry_frontal.jpg'},...
    {'Rafd090_26_Caucasian_female_angry_frontal.jpg'},{'Rafd090_27_Caucasian_female_angry_frontal.jpg'},...
    {'Rafd090_31_Caucasian_female_angry_frontal.jpg'},{'Rafd090_32_Caucasian_female_angry_frontal.jpg'},...
    {'Rafd090_37_Caucasian_female_angry_frontal.jpg'},{'Rafd090_56_Caucasian_female_angry_frontal.jpg'},...
    {'Rafd090_57_Caucasian_female_angry_frontal.jpg'},{'Rafd090_58_Caucasian_female_angry_frontal.jpg'},...
    {'Rafd090_61_Caucasian_female_angry_frontal.jpg'},...
    {'Rafd090_03_Caucasian_male_angry_frontal.jpg'},{'Rafd090_05_Caucasian_male_angry_frontal.jpg'},...
    {'Rafd090_07_Caucasian_male_angry_frontal.jpg'},{'Rafd090_09_Caucasian_male_angry_frontal.jpg'},...
    {'Rafd090_10_Caucasian_male_angry_frontal.jpg'},{'Rafd090_15_Caucasian_male_angry_frontal.jpg'},...
    {'Rafd090_20_Caucasian_male_angry_frontal.jpg'},{'Rafd090_21_Caucasian_male_angry_frontal.jpg'},...
    {'Rafd090_23_Caucasian_male_angry_frontal.jpg'},{'Rafd090_24_Caucasian_male_angry_frontal.jpg'},...
    {'Rafd090_25_Caucasian_male_angry_frontal.jpg'},{'Rafd090_28_Caucasian_male_angry_frontal.jpg'},...
    {'Rafd090_30_Caucasian_male_angry_frontal.jpg'},{'Rafd090_33_Caucasian_male_angry_frontal.jpg'},...
    {'Rafd090_36_Caucasian_male_angry_frontal.jpg'},{'Rafd090_46_Caucasian_male_angry_frontal.jpg'},...
    {'Rafd090_47_Caucasian_male_angry_frontal.jpg'},{'Rafd090_49_Caucasian_male_angry_frontal.jpg'},...
    {'Rafd090_71_Caucasian_male_angry_frontal.jpg'}];


%% randomize face stimuli numbers across prac/exp x blocktype x stimulus
% for length practice/experiment
for exp = 1:2
    for stim = 1:2
        if exp == 1 
            if stim == 1,   stim_face = cfg.stim.exp_happy; %stim_obj = cfg.stim.exp_hor;  %stim = cfg.stim.prac_happy;
            elseif stim == 2,   stim_face = cfg.stim.exp_angry; %stim_obj = cfg.stim.exp_vert;  %stim = cfg.stim.prac_angry;
            end
            rep_trl_CongrStim = floor(cfg.prac.n.trl/(cfg.n.blocktype*max(cfg.stimoptions)*length(stim_face))); %(block x stim combinations)
            rem_trl_CongrStim = rem(cfg.prac.n.trl,cfg.n.blocktype*max(cfg.stimoptions)*length(stim_face))/cfg.prac.n.block; %(block x stim combinations)
        elseif exp == 2
            if stim == 1,   stim_face = cfg.stim.exp_happy; %stim_obj = cfg.stim.exp_hor; 
            elseif stim == 2,   stim_face = cfg.stim.exp_angry; %stim_obj = cfg.stim.exp_vert; 
            end
            rep_trl_CongrStim = floor(cfg.exp.n.trl/(cfg.n.blocktype*max(cfg.stimoptions)*length(stim_face))); %(block x stim combinations)
            rem_trl_CongrStim = rem(cfg.exp.n.trl,cfg.n.blocktype*max(cfg.stimoptions)*length(stim_face))/(cfg.n.blocktype*max(cfg.stimoptions)); %(block x stim combinations)
        end
        cfg.stim.stim_nr{exp,1,stim} = []; cfg.stim.stim_nr{exp,2,stim}= []; %cfg.stim.stim_nr{exp,3,stim}= [];
        for i = 1:rep_trl_CongrStim
            cfg.stim.stim_nr{exp,1,stim} = [cfg.stim.stim_nr{exp,1,stim}, randperm(length(stim_face))];
            cfg.stim.stim_nr{exp,2,stim} = [cfg.stim.stim_nr{exp,2,stim}, randperm(length(stim_face))];
            %cfg.stim.stim_nr{exp,3,stim} = [cfg.stim.stim_nr{exp,3,stim}, randperm(length(stim_obj))];
        end
        cfg.stim.stim_nr{exp,1,stim} = [cfg.stim.stim_nr{exp,1,stim}, randperm(length(stim_face),rem_trl_CongrStim)];
        cfg.stim.stim_nr{exp,2,stim} = [cfg.stim.stim_nr{exp,2,stim}, randperm(length(stim_face),rem_trl_CongrStim)];
        %cfg.stim.stim_nr{exp,3,stim} = [cfg.stim.stim_nr{exp,3,stim}, randperm(length(stim_obj),rem_trl_CongrStim)];
    end
end


%% implement Quest - create prior 

tGuess      = 0.7; tGuessSd = 0.7;
pThreshold  = 0.7; % threshold correct/incorrect.
beta        = 3.5; % following suggestion by QuestCreate script.
%beta        = 6.6; % based on simulation
delta       = 0.01; % fraction of trials on which pp presses blindly, I followed script.
gamma       = 0.5; % fraction of trials that generate response 1 when intensity == -inf, here would be chance.

cfg.q{1,1} = QuestCreate(tGuess,tGuessSd,pThreshold,beta,delta,gamma); %congruent, happy
cfg.q{1,2} = QuestCreate(tGuess,tGuessSd,pThreshold,beta,delta,gamma); %congruent, angry
cfg.q{2,1} = QuestCreate(tGuess,tGuessSd,pThreshold,beta,delta,gamma); %incongruent, happy
cfg.q{2,2} = QuestCreate(tGuess,tGuessSd,pThreshold,beta,delta,gamma); %incongruent, angry
%cfg.q{3,1} = QuestCreate(tGuess,tGuessSd,pThreshold,beta,delta,gamma); %instrumental, approach
%cfg.q{3,2} = QuestCreate(tGuess,tGuessSd,pThreshold,beta,delta,gamma); %instrumental, avoid

 