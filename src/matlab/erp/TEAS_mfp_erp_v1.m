%% TEAS multifeature auditory oddball script
% o-ptb 

% Author: Patrick Neff, Ph.D., 
% University of Salzburg/Zurich
% email address: schlaukeit@gmail.com  
% Website: 
% December 2020; Last revision: 18-Jan-2021

%% clear, init

clear all global 

restoredefaultpath


%% add path to o_ptb

addpath('/Users/shanti/Documents/Fork/o_ptb') % change this to where o_ptb is on your system


%% initialize PTB

o_ptb.init_ptb('/Users/shanti/Documents/GitHub/Psychtoolbox-3/Psychtoolbox/') % change this to where o_ptb is on your system


%% config + instance o_ptb,

ptb_cfg = o_ptb.PTB_Config();

ptb_cfg.fullscreen = false;
ptb_cfg.window_scale = 0.2;
ptb_cfg.skip_sync_test = true;
ptb_cfg.hide_mouse = false;
ptb_cfg.psychportaudio_config.freq = 44100;
ptb_cfg.psychportaudio_config.device = 3;


ptb = o_ptb.PTB.get_instance(ptb_cfg);

%% init systems

%ptb_cfg.internal_config.final_resolution = [1980 1024];
% ptb.setup_screen;   

ptb.setup_audio;
ptb.setup_trigger;

%% get tinnitus frequency

tf      = inputdlg('Individuelle Tinnitusfrequenz:',...
                   'Bitte eingeben',[1 50]);
tin_freq = str2num(tf{:});  

%% get sensation levels

prompt = {'Sensation level 1000 Hz:','Sensation level 5000 Hz:','Sensation level Tinnitus:'};
dlg_title = 'Input';
num_lines = 1;
answer = inputdlg(prompt,dlg_title,num_lines);

sl_all = answer;

sl_1000 = str2num(answer{1});
sl_5000 = str2num(answer{2});
sl_tin = str2num(answer{3});


%% create stimuli, standard and deviants
%most critical: check dynamic range and loudness!
%also careful with one shot scripting, redo var names
%for smooth code, create a class and maybe package - or use proper instance
%copy with matlab.mixin.Copyable / copy()
%ramp 1 ms ok?

% constants
f_1000 = 1000; %maybe obsolete...
f_5000 = 5000;
dur = 0.075; %stimulus duration
std_db = -100+sl_1000+60; %standard SL + 60dB
rmp = 0.005; %standard ramp

% standard
s_1000_st_10 = o_ptb.stimuli.auditory.Sine(1000, dur);	
s_1000_st_10.db = std_db; %check dynamic range
s_1000_st_10.apply_cos_ramp(rmp);

% loudness
s_1000_loud_up_13 = o_ptb.stimuli.auditory.Sine(1000, dur);
s_1000_loud_up_13.db = std_db + 10;
s_1000_loud_up_13.apply_cos_ramp(rmp);

s_1000_loud_dwn_14 = o_ptb.stimuli.auditory.Sine(1000, dur);
s_1000_loud_dwn_14.db = std_db - 10;
s_1000_loud_dwn_14.apply_cos_ramp(rmp);

% freq
s_1000_freq_up_11 = o_ptb.stimuli.auditory.Sine(f_1000+0.1*f_1000, dur);
s_1000_freq_up_11.db = std_db;
s_1000_freq_up_11.apply_cos_ramp(rmp);

s_1000_freq_down_12 = o_ptb.stimuli.auditory.Sine(f_1000-0.1*f_1000, dur);
s_1000_freq_down_12.db = std_db;
s_1000_freq_down_12.apply_cos_ramp(rmp);

%location . channel issue? maybe fix with muted channels  muted_channels : int or array of ints If empty (i.e. []), both channels are played. If set to 1, the left channel is muted. If set to 2, the right channel is muted. If set to   [1 2], both channels are muted.
s_1000_loc_l_17 = o_ptb.stimuli.auditory.Sine(1000, dur);	
s_1000_loc_l_17.angle = -pi/2;
% s_1000_loc_l_17.muted_channels = 2;
s_1000_loc_l_17.db = std_db; 
s_1000_loc_l_17.apply_cos_ramp(rmp);

s_1000_loc_r_17 = o_ptb.stimuli.auditory.Sine(1000, dur);	
s_1000_loc_r_17.angle = pi/2;
% s_1000_loc_r_17.muted_channels = 1;
s_1000_loc_r_17.db = std_db; 
s_1000_loc_r_17.apply_cos_ramp(rmp);

%duration
s_1000_dur_dwn_16 = o_ptb.stimuli.auditory.Sine(1000, dur-0.05);
s_1000_dur_dwn_16.db = std_db;
s_1000_dur_dwn_16.apply_cos_ramp(rmp);

%gap
s_1000_gap_18_1 = o_ptb.stimuli.auditory.Sine(1000, 0.034 );
s_1000_gap_18_1.db = std_db;
s_1000_gap_18_1.apply_cos_ramp(rmp);

s_1000_gap_18_2 = o_ptb.stimuli.auditory.Sine(1000, 0.034 );
s_1000_gap_18_2.db = std_db;
s_1000_gap_18_2.apply_cos_ramp(rmp);

s_1000_gap_18_gap = o_ptb.stimuli.auditory.Sine(1000, 0.007 );
s_1000_gap_18_gap.db = -100;
s_1000_gap_18_gap.apply_cos_ramp(0.001);

% fuse



%% play it

ptb.prepare_audio(s_1000_st_10);
ptb.schedule_audio;
ptb.play_without_flip;



%% trigger

ptb.prepare_audio(s_1000_loc_l_17);
ptb.prepare_trigger(1);
ptb.prepare_audio(s_1000_loc_r_17, 0.5, true);
ptb.prepare_trigger(2, 0.5, true);
ptb.prepare_audio(s_1000_st_10, 1, true);
ptb.prepare_trigger(3, 0.5, true)
ptb.schedule_audio;
ptb.schedule_trigger;
ptb.play_without_flip;

