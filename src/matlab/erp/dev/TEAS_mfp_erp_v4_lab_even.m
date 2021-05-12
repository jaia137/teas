%% TEAS multifeature auditory oddball script
% o-ptb 

% Author: Patrick Neff, Ph.D., clinical neuroscience
% University of Zurich
% email address: schlaukeit@gmail.com  
% Website: 
% December 2020; Last revision: 17-Mar-2021

%% clear, init

%clear all global 

restoredefaultpath

%% add paths

addpath('C:\Program Files\MATLAB\R2016b\toolbox\o_ptb-master\') 

addpath('C:\toolbox\Psychtoolbox\')

addpath('C:\Program Files\MATLAB\R2016b\toolbox\io\')


%% initialize PTB

o_ptb.init_ptb('C:\toolbox\Psychtoolbox\') 


%% config + instance o_ptb,

ptb_cfg = o_ptb.PTB_Config();

ptb_cfg.fullscreen = false;
ptb_cfg.window_scale = 0.2;
ptb_cfg.skip_sync_test = true;
ptb_cfg.hide_mouse = false;
ptb_cfg.psychportaudio_config.freq = 44100;
ptb_cfg.psychportaudio_config.device = 8;


ptb = o_ptb.PTB.get_instance(ptb_cfg);


%% init systems

ptb_cfg.internal_config.final_resolution = [1980 1024];

ptb.setup_audio;
ptb.setup_trigger;


%% init trigger system

config_io;

ioObj = io64;
status = io64(ioObj);
address = hex2dec('d010');          
data_out=0;                  

io64(ioObj,address,data_out);   


%% STIMULI 
%% get tinnitus frequency

tf      = inputdlg('Individuelle Tinnitusfrequenz:',...
                   'Bitte eingeben',[1 50]);
tin_freq = str2num(tf{:});  


%% get sensation levels

prompt = {'Sensation level 500 Hz:','Sensation level Tinnitus:'};
dlg_title = 'Input';
num_lines = 1;
answer = inputdlg(prompt,dlg_title,num_lines);

sl_all = answer;

sl_500 = str2num(answer{1});
sl_tin = str2num(answer{2});


%% create stimuli, standard and deviants

% constants
dur = 0.075; %stimulus duration, standard
std_db_500 = -107+sl_500+40; %standard SL + 40dB

% fix hard upper limit, for loud up deviantm 95 db
if std_db_500 >=  0
    std_db_500 = -11;
end

std_db_tin = -107+sl_tin+60; %tinnitus SL + 60dB

% fix hard upper limit, for loud up deviant 95 db
if std_db_tin >=  0
    std_db_tin = -11;
end

rmp = 0.005; %standard ramp

% standard
s_500_st_10 = o_ptb.stimuli.auditory.Sine(500, dur);	
s_500_st_10.db = std_db_500; %check dynamic range
s_500_st_10.apply_cos_ramp(rmp);

% freq
s_500_freq_up_11 = o_ptb.stimuli.auditory.Sine(500+0.1*500, dur);
s_500_freq_up_11.db = std_db_500;
s_500_freq_up_11.apply_cos_ramp(rmp);

s_500_freq_down_12 = o_ptb.stimuli.auditory.Sine(500-0.1*500, dur);
s_500_freq_down_12.db = std_db_500;
s_500_freq_down_12.apply_cos_ramp(rmp);

% loudness
s_500_loud_up_13 = o_ptb.stimuli.auditory.Sine(500, dur);
s_500_loud_up_13.db = std_db_500 + 10;
s_500_loud_up_13.apply_cos_ramp(rmp);

s_500_loud_dwn_14 = o_ptb.stimuli.auditory.Sine(500, dur);
s_500_loud_dwn_14.db = std_db_500 - 10;
s_500_loud_dwn_14.apply_cos_ramp(rmp);

%location
s_500_loc_l_15 = o_ptb.stimuli.auditory.Sine(500, dur);	
s_500_loc_l_15.angle = -pi/2;
% s_500_loc_l_17.muted_channels = 2;
s_500_loc_l_15.db = std_db_500; 
s_500_loc_l_15.apply_cos_ramp(rmp);

s_500_loc_r_16 = o_ptb.stimuli.auditory.Sine(500, dur);	
s_500_loc_r_16.angle = pi/2;
% s_500_loc_r_17.muted_channels = 1;
s_500_loc_r_16.db = std_db_500; 
s_500_loc_r_16.apply_cos_ramp(rmp);

%duration
s_500_dur_17 = o_ptb.stimuli.auditory.Sine(500, dur-0.05);
s_500_dur_17.db = std_db_500;
s_500_dur_17.apply_cos_ramp(rmp);

% gap
%ugly code, pls fix, 3307.5 samples @44,1, gap1=1543.5 , gap =220/221,
%gap2=1543.5

sr = 44100;
amplitude = 1;
t = floor(sr * 0.005);
t2 = floor(sr * 0.001);

r = 1 - cos(linspace(0, pi/2, t));
ra = 1 - cos(linspace(pi/2, 0, t/5));
r = [r, ones(1, 1279), ra];

r_z = 1 - cos(linspace(pi/2, 0, t));
rb = 1 - cos(linspace(0, pi/2, t/5));
r_z = [rb, ones(1, 1279), r_z]; 


gap_1 = (amplitude * sin(2*pi*(1:(sr*0.035))/sr*500)) .* r;
gap   = zeros(1,220)    ;
gap_2 = (amplitude * sin(2*pi*(1:(sr*0.035))/sr*500)) .* r_z;

gap_x = [gap_1,gap,gap_2];

s_500_gap_18 = o_ptb.stimuli.auditory.FromMatrix(gap_x, 44100);
s_500_gap_18.db = std_db_500;

% noise

% params
dur = 0.075; %stimulus duration
std_db = -107+sl_500+65; %standard SL + 60dB
rmp = 0.005; %standard ramp
sr = 44100;
amplitude = 1;
amplitude_noise = 0.0158 ;
f0 = 500;
n = floor(sr * dur);  

%tone
s1 = (amplitude * sin(2*pi*(1:(sr*0.075))/sr*f0)) ;

%noise
rand('state',sum(100 * clock));    % initialize random seed
noise = randn(1, n); 

s_noise = amplitude_noise .* noise;

s_noise_comb = s_noise + s1;

s_500_ns_19 = o_ptb.stimuli.auditory.FromMatrix(s_noise_comb, dur);	
s_500_ns_19.db = std_db_500; %check dynamic range
s_500_ns_19.apply_cos_ramp(rmp);


%%%%%%%%%%%%%%%
% tin

tinf0 = tin_freq   ;


% standard
s1 = (amplitude * sin(2*pi*(1:(sr*0.075))/sr*tinf0)) ;

s_tin_st_10 = o_ptb.stimuli.auditory.FromMatrix(s1, sr);
s_tin_st_10.db = std_db_tin;
s_tin_st_10.apply_cos_ramp(rmp);

% freq
% up
s1 = (amplitude * sin(2*pi*(1:(sr*0.075))/sr*(tinf0+(0.1*tinf0)))) ;

s_tin_freq_up_11 = o_ptb.stimuli.auditory.FromMatrix(s1,sr);
s_tin_freq_up_11.db = std_db_tin;
s_tin_freq_up_11.apply_cos_ramp(rmp);

% down
s1 = (amplitude * sin(2*pi*(1:(sr*0.075))/sr*(tinf0-(0.1*tinf0)))) ;

s_tin_freq_down_12 = o_ptb.stimuli.auditory.FromMatrix(s1,sr);
s_tin_freq_down_12.db = std_db_tin;
s_tin_freq_down_12.apply_cos_ramp(rmp);

% loudness

s1 = (amplitude * sin(2*pi*(1:(sr*0.075))/sr*tinf0)) ;

s_tin_loud_up_13 = o_ptb.stimuli.auditory.FromMatrix(s1,sr);
s_tin_loud_up_13.db = std_db_tin + 10;
s_tin_loud_up_13.apply_cos_ramp(rmp);

s_tin_loud_dwn_14 = o_ptb.stimuli.auditory.FromMatrix(s1,sr);
s_tin_loud_dwn_14.db = std_db_tin - 10;
s_tin_loud_dwn_14.apply_cos_ramp(rmp);

%location 
s_tin_loc_l_15 = o_ptb.stimuli.auditory.FromMatrix(s1,sr);	
s_tin_loc_l_15.angle = -pi/2;
s_tin_loc_l_15.db = std_db_tin; 
s_tin_loc_l_15.apply_cos_ramp(rmp);

s_tin_loc_r_16 = o_ptb.stimuli.auditory.FromMatrix(s1,sr);	
s_tin_loc_r_16.angle = pi/2;
s_tin_loc_r_16.db = std_db_tin; 
s_tin_loc_r_16.apply_cos_ramp(rmp);

%duration
s1 = (amplitude * sin(2*pi*(1:(sr*0.025))/sr*tinf0)) ;


s_tin_dur_17 = o_ptb.stimuli.auditory.FromMatrix(s1,sr) ;
s_tin_dur_17.db = std_db_tin;
s_tin_dur_17.apply_cos_ramp(rmp);


% gap
%ugly code, pls fix, 3307.5 samples @44,1, gap1=1543.5 , gap =220/221,
%gap2=1543.5

t = floor(sr * 0.005);
t2 = floor(sr * 0.001);

r = 1 - cos(linspace(0, pi/2, t));
ra = 1 - cos(linspace(pi/2, 0, t/5));
r = [r, ones(1, 1279), ra];

r_z = 1 - cos(linspace(pi/2, 0, t));
rb = 1 - cos(linspace(0, pi/2, t/5));
r_z = [rb, ones(1, 1279), r_z]; 


gap_1 = (amplitude * sin(2*pi*(1:(sr*0.035))/sr*tinf0)) .* r;

gap_2 = (amplitude * sin(2*pi*(1:(sr*0.035))/sr*tinf0)) .* r_z;

gap   = zeros(1,220)    ;

gap_x = [gap_1,gap,gap_2];

s_tin_gap_18 = o_ptb.stimuli.auditory.FromMatrix(gap_x, sr);
s_tin_gap_18.db = std_db_tin;

%noise

s1 = (amplitude * sin(2*pi*(1:(sr*0.075))/sr*tin_freq)) ;

%noise
rand('state',sum(100 * clock));    % initialize random seed
noise = randn(1, n); 

s_noise = amplitude_noise .* noise;

s_noise_comb = s_noise + s1;

s_tin_ns_19 = o_ptb.stimuli.auditory.FromMatrix(s_noise_comb, dur);	
s_tin_ns_19.db = std_db_500; %check dynamic range
s_tin_ns_19.apply_cos_ramp(rmp);


%% main block, pseudo random sequence init

% init rndm dev seq 500
dev_rnd = [1 2 3 4 5 6];
rng('default');     % reset the time of the computer to create real randomisation with each new start of Matlab
dev_rnd_seq = [];

% init rndm dev seq tin
dev_rnd_tin = [1 2 3 4 5 6];
rng('default');     % reset the time of the computer to create real randomisation with each new start of Matlab
dev_rnd_seq_tin = [];


%% single dev blocks, full rndm and no neighbors, dichotomous devs with 1/2 probability

% 500
%create random stim struct

for i = 1:180
    dev_rnd_seq(i).name = randperm(length(dev_rnd));
end

%eliminate identical sequence neighbours
for j =2:180
    if dev_rnd_seq(j-1).name(6) == dev_rnd_seq(j).name(1)
      [dev_rnd_seq(j).name(2), dev_rnd_seq(j).name(1)] =  deal(dev_rnd_seq(j).name(1), dev_rnd_seq(j).name(2));
    end 
end

%create deviant sub struct
dev_sub_rnd = [1 2];

for k = 1:180
    dev_sub_rnd_seq(k).name = randperm(length(dev_sub_rnd));
end

% tin
%create random stim struct
for i = 1:180
    dev_rnd_seq_tin(i).name = randperm(length(dev_rnd_tin));
end

%eliminate identical sequence neighbours
for j =2:180
    if dev_rnd_seq_tin(j-1).name(6) == dev_rnd_seq_tin(j).name(1)
      [dev_rnd_seq_tin(j).name(2), dev_rnd_seq_tin(j).name(1)] =  deal(dev_rnd_seq_tin(j).name(1), dev_rnd_seq_tin(j).name(2));
    end 
end

%create deviant sub struct
dev_sub_rnd_tin = [1 2];

for k = 1:180
    dev_sub_rnd_seq_tin(k).name = randperm(length(dev_sub_rnd_tin));
end



%% sub deviants*

% init list
M=1;
N=180;

% frq 500
d_f = (mod( reshape(randperm(M*N), M, N), 2 ))';

for i = 1:numel(d_f)
    if d_f(i) == 0
        d_f(i) = 11;
    else
        d_f(i) = 12;
    end
end

% loud
d_l = (mod( reshape(randperm(M*N), M, N), 2 ))';

for i = 1:numel(d_l)
    if d_l(i) == 0
        d_l(i) = 13;
    else
        d_l(i) = 14;
    end
end

% loc
d_lo = (mod( reshape(randperm(M*N), M, N), 2 ))';

for i = 1:numel(d_lo)
    if d_lo(i) == 0
        d_lo(i) = 15;
    else
        d_lo(i) = 16;
    end
end

% frq tin
d_f_tin = (mod( reshape(randperm(M*N), M, N), 2 ))';

for i = 1:numel(d_f_tin)
    if d_f_tin(i) == 0
        d_f_tin(i) = 11;
    else
        d_f_tin(i) = 12;
    end
end

% loud
d_l_tin = (mod( reshape(randperm(M*N), M, N), 2 ))';

for i = 1:numel(d_l_tin)
    if d_l_tin(i) == 0
        d_l_tin(i) = 13;
    else
        d_l_tin(i) = 14;
    end
end

% loc
d_lo_tin = (mod( reshape(randperm(M*N), M, N), 2 ))';

for i = 1:numel(d_lo_tin)
    if d_lo_tin(i) == 0
        d_lo_tin(i) = 15;
    else
        d_lo_tin(i) = 16;
    end
end


%% create final deviant stim matrix with sub deviants*
%make more elegant, efficient: if any subfield = target number...

% 500
for i =1:180
    if dev_rnd_seq(i).name(1) == 1
       dev_rnd_seq(i).name(1) = d_f(i);
    elseif dev_rnd_seq(i).name(2) == 1  
       dev_rnd_seq(i).name(2) = d_f(i);
    elseif dev_rnd_seq(i).name(3) == 1  
       dev_rnd_seq(i).name(3) = d_f(i);
    elseif dev_rnd_seq(i).name(4) == 1  
       dev_rnd_seq(i).name(4) = d_f(i);
    elseif dev_rnd_seq(i).name(5) == 1  
       dev_rnd_seq(i).name(5) = d_f(i);
     elseif dev_rnd_seq(i).name(6) == 1  
       dev_rnd_seq(i).name(6) = d_f(i);
    end
end

for i =1:180
    if dev_rnd_seq(i).name(1) == 2
       dev_rnd_seq(i).name(1) = d_l(i);
    elseif dev_rnd_seq(i).name(2) == 2  
       dev_rnd_seq(i).name(2) = d_l(i);
    elseif dev_rnd_seq(i).name(3) == 2  
       dev_rnd_seq(i).name(3) = d_l(i);
    elseif dev_rnd_seq(i).name(4) == 2  
       dev_rnd_seq(i).name(4) = d_l(i);
    elseif dev_rnd_seq(i).name(5) == 2  
       dev_rnd_seq(i).name(5) = d_l(i);
            elseif dev_rnd_seq(i).name(6) == 2  
       dev_rnd_seq(i).name(6) = d_l(i);
    end
end

for i =1:180 
    if dev_rnd_seq(i).name(1) == 3
       dev_rnd_seq(i).name(1) = d_lo(i);
    elseif dev_rnd_seq(i).name(2) == 3  
       dev_rnd_seq(i).name(2) = d_lo(i);
    elseif dev_rnd_seq(i).name(3) == 3  
       dev_rnd_seq(i).name(3) = d_lo(i);
    elseif dev_rnd_seq(i).name(4) == 3  
       dev_rnd_seq(i).name(4) = d_lo(i);
    elseif dev_rnd_seq(i).name(5) == 3  
       dev_rnd_seq(i).name(5) = d_lo(i);
            elseif dev_rnd_seq(i).name(6) == 3  
       dev_rnd_seq(i).name(6) = d_lo(i);
    end
end

for i =1:180 
    if dev_rnd_seq(i).name(1) == 4
       dev_rnd_seq(i).name(1) = 17;
    elseif dev_rnd_seq(i).name(2) == 4  
       dev_rnd_seq(i).name(2) = 17;
    elseif dev_rnd_seq(i).name(3) == 4  
       dev_rnd_seq(i).name(3) = 17;
    elseif dev_rnd_seq(i).name(4) == 4  
       dev_rnd_seq(i).name(4) = 17;
    elseif dev_rnd_seq(i).name(5) == 4  
       dev_rnd_seq(i).name(5) = 17;
            elseif dev_rnd_seq(i).name(6) == 4  
       dev_rnd_seq(i).name(6) = 17;
    end
end

for i =1:180 
    if dev_rnd_seq(i).name(1) == 5
       dev_rnd_seq(i).name(1) = 18;
    elseif dev_rnd_seq(i).name(2) == 5  
       dev_rnd_seq(i).name(2) = 18;
    elseif dev_rnd_seq(i).name(3) == 5 
       dev_rnd_seq(i).name(3) = 18;
    elseif dev_rnd_seq(i).name(4) == 5  
       dev_rnd_seq(i).name(4) = 18;
    elseif dev_rnd_seq(i).name(5) == 5
       dev_rnd_seq(i).name(5) = 18;
                   elseif dev_rnd_seq(i).name(6) == 5  
       dev_rnd_seq(i).name(6) = 18;
    end
end

for i =1:180 
    if dev_rnd_seq(i).name(1) == 6
       dev_rnd_seq(i).name(1) = 19;
    elseif dev_rnd_seq(i).name(2) == 6  
       dev_rnd_seq(i).name(2) = 19;
    elseif dev_rnd_seq(i).name(3) == 6 
       dev_rnd_seq(i).name(3) = 19;
    elseif dev_rnd_seq(i).name(4) == 6  
       dev_rnd_seq(i).name(4) = 19;
    elseif dev_rnd_seq(i).name(5) == 6
       dev_rnd_seq(i).name(5) = 19;
    elseif dev_rnd_seq(i).name(6) == 6  
       dev_rnd_seq(i).name(6) = 19;
    end
end

% tin

for i =1:180
    if dev_rnd_seq_tin(i).name(1) == 1
       dev_rnd_seq_tin(i).name(1) = d_f_tin(i);
    elseif dev_rnd_seq_tin(i).name(2) == 1  
       dev_rnd_seq_tin(i).name(2) = d_f_tin(i);
    elseif dev_rnd_seq_tin(i).name(3) == 1  
       dev_rnd_seq_tin(i).name(3) = d_f_tin(i);
    elseif dev_rnd_seq_tin(i).name(4) == 1  
       dev_rnd_seq_tin(i).name(4) = d_f_tin(i);
    elseif dev_rnd_seq_tin(i).name(5) == 1  
       dev_rnd_seq_tin(i).name(5) = d_f_tin(i);
    elseif dev_rnd_seq_tin(i).name(6) == 1  
       dev_rnd_seq_tin(i).name(6) = d_f_tin(i);
    end
end

for i =1:180
    if dev_rnd_seq_tin(i).name(1) == 2
       dev_rnd_seq_tin(i).name(1) = d_l_tin(i);
    elseif dev_rnd_seq_tin(i).name(2) == 2  
       dev_rnd_seq_tin(i).name(2) = d_l_tin(i);
    elseif dev_rnd_seq_tin(i).name(3) == 2  
       dev_rnd_seq_tin(i).name(3) = d_l_tin(i);
    elseif dev_rnd_seq_tin(i).name(4) == 2  
       dev_rnd_seq_tin(i).name(4) = d_l_tin(i);
    elseif dev_rnd_seq_tin(i).name(5) == 2  
       dev_rnd_seq_tin(i).name(5) = d_l_tin(i);
    elseif dev_rnd_seq_tin(i).name(6) == 2  
       dev_rnd_seq_tin(i).name(6) = d_l_tin(i);
    end
end

for i =1:180 
    if dev_rnd_seq_tin(i).name(1) == 3
       dev_rnd_seq_tin(i).name(1) = d_lo_tin(i);
    elseif dev_rnd_seq_tin(i).name(2) == 3  
       dev_rnd_seq_tin(i).name(2) = d_lo_tin(i);
    elseif dev_rnd_seq_tin(i).name(3) == 3  
       dev_rnd_seq_tin(i).name(3) = d_lo_tin(i);
    elseif dev_rnd_seq_tin(i).name(4) == 3  
       dev_rnd_seq_tin(i).name(4) = d_lo_tin(i);
    elseif dev_rnd_seq_tin(i).name(5) == 3  
       dev_rnd_seq_tin(i).name(5) = d_lo_tin(i);
           elseif dev_rnd_seq_tin(i).name(6) == 3  
       dev_rnd_seq_tin(i).name(6) = d_lo_tin(i);
    end
end

for i =1:180 
    if dev_rnd_seq_tin(i).name(1) == 4
       dev_rnd_seq_tin(i).name(1) = 17;
    elseif dev_rnd_seq_tin(i).name(2) == 4  
       dev_rnd_seq_tin(i).name(2) = 17;
    elseif dev_rnd_seq_tin(i).name(3) == 4  
       dev_rnd_seq_tin(i).name(3) = 17;
    elseif dev_rnd_seq_tin(i).name(4) == 4  
       dev_rnd_seq_tin(i).name(4) = 17;
    elseif dev_rnd_seq_tin(i).name(5) == 4  
       dev_rnd_seq_tin(i).name(5) = 17;
    elseif dev_rnd_seq_tin(i).name(6) == 4  
       dev_rnd_seq_tin(i).name(6) = 17;
    end
end

for i =1:180 
    if dev_rnd_seq_tin(i).name(1) == 5
       dev_rnd_seq_tin(i).name(1) = 18;
    elseif dev_rnd_seq_tin(i).name(2) == 5  
       dev_rnd_seq_tin(i).name(2) = 18;
    elseif dev_rnd_seq_tin(i).name(3) == 5 
       dev_rnd_seq_tin(i).name(3) = 18;
    elseif dev_rnd_seq_tin(i).name(4) == 5  
       dev_rnd_seq_tin(i).name(4) = 18;
    elseif dev_rnd_seq_tin(i).name(5) == 5
       dev_rnd_seq_tin(i).name(5) = 18;
    elseif dev_rnd_seq_tin(i).name(6) == 5  
       dev_rnd_seq_tin(i).name(6) = 18;
    end
end

for i =1:180 
    if dev_rnd_seq_tin(i).name(1) == 6
       dev_rnd_seq_tin(i).name(1) = 19;
    elseif dev_rnd_seq_tin(i).name(2) == 6  
       dev_rnd_seq_tin(i).name(2) = 19;
    elseif dev_rnd_seq_tin(i).name(3) == 6 
       dev_rnd_seq_tin(i).name(3) = 19;
    elseif dev_rnd_seq_tin(i).name(4) == 6  
       dev_rnd_seq_tin(i).name(4) = 19;
    elseif dev_rnd_seq_tin(i).name(5) == 6
       dev_rnd_seq_tin(i).name(5) = 19;
    elseif dev_rnd_seq_tin(i).name(6) == 6  
       dev_rnd_seq_tin(i).name(6) = 19;
    end
end

%% weave in standards, create final stim block lists

% 500
for i = 1:180
       dev_rnd_seq(i).name = [10 dev_rnd_seq(i).name(1) 10 dev_rnd_seq(i).name(2) ...
                           10 dev_rnd_seq(i).name(3) 10 dev_rnd_seq(i).name(4)...
                           10 dev_rnd_seq(i).name(5) 10 dev_rnd_seq(i).name(6)];
end

% tin

for i = 1:180
       dev_rnd_seq_tin(i).name = [10 dev_rnd_seq_tin(i).name(1) 10 dev_rnd_seq_tin(i).name(2) ...
                           10 dev_rnd_seq_tin(i).name(3) 10 dev_rnd_seq_tin(i).name(4)...
                           10 dev_rnd_seq_tin(i).name(5) 10 dev_rnd_seq_tin(i).name(6)];
end
  

%% FINAL SEQUENCES, for 500 and TIN

dev_rnd_seq_500 = dev_rnd_seq;

%%
%% EXPERIMENT
%prep, screen needed? instructions?

WaitSecs(5);

% set params
% isi = 0.5;
soaall = 0.424 ;
soadur = 0.374 ;
triglen = 0.0009765625 ; 


% make trig struct
trigs_500 = [];
for i = 1:10
    trigs_500(i) = 9+i ;
end

trigs_tin = [];
for i = 1:10
    trigs_tin(i) = 19+i ;
end


%% 500 HZ*
% main trail, 615 reps

while(1)
    
for i = 1:15
        ptb.prepare_audio(s_500_st_10);
        ptb.schedule_audio;
        ptb.play_without_flip;
        outp(address,trigs_500(1))
        WaitSecs(triglen);
        outp(address,0);
        WaitSecs(soaall);

end 




choice = menu('Press Yes to START or question the meaning of life...','Yes');
if choice==1
   disp('lezze go!');
end


WaitSecs(3);

for i = 1:15
        ptb.prepare_audio(s_tin_st_10);
        ptb.schedule_audio;
        ptb.play_without_flip;
        outp(address,trigs_tin(1))
        WaitSecs(triglen);
        outp(address,0);
        WaitSecs(soaall);
end 

for i = 1:60
    for j = 1:10                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
        if dev_rnd_seq_tin(i).name(j) == 10 
            ptb.prepare_audio(s_tin_st_10)
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs_tin(1)) 
            WaitSecs(triglen);
            outp(address,0);
            WaitSecs(soaall);
        elseif dev_rnd_seq_tin(i).name(j) == 11
            ptb.prepare_audio(s_tin_freq_up_11)
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs_tin(2)) 
            WaitSecs(triglen);
            outp(address,0);
            WaitSecs(soaall);
        elseif dev_rnd_seq_tin(i).name(j) == 12
            ptb.prepare_audio(s_tin_freq_down_12);
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs_tin(3)) 
            WaitSecs(triglen);
            outp(address,0);
            WaitSecs(soaall);
        elseif dev_rnd_seq_tin(i).name(j) == 13
            ptb.prepare_audio(s_tin_loud_up_13);
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs_tin(4)) 
            WaitSecs(triglen);
            outp(address,0);
            WaitSecs(soaall);
        elseif dev_rnd_seq_tin(i).name(j) == 14
            ptb.prepare_audio(s_tin_loud_dwn_14);
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs_tin(5)) 
            WaitSecs(triglen);
            outp(address,0);
            WaitSecs(soaall);
        elseif dev_rnd_seq_tin(i).name(j) == 15
            ptb.prepare_audio(s_tin_loc_l_15);
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs_tin(6))
            WaitSecs(triglen);
            outp(address,0);
            WaitSecs(soaall);
        elseif dev_rnd_seq_tin(i).name(j) == 16
            ptb.prepare_audio(s_tin_loc_r_16);
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs_tin(7)) 
            WaitSecs(triglen);
            outp(address,0);
            WaitSecs(soaall);
        elseif dev_rnd_seq_tin(i).name(j) == 17
            ptb.prepare_audio(s_tin_dur_17);
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs_tin(8)) 
            WaitSecs(triglen);
            outp(address,0);
            WaitSecs(soadur);
        elseif dev_rnd_seq_tin(i).name(j) == 18
            ptb.prepare_audio(s_tin_gap_18);
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs_tin(9)) 
            WaitSecs(triglen);
            outp(address,0);
            WaitSecs(soaall);
        elseif dev_rnd_seq_tin(i).name(j) == 19
            ptb.prepare_audio(s_tin_ns_19);
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs_tin(10)) 
            WaitSecs(triglen);
            outp(address,0);
            WaitSecs(soaall);
        end
    end 
