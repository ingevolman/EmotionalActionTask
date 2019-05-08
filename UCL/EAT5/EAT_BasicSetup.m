function cfg = EAT_BasicSetup(cfg)


%% specific debug settings
if cfg.flg.debug == 1 %&& ~strcmp(cfg.cmp,'WindowsXP')
    PsychDebugWindowConfiguration
end

% Move the cursor to the center of the screen
if cfg.flg.debug
    % show cursor as an arrow
    ShowCursor('Arrow');
else
    % hide the mouse cursor
    HideCursor;
end

%if ~strcmp(cfg.cmp,'WindowsXP') %if not windows XP
    
    %% from Psychtoolbox examples & adapted by me
    
    % Get the screen numbers. This gives us a number for each of the screens
    % attached to our computer. For example, when I call this I get the vector
    % [0 1]. The first number is the native display for my laptop and the
    % second referes to my secondary external monitor. By native display I mean
    % the display the is physically part of my laptop. With a non-laptop
    % computer look at your screen preferences to see which is the primary
    % monitor.
    screens = Screen('Screens');
    
    % To draw we select the maximum of these numbers. So in a situation where we
    % have two screens attached to our monitor we will draw to the external
    % screen. If I were to select the minimum of these numbers then I would be
    % displaying on the physical screen of my laptop.
    %cfg.screenNumber = max(screens);
    cfg.screenNumber = min(screens); % I changed it to this to display it to external screen with my setup
    
    
    % Define black and white (white will be 1 and black 0). This is because
    % luminace values are genrally defined between 0 and 1.
    cfg.color.white = WhiteIndex(cfg.screenNumber);
    cfg.color.black = BlackIndex(cfg.screenNumber);
    cfg.color.grey = cfg.color.white / 2;
    %cfg.color.red = [255 0 0]';
    cfg.color.red = [1 0 0]';
    %cfg.color.green = [0 255 0]';
    cfg.color.green = [0 1 0]';
     
    % set text defaults
    Screen('Preference', 'DefaultFontName','Arial');
    Screen('Preference', 'DefaultFontSize', 20);
    oldResolution = Screen('Resolution',0,1280,1024,75);
        
    % Open an on screen window and color it grey. This function returns a
    % number that identifies the window we have opened "window" and a vector
    % "windowRect".
    % "cfg.pos.win" is a vector of numbers: the first is the X coordinate
    % representing the far left of our screen, the second the Y coordinate
    % representing the top of our screen,
    % the third the X coordinate representing
    % the far right of our screen and finally the Y coordinate representing the
    % bottom of our screen.
    %[window, windowRect] = PsychImaging('OpenWindow', screenNumber, grey);
    [cfg.h.window, cfg.pos.win] = PsychImaging('OpenWindow', cfg.screenNumber, cfg.color.grey);
    
    % Enable alpha blending with proper blend-function. We need it for
    % transparency background for arrow
    Screen('BlendFunction', cfg.h.window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA' );
    
    % Now that we have a window open we can query some of its properties.
    % get window positions
    cfg.pos.width = cfg.pos.win(3) - cfg.pos.win(1);
    cfg.pos.height = cfg.pos.win(4) - cfg.pos.win(2);
    cfg.pos.center_x = cfg.pos.width/2;
    cfg.pos.center_y = cfg.pos.height/2;
    
    % Get the size of the on screen window in pixels, these are the last two
    % numbers in "cfg.pos.win"
    [cfg.screenXpixels, cfg.screenYpixels] = Screen('WindowSize', cfg.h.window);
    
    %% from from CP script of Lennart Verhagen
    
    % Switch to realtime-priority to reduce timing jitter and interruptions
    % caused by other applications and the operating system itself:
    if IsWin
        Priority(0);
        %Priority(1); % This is not real-time priority to give the screen-capture program a chance to run smoothly
    else
        Priority(MaxPriority(cfg.h.window));
    end
    
    % Get the flip interval (time between frame refresh)
    cfg.dur = [];
    cfg.dur.frame = Screen('GetFlipInterval',cfg.h.window);
    % calculate a buffer of half a frame rate
    cfg.dur.buffer = cfg.dur.frame/2;


% else % if Windows XP
%     
%     Priority(1);
%     
%     cfg.color.white = 255; %white
%     cfg.color.black = 0;
%     cfg.color.grey = cfg.color.white / 2;
%     cfg.color.red = [255 0 0]';
%     cfg.color.green = [0 255 0]';
%     % set text defaults
%     Screen('Preference', 'DefaultFontName','Arial');
%     Screen('Preference', 'DefaultFontSize', 10);
%     Screen('Preference', 'SkipSyncTests', 0);
%     %oldResolution = Screen('Resolution',0,1024,768,75);
%     %oldResolution = Screen('Resolution',0,800,600,60);
%     oldResolution = Screen('Resolution',0,800,600,75);
%     
%     %Open a window
%     cfg.h.window = Screen('OpenWindow', 0, cfg.color.grey);%0 is the main
%     Screen('BlendFunction', cfg.h.window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA' ); %anti-aliasing
%     screen.RefreshRate = Screen('FrameRate', cfg.h.window); %in Hz; PTB asks the screen what its refresh rate is
%     
%     % Now that we have a window open we can query some of its properties.
%     % %Find the centre of the screen
%     cfg.pos.win = Screen('Rect', cfg.h.window);
%     % get window positions
%     cfg.pos.width = cfg.pos.win(3) - cfg.pos.win(1);
%     cfg.pos.height = cfg.pos.win(4) - cfg.pos.win(2);
%     cfg.pos.center_x = cfg.pos.width/2;
%     cfg.pos.center_y = cfg.pos.height/2;
%     
%     % move y center down on screen to deal with too high placed screens.
%     cfg.pos.scale = 60;
%     %cfg.pos.center_y = cfg.pos.center_y + cfg.pos.scale;
%     
%     % Get the size of the on screen window in pixels, these are the last two
%     % numbers in "cfg.pos.win"
%     [cfg.screenXpixels, cfg.screenYpixels] = Screen('WindowSize', cfg.h.window);
%     
%     % Get the flip interval (time between frame refresh)
%     cfg.dur = [];
%     cfg.dur.frame = Screen('GetFlipInterval',cfg.h.window);
%     % calculate a buffer of half a frame rate
%     cfg.dur.buffer = cfg.dur.frame/2;
%     
% end
% 
% 
% 
% 
% 
