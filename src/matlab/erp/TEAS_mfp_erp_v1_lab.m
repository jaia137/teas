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


%% add path to o_ptb

addpath('C:\Program Files\MATLAB\R2016b\toolbox\o_ptb-master\') % change this to where o_ptb is on your system



%% initialize PTB

o_ptb.init_ptb('C:\toolbox\Psychtoolbox\') % change this to where o_ptb is on your system


%% config + instance o_ptb,

ptb_cfg = o_ptb.PTB_Config();

ptb_cfg.fullscreen = false;
ptb_cfg.window_scale = 0.2;
ptb_cfg.skip_sync_test = true;
ptb_cfg.hide_mouse = false;

ptb = o_ptb.PTB.get_instance(ptb_cfg);

%% test audio system, PTB vanilla

numchan =1;
freq = 44100;
reqlatencyclass = 0;

InitializePsychSound;

pahandle = PsychPortAudio('Open',[],2, reqlatencyclass, freq, numchan);

%% init systems

ptb_cfg.internal_config.final_resolution = [1980 1024];

% ptb.setup_screen;   
ptb.setup_audio;
ptb.setup_trigger;

%%
port = 'COM1';
DataBits = 8;
configString =(DataBits);


[handle, errmsg] = IOPort('OpenSerialPort', port, [configString]);
IOPort('ConfigureSerialPort', handle, configString);

%%

config_io;

ioObj = io64;

status = io64(ioObj);

%
% if status = 0, you are now ready to write and read to a hardware port
% let's try sending the value=1 to the parallel printer's output port (LPT1)
address = hex2dec('d010');          %standard LPT1 output port address
data_out=1;                                 %sample data value
io64(ioObj,address,data_out);   %output command
%
% now, let's read that value back into MATLAB
data_in=io64(ioObj,address);
%
% when finished with the io64 object it can be discarded via
% 'clear all', 'clear mex', 'clear io64' or 'clear functions' command.

%%

config_io;
% optional step: verify that the inpoutx64 driver was successfully initialized
global cogent;
if( cogent.io.status ~= 0 )
   error('inp/outp installation failed');
end
% write a value to the default LPT1 printer output port (at 0x378)
address = hex2dec('d010');
byte = 101;
outp(address,byte);
% read back the value written to the printer port above
datum=inp(address);

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

% standard
s_1000_st_10 = o_ptb.stimuli.auditory.Sine(1000, 0.075);	
s_1000_st_10.apply_cos_ramp(0.005);
s_1000_st_10.db = -100+sl_1000+70; %check dynamic range

% duration - add ramps
s_1000_dur_up_15 = s_1000_st_10;
s_1000_dur_up_15.db = s_1000_dur_up_15.db + 10;

s_1000_dur_dwn_15 = s_1000_st_10;
s_1000_dur_dwn_15.db = s_1000_dur_dwn_15.db - 10;



%% play it

ptb.prepare_audio(s_1000_st_10);
ptb.schedule_audio;
ptb.play_without_flip;

%% trigger

byte2 = 88;

for i = 1:100

ptb.prepare_audio(s_1000_st_10);
ptb.prepare_trigger(1);
outp(address,byte2)
ptb.prepare_audio(s_1000_st_10, 0.5, true);
ptb.prepare_trigger(2, 0.5, true);
ptb.schedule_audio;
ptb.schedule_trigger;
ptb.play_without_flip;
outp(address,byte)

 end