end

WaitSecs(10);

for i = 1:15
        ptb.prepare_audio(s_500_st_10);
        ptb.schedule_audio;
        ptb.play_without_flip;
        outp(address,trigs_500(1))
            WaitSecs(triglen);
            outp(address,0);
            WaitSecs(soaall);
end 

for i = 1:60
    for j = 1:10                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
        if dev_rnd_seq_500(i).name(j) == 10
            ptb.prepare_audio(s_500_st_10)
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs_500(1)) 
            WaitSecs(triglen);
            outp(address,0);
            WaitSecs(soaall);
        elseif dev_rnd_seq_500(i).name(j) == 11
            ptb.prepare_audio(s_500_freq_up_11)
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs_500(2)) 
            WaitSecs(triglen);
            outp(address,0);
            WaitSecs(soaall);
        elseif dev_rnd_seq_500(i).name(j) == 12
            ptb.prepare_audio(s_500_freq_down_12);
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs_500(3)) 
            WaitSecs(triglen);
            outp(address,0);
            WaitSecs(soaall);
        elseif dev_rnd_seq_500(i).name(j) == 13
            ptb.prepare_audio(s_500_loud_up_13);
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs_500(4)) 
            WaitSecs(triglen);
            outp(address,0);
            WaitSecs(soaall);
        elseif dev_rnd_seq_500(i).name(j) == 14
            ptb.prepare_audio(s_500_loud_dwn_14);
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs_500(5)) 
            WaitSecs(triglen);
            outp(address,0);
            WaitSecs(soaall);
        elseif dev_rnd_seq_500(i).name(j) == 15
            ptb.prepare_audio(s_500_loc_l_15);
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs_500(6))
            WaitSecs(triglen);
            outp(address,0);
            WaitSecs(soaall);
        elseif dev_rnd_seq_500(i).name(j) == 16
            ptb.prepare_audio(s_500_loc_r_16);
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs_500(7)) 
            WaitSecs(triglen);
            outp(address,0);
            WaitSecs(soaall);
        elseif dev_rnd_seq_500(i).name(j) == 17
            ptb.prepare_audio(s_500_dur_17);
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs_500(8)) 
            WaitSecs(triglen);
            outp(address,0);
            WaitSecs(soadur);
        elseif dev_rnd_seq_500(i).name(j) == 18
            ptb.prepare_audio(s_500_gap_18);
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs_500(9)) 
            WaitSecs(triglen);
            outp(address,0);
            WaitSecs(soaall);
        elseif dev_rnd_seq_500(i).name(j) == 19
            ptb.prepare_audio(s_500_ns_19);
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs_500(10)) 
            WaitSecs(triglen);
            outp(address,0);
            WaitSecs(soaall);
        end
    end 
