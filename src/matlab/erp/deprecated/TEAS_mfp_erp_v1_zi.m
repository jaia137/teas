%% TEAS multifeature auditory oddball script
% o-ptb 

% Author: Patrick Neff, Ph.D., clinical neuroscience
% University of Zurich
% email address: schlaukeit@gmail.com  
% Website: 
% December 2020; Last revision: 12-Jan-2021

%% clear, init

clear all global 

restoredefaultpath


%% add path to o_ptbC:
addpath('C:\Users\Zino\Documents\fede\xx\o_ptb') 
% change this to where o_ptb is on your system


%% initialize PTB

o_ptb.init_ptb('C:\Users\Zino\Documents\fede\xx\Psychtoolbox-3\Psychtoolbox') % change this to where o_ptb is on your system


%% config + instance o_ptb,

ptb_cfg = o_ptb.PTB_Config();

ptb_cfg.fullscreen = false;
ptb_cfg.window_scale = 0.2;
ptb_cfg.skip_sync_test = true;
ptb_cfg.hide_mouse = false;

ptb = o_ptb.PTB.get_instance(ptb_cfg);


%% init systems

ptb_cfg.internal_config.final_resolution = [1980 1024];

% ptb.setup_screen;   
ptb.setup_audio;
ptb.setup_trigger;

%% get tinnitus frequency

tf      = inputdlg('Individuelle Tinnitusfrequenz:',...
                   'Bitte eingeben',[1 50]);
tin_freq = str2num(tf{:});  

%% get sensation levels

prompt = {'Sensation level 1000 Hz:','Sensation level 1000 Hz:','Sensation level Tinnitus:'};
dlg_title = 'Input';
num_lines = 1;
answer = inputdlg(prompt,dlg_title,num_lines);

sl_all = answer;

sl_1000 = str2num(answer{1});
sl_5000 = str2num(answer{2});
sl_tin = str2num(answer{3});



%% create stimuli, standard and deviants

% standard
s_1000_st_10 = o_ptb.stimuli.auditory.Sine(1000, 0.075);	
s_1000_st_10.apply_cos_ramp(0.005);
s_1000_st_10.db = -100+sl_1000+70; %check dynamic range

% duration
s_1000_dur_up_15 = s_1000_st_10;
s_1000_dur_up_15.db = s_1000_dur_up_15.db + 10;

s_1000_dur_dwn_15 = s_1000_st_10;
s_1000_dur_dwn_15.db = s_1000_dur_dwn_15.db - 10;


%% create a sine wave and make a sound object, add ramps

% class +o_ptb.+stimuli.+auditory.Sine(freq,duration)

s_rate = 44100;
freq = 1000;
amplitude = 0.1; %db2mag / mag2db
duration = 0.075;
sound_data = amplitude * sin(2*pi*(1:(s_rate*duration))/s_rate*freq);
sin_sound = o_ptb.stimuli.auditory.FromMatrix(sound_data, s_rate);


%% play it

ptb.prepare_audio(S_1000_st_10);
ptb.schedule_audio;
ptb.play_without_flip;

%% trigger

ptb.prepare_audio(my_sound);
ptb.prepare_trigger(1);
ptb.prepare_audio(my_sound, 0.5, true);
ptb.prepare_trigger(2, 0.5, true);
ptb.schedule_audio;
ptb.schedule_trigger;
ptb.play_without_flip;



