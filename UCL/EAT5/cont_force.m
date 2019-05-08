function cont_force
close all

cfg.respmode   = 'phidget';
if strcmp(cfg.respmode,'phidget'),   cfg = InitPhidget(cfg); cfg.respthr = 100; cfg.zerothr = 20;   end
% always perform CleanUp function, even after an error
obj_cleanup = onCleanup(@() CleanUp(cfg));

figure(1); hold on; 
measures = 6000;
axis([ 0, measures, 0 , 50 ]);
      
for i = 1:measures
    cfg.fdgt.resp = [];
    cfg = GetPhidget(cfg);
    plot(i,cfg.fdgt.resp(1),'bs'); plot(i,cfg.fdgt.resp(2),'rs'); 
    pause(0.01);
end


function CleanUp(cfg)
%% CleanUp
%------------------------

% close phidget
calllib('phidget21', 'CPhidget_close', cfg.fdgt.phid);
calllib('phidget21', 'CPhidget_delete', cfg.fdgt.phid);


% close all visible and hidden ports
IOPort('CloseAll');
if ~isempty(instrfindall), fclose(instrfindall); end

function cfg = InitPhidget(cfg)
%% Configure phidget
loadphidget21              % loads phidget library

cfg.fdgt.DataRate       = 8;                % phidget data rate (8 is precise, try playing around)
cfg.fdgt.totalbuttons   = 4;                % total number of buttons on phidget button box 
cfg.fdgt.Resp_button    = [1 4]; %[3 2]; %[3 4];    % response buttons used - left, right

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

function cfg = GetPhidget(cfg)

temp  = zeros(length(cfg.fdgt.Resp_button),1);

smp = 1;
for i = 1:length(cfg.fdgt.Resp_button);
    button = cfg.fdgt.Resp_button(i); % i.e. it is now 2 & 4, other phidget it is 3-4
    if calllib('phidget21', 'CPhidgetInterfaceKit_getSensorRawValue', cfg.fdgt.phid, button, cfg.fdgt.dataptr1)== 0;
        temp(smp,:) = double(cfg.fdgt.dataptr1.Value) ; % first becomes a dubble to save time string appropriately
    else
        calllib('phidget21', 'CPhidget_close', phid);        
        calllib('phidget21', 'CPhidget_delete', phid);
        error('Error getting data..');
    end
    smp = smp+1;
end
cfg.fdgt.resp(size(cfg.fdgt.resp,1)+1,:) = [temp(1) temp(2)];