end

WaitSecs(10);

for i = 1:15
        ptb.prepare_audio(s_tin_st_10);
        ptb.schedule_audio;
        ptb.play_without_flip;
        outp(address,trigs_tin(1))
            WaitSecs(triglen);
            outp(address,0);
            WaitSecs(soaall);
end 

for i = 61:120
    for j = 1:10                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
        if dev_rnd_seq_tin(i).name(j) == 10 
            ptb.prepare_audio(s_tin_st_10)
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs_tin(1)) 
            WaitSecs(triglen);
            outp(address,0);
            WaitSecs(soaall);
        elseif dev_rnd_seq_tin(i).name(j) == 11
            ptb.prepare_audio(s_tin_freq_up_11)
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs_tin(2)) 
            WaitSecs(triglen);
            outp(address,0);
            WaitSecs(soaall);
        elseif dev_rnd_seq_tin(i).name(j) == 12
            ptb.prepare_audio(s_tin_freq_down_12);
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs_tin(3)) 
            WaitSecs(triglen);
            outp(address,0);
            WaitSecs(soaall);
        elseif dev_rnd_seq_tin(i).name(j) == 13
            ptb.prepare_audio(s_tin_loud_up_13);
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs_tin(4)) 
            WaitSecs(triglen);
            outp(address,0);
            WaitSecs(soaall);
        elseif dev_rnd_seq_tin(i).name(j) == 14
            ptb.prepare_audio(s_tin_loud_dwn_14);
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs_tin(5)) 
            WaitSecs(triglen);
            outp(address,0);
            WaitSecs(soaall);
        elseif dev_rnd_seq_tin(i).name(j) == 15
            ptb.prepare_audio(s_tin_loc_l_15);
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs_tin(6))
            WaitSecs(triglen);
            outp(address,0);
            WaitSecs(soaall);
        elseif dev_rnd_seq_tin(i).name(j) == 16
            ptb.prepare_audio(s_tin_loc_r_16);
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs_tin(7)) 
            WaitSecs(triglen);
            outp(address,0);
            WaitSecs(soaall);
        elseif dev_rnd_seq_tin(i).name(j) == 17
            ptb.prepare_audio(s_tin_dur_17);
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs_tin(8)) 
            WaitSecs(triglen);
            outp(address,0);
            WaitSecs(soadur);
        elseif dev_rnd_seq_tin(i).name(j) == 18
            ptb.prepare_audio(s_tin_gap_18);
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs_tin(9)) 
            WaitSecs(triglen);
            outp(address,0);
            WaitSecs(soaall);
        elseif dev_rnd_seq_tin(i).name(j) == 19
            ptb.prepare_audio(s_tin_ns_19);
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs_tin(10)) 
            WaitSecs(triglen);
            outp(address,0);
            WaitSecs(soaall);
        end
    end 
