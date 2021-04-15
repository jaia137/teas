function ptb_config = config_ptb()
%% init paths....
restoredefaultpath;
% addpath('../o_ptb/');
addpath('C:\Program Files\MATLAB\R2016b\toolbox\o_ptb-master\') 

% o_ptb.init_ptb('../Psychtoolbox-3');

o_ptb.init_ptb('C:\toolbox\Psychtoolbox\')

addpath('C:\Program Files\MATLAB\R2016b\toolbox\io\')

commandwindow;


%% create ptb_config
ptb_cfg = o_ptb.PTB_Config();

ptb_cfg.fullscreen = false;
ptb_cfg.window_scale = 0.2;
ptb_cfg.skip_sync_test = true;
ptb_cfg.hide_mouse = false;
ptb_cfg.psychportaudio_config.freq = 44100;
ptb_cfg.psychportaudio_config.device = 8; %check with audiodevinfo!


end