end


choice = menu('Press Yes to CONTINUE or question the meaning of life...','Yes');
if choice==1
   disp('lezze go!');
end

WaitSecs(3);

% 500 FREQ
% main trail, 600 reps

%
for i = 1:15
        ptb.prepare_audio(s_500_st_10);
        ptb.schedule_audio;
        ptb.play_without_flip;
        outp(address,trigs_500(1))
            WaitSecs(triglen);
            outp(address,0);
            WaitSecs(soaall);
end 

for i = 61:120
    for j = 1:10                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
        if dev_rnd_seq_500(i).name(j) == 10
            ptb.prepare_audio(s_500_st_10)
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs_500(1)) 
            WaitSecs(triglen);
            outp(address,0);
            WaitSecs(soaall);
        elseif dev_rnd_seq_500(i).name(j) == 11
            ptb.prepare_audio(s_500_freq_up_11)
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs_500(2)) 
            WaitSecs(triglen);
            outp(address,0);
            WaitSecs(soaall);
        elseif dev_rnd_seq_500(i).name(j) == 12
            ptb.prepare_audio(s_500_freq_down_12);
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs_500(3)) 
            WaitSecs(triglen);
            outp(address,0);
            WaitSecs(soaall);
        elseif dev_rnd_seq_500(i).name(j) == 13
            ptb.prepare_audio(s_500_loud_up_13);
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs_500(4)) 
            WaitSecs(triglen);
            outp(address,0);
            WaitSecs(soaall);
        elseif dev_rnd_seq_500(i).name(j) == 14
            ptb.prepare_audio(s_500_loud_dwn_14);
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs_500(5)) 
            WaitSecs(triglen);
            outp(address,0);
            WaitSecs(soaall);
        elseif dev_rnd_seq_500(i).name(j) == 15
            ptb.prepare_audio(s_500_loc_l_15);
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs_500(6))
            WaitSecs(triglen);
            outp(address,0);
            WaitSecs(soaall);
        elseif dev_rnd_seq_500(i).name(j) == 16
            ptb.prepare_audio(s_500_loc_r_16);
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs_500(7)) 
            WaitSecs(triglen);
            outp(address,0);
            WaitSecs(soaall);
        elseif dev_rnd_seq_500(i).name(j) == 17
            ptb.prepare_audio(s_500_dur_17);
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs_500(8)) 
            WaitSecs(triglen);
            outp(address,0);
            WaitSecs(soadur);
        elseif dev_rnd_seq_500(i).name(j) == 18
            ptb.prepare_audio(s_500_gap_18);
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs_500(9)) 
            WaitSecs(triglen);
            outp(address,0);
            WaitSecs(soaall);
        elseif dev_rnd_seq_500(i).name(j) == 19
            ptb.prepare_audio(s_500_ns_19);
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs_500(10)) 
            WaitSecs(triglen);
            outp(address,0);
            WaitSecs(soaall);
        end
    end 
end

WaitSecs(10);

for i = 1:15
        ptb.prepare_audio(s_tin_st_10);
        ptb.schedule_audio;
        ptb.play_without_flip;
        outp(address,trigs_tin(1))
            WaitSecs(triglen);
            outp(address,0);
            WaitSecs(soaall);
end 

for i = 121:180
    for j = 1:10                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
        if dev_rnd_seq_tin(i).name(j) == 10 
            ptb.prepare_audio(s_tin_st_10)
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs_tin(1)) 
            WaitSecs(triglen);
            outp(address,0);
            WaitSecs(soaall);
        elseif dev_rnd_seq_tin(i).name(j) == 11
            ptb.prepare_audio(s_tin_freq_up_11)
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs_tin(2)) 
            WaitSecs(triglen);
            outp(address,0);
            WaitSecs(soaall);
        elseif dev_rnd_seq_tin(i).name(j) == 12
            ptb.prepare_audio(s_tin_freq_down_12);
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs_tin(3)) 
            WaitSecs(triglen);
            outp(address,0);
            WaitSecs(soaall);
        elseif dev_rnd_seq_tin(i).name(j) == 13
            ptb.prepare_audio(s_tin_loud_up_13);
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs_tin(4)) 
            WaitSecs(triglen);
            outp(address,0);
            WaitSecs(soaall);
        elseif dev_rnd_seq_tin(i).name(j) == 14
            ptb.prepare_audio(s_tin_loud_dwn_14);
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs_tin(5)) 
            WaitSecs(triglen);
            outp(address,0);
            WaitSecs(soaall);
        elseif dev_rnd_seq_tin(i).name(j) == 15
            ptb.prepare_audio(s_tin_loc_l_15);
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs_tin(6))
            WaitSecs(triglen);
            outp(address,0);
            WaitSecs(soaall);
        elseif dev_rnd_seq_tin(i).name(j) == 16
            ptb.prepare_audio(s_tin_loc_r_16);
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs_tin(7)) 
            WaitSecs(triglen);
            outp(address,0);
            WaitSecs(soaall);
        elseif dev_rnd_seq_tin(i).name(j) == 17
            ptb.prepare_audio(s_tin_dur_17);
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs_tin(8)) 
            WaitSecs(triglen);
            outp(address,0);
            WaitSecs(soadur);
        elseif dev_rnd_seq_tin(i).name(j) == 18
            ptb.prepare_audio(s_tin_gap_18);
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs_tin(9)) 
            WaitSecs(triglen);
            outp(address,0);
            WaitSecs(soaall);
        elseif dev_rnd_seq_tin(i).name(j) == 19
            ptb.prepare_audio(s_tin_ns_19);
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs_tin(10)) 
            WaitSecs(triglen);
            outp(address,0);
            WaitSecs(soaall);
        end
    end 
end

WaitSecs(10);

for i = 1:15
        ptb.prepare_audio(s_500_st_10);
        ptb.schedule_audio;
        ptb.play_without_flip;
        outp(address,trigs_500(1))
            WaitSecs(triglen);
            outp(address,0);
            WaitSecs(soaall);
end 

for i = 121:180
    for j = 1:10                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
        if dev_rnd_seq_500(i).name(j) == 10
            ptb.prepare_audio(s_500_st_10)
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs_500(1)) 
            WaitSecs(triglen);
            outp(address,0);
            WaitSecs(soaall);
        elseif dev_rnd_seq_500(i).name(j) == 11
            ptb.prepare_audio(s_500_freq_up_11)
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs_500(2)) 
            WaitSecs(triglen);
            outp(address,0);
            WaitSecs(soaall);
        elseif dev_rnd_seq_500(i).name(j) == 12
            ptb.prepare_audio(s_500_freq_down_12);
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs_500(3)) 
            WaitSecs(triglen);
            outp(address,0);
            WaitSecs(soaall);
        elseif dev_rnd_seq_500(i).name(j) == 13
            ptb.prepare_audio(s_500_loud_up_13);
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs_500(4)) 
            WaitSecs(triglen);
            outp(address,0);
            WaitSecs(soaall);
        elseif dev_rnd_seq_500(i).name(j) == 14
            ptb.prepare_audio(s_500_loud_dwn_14);
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs_500(5)) 
            WaitSecs(triglen);
            outp(address,0);
            WaitSecs(soaall);
        elseif dev_rnd_seq_500(i).name(j) == 15
            ptb.prepare_audio(s_500_loc_l_15);
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs_500(6))
            WaitSecs(triglen);
            outp(address,0);
            WaitSecs(soaall);
        elseif dev_rnd_seq_500(i).name(j) == 16
            ptb.prepare_audio(s_500_loc_r_16);
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs_500(7)) 
            WaitSecs(triglen);
            outp(address,0);
            WaitSecs(soaall);
        elseif dev_rnd_seq_500(i).name(j) == 17
            ptb.prepare_audio(s_500_dur_17);
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs_500(8)) 
            WaitSecs(triglen);
            outp(address,0);
            WaitSecs(soadur);
        elseif dev_rnd_seq_500(i).name(j) == 18
            ptb.prepare_audio(s_500_gap_18);
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs_500(9)) 
            WaitSecs(triglen);
            outp(address,0);
            WaitSecs(soaall);
        elseif dev_rnd_seq_500(i).name(j) == 19
            ptb.prepare_audio(s_500_ns_19);
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs_500(10)) 
            WaitSecs(triglen);
            outp(address,0);
            WaitSecs(soaall);
        end
    end 
end



disp('Done for today!');
break

end

