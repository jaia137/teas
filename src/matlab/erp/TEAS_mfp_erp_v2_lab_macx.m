%% TEAS multifeature auditory oddball script
% o-ptb 

% Author: Patrick Neff, Ph.D., clinical neuroscience
% University of Zurich
% email address: schlaukeit@gmail.com  
% Website: 
% December 2020; Last revision: 18-Feb-2021

%% clear, init

%clear all global 

restoredefaultpath


%% add paths

addpath('C:\Program Files\MATLAB\R2016b\toolbox\o_ptb-master\') % change this to where o_ptb is on your system

addpath('C:\toolbox\Psychtoolbox\')

addpath('C:\Program Files\MATLAB\R2016b\toolbox\io\')

%% initialize PTB

o_ptb.init_ptb('C:\toolbox\Psychtoolbox\') % change this to where o_ptb is on your system


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

% ptb.setup_screen;   
ptb.setup_audio;
ptb.setup_trigger;

%%

config_io;

ioObj = io64;

status = io64(ioObj);

%
% if status = 0, you are now ready to write and read to a hardware port
% let's try sending the value=1 to the parallel printer's output port (LPT1)
address = hex2dec('d010');          %standard LPT1 output port address
data_out=0;                                 %sample data value
io64(ioObj,address,data_out);   %output command
%
% now, let's read that value back into MATLAB
% data_in=io64(ioObj,address);
%
% when finished with the io64 object it can be discarded via
% 'clear all', 'clear mex', 'clear io64' or 'clear functions' command.

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
%most critical: check dynamic range and loudness!
%also careful with one shot scripting, redo var names
%for smooth code, create a class and maybe package - or use proper instance
%copy with matlab.mixin.Copyable / copy()

% params
dur = 0.075; %stimulus duration
std_db = -107+sl_500+65; %standard SL + 60dB
rmp = 0.005; %standard ramp
sr = 44100;
amplitude = 1;
amplitude_par1 = 0.7354 ;
amplitude_par2 = 0.4626 ;
f0 = 500;
f1 = 1000;
f2 = 1500;

% 500
% standard
s1 = (amplitude * sin(2*pi*(1:(sr*0.075))/sr*f0)) ;
s2 = (amplitude_par1 * sin(2*pi*(1:(sr*0.075))/sr*f1)) ;
s3 = (amplitude_par2 * sin(2*pi*(1:(sr*0.075))/sr*f2)) ;

sx = (s1+s2+s3)/3;

s_500_st_10 = o_ptb.stimuli.auditory.FromMatrix(sx, sr);
s_500_st_10.db = std_db;
s_500_st_10.apply_cos_ramp(rmp);

% freq
% up
s1 = (amplitude * sin(2*pi*(1:(sr*0.075))/sr*(f0+(0.1*f0)))) ;
s2 = (amplitude_par1 * sin(2*pi*(1:(sr*0.075))/sr*(f1+(0.1*f1))));
s3 = (amplitude_par2 * sin(2*pi*(1:(sr*0.075))/sr*(f2+(0.1*f2)))) ;

sx = (s1+s2+s3)/3;

s_500_freq_up_11 = o_ptb.stimuli.auditory.FromMatrix(sx,sr);
s_500_freq_up_11.db = std_db;
s_500_freq_up_11.apply_cos_ramp(rmp);

% down
s1 = (amplitude * sin(2*pi*(1:(sr*0.075))/sr*(f0-(0.1*f0)))) ;
s2 = (amplitude_par1 * sin(2*pi*(1:(sr*0.075))/sr*(f1-(0.1*f1))));
s3 = (amplitude_par2 * sin(2*pi*(1:(sr*0.075))/sr*(f2-(0.1*f2)))) ;

sx = (s1+s2+s3)/3;

s_500_freq_down_12 = o_ptb.stimuli.auditory.FromMatrix(sx,sr);
s_500_freq_down_12.db = std_db;
s_500_freq_down_12.apply_cos_ramp(rmp);

% loudness

s1 = (amplitude * sin(2*pi*(1:(sr*0.075))/sr*f0)) ;
s2 = (amplitude_par1 * sin(2*pi*(1:(sr*0.075))/sr*f1)) ;
s3 = (amplitude_par2 * sin(2*pi*(1:(sr*0.075))/sr*f2)) ;

sx = (s1+s2+s3)/3;

s_500_loud_up_13 = o_ptb.stimuli.auditory.FromMatrix(sx,sr);
s_500_loud_up_13.db = std_db + 10;
s_500_loud_up_13.apply_cos_ramp(rmp);

s_500_loud_dwn_14 = o_ptb.stimuli.auditory.FromMatrix(sx,sr);
s_500_loud_dwn_14.db = std_db - 10;
s_500_loud_dwn_14.apply_cos_ramp(rmp);

%location 
s_500_loc_l_15 = o_ptb.stimuli.auditory.FromMatrix(sx,sr);	
s_500_loc_l_15.angle = -pi/2;
s_500_loc_l_15.db = std_db; 
s_500_loc_l_15.apply_cos_ramp(rmp);

s_500_loc_r_16 = o_ptb.stimuli.auditory.FromMatrix(sx,sr);	
s_500_loc_r_16.angle = pi/2;
s_500_loc_r_16.db = std_db; 
s_500_loc_r_16.apply_cos_ramp(rmp);

%duration
s1 = (amplitude * sin(2*pi*(1:(sr*0.025))/sr*f0)) ;
s2 = (amplitude_par1 * sin(2*pi*(1:(sr*0.025))/sr*f1)) ;
s3 = (amplitude_par2 * sin(2*pi*(1:(sr*0.025))/sr*f2)) ;

sx = (s1+s2+s3)/3;

s_500_dur_17 = o_ptb.stimuli.auditory.FromMatrix(sx,sr) ;
s_500_dur_17.db = std_db;
s_500_dur_17.apply_cos_ramp(rmp);


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


gap_1 = (amplitude * sin(2*pi*(1:(sr*0.035))/sr*f0)) .* r;
gap_11 = (amplitude_par1 * sin(2*pi*(1:(sr*0.035))/sr*f1)) .* r;
gap_12 = (amplitude_par2 * sin(2*pi*(1:(sr*0.035))/sr*f2)) .* r;

gap_1 = ((gap_1 + gap_11 + gap_12) / 3);

gap_2 = (amplitude * sin(2*pi*(1:(sr*0.035))/sr*f0)) .* r_z;
gap_21 = (amplitude_par1 * sin(2*pi*(1:(sr*0.035))/sr*f1)) .* r_z;
gap_22 = (amplitude_par2 * sin(2*pi*(1:(sr*0.035))/sr*f2)) .* r_z;

gap_2 = ((gap_2 + gap_21 + gap_22) / 3);

gap   = zeros(1,220)    ;

gap_x = [gap_1,gap,gap_2];

s_500_gap_18 = o_ptb.stimuli.auditory.FromMatrix(gap_x, sr);
s_500_gap_18.db = std_db;

%%%%%%%%%%%%%%%
% tin

tinf0 = tin_freq   ;
tinf1 = tin_freq*2 ;
tinf2 = tin_freq*3 ;

% standard
s1 = (amplitude * sin(2*pi*(1:(sr*0.075))/sr*tinf0)) ;
s2 = (amplitude_par1 * sin(2*pi*(1:(sr*0.075))/sr*tinf1)) ;
s3 = (amplitude_par2 * sin(2*pi*(1:(sr*0.075))/sr*tinf2)) ;

sx = (s1+s2+s3)/3;

s_tin_st_10 = o_ptb.stimuli.auditory.FromMatrix(sx, sr);
s_tin_st_10.db = std_db;
s_tin_st_10.apply_cos_ramp(rmp);

% freq
% up
s1 = (amplitude * sin(2*pi*(1:(sr*0.075))/sr*(tinf0+(0.1*tinf0)))) ;
s2 = (amplitude_par1 * sin(2*pi*(1:(sr*0.075))/sr*(tinf1+(0.1*tinf1))));
s3 = (amplitude_par2 * sin(2*pi*(1:(sr*0.075))/sr*(tinf2+(0.1*tinf2)))) ;

sx = (s1+s2+s3)/3;

s_tin_freq_up_11 = o_ptb.stimuli.auditory.FromMatrix(sx,sr);
s_tin_freq_up_11.db = std_db;
s_tin_freq_up_11.apply_cos_ramp(rmp);

% down
s1 = (amplitude * sin(2*pi*(1:(sr*0.075))/sr*(tinf0-(0.1*tinf0)))) ;
s2 = (amplitude_par1 * sin(2*pi*(1:(sr*0.075))/sr*(tinf1-(0.1*tinf1))));
s3 = (amplitude_par2 * sin(2*pi*(1:(sr*0.075))/sr*(tinf2-(0.1*tinf2)))) ;

sx = (s1+s2+s3)/3;

s_tin_freq_down_12 = o_ptb.stimuli.auditory.FromMatrix(sx,sr);
s_tin_freq_down_12.db = std_db;
s_tin_freq_down_12.apply_cos_ramp(rmp);

% loudness

s1 = (amplitude * sin(2*pi*(1:(sr*0.075))/sr*tinf0)) ;
s2 = (amplitude_par1 * sin(2*pi*(1:(sr*0.075))/sr*tinf1)) ;
s3 = (amplitude_par2 * sin(2*pi*(1:(sr*0.075))/sr*tinf2)) ;

sx = (s1+s2+s3)/3;

s_tin_loud_up_13 = o_ptb.stimuli.auditory.FromMatrix(sx,sr);
s_tin_loud_up_13.db = std_db + 10;
s_tin_loud_up_13.apply_cos_ramp(rmp);

s_tin_loud_dwn_14 = o_ptb.stimuli.auditory.FromMatrix(sx,sr);
s_tin_loud_dwn_14.db = std_db - 10;
s_tin_loud_dwn_14.apply_cos_ramp(rmp);

%location 
s_tin_loc_l_15 = o_ptb.stimuli.auditory.FromMatrix(sx,sr);	
s_tin_loc_l_15.angle = -pi/2;
s_tin_loc_l_15.db = std_db; 
s_tin_loc_l_15.apply_cos_ramp(rmp);

s_tin_loc_r_16 = o_ptb.stimuli.auditory.FromMatrix(sx,sr);	
s_tin_loc_r_16.angle = pi/2;
s_tin_loc_r_16.db = std_db; 
s_tin_loc_r_16.apply_cos_ramp(rmp);

%duration
s1 = (amplitude * sin(2*pi*(1:(sr*0.025))/sr*tinf0)) ;
s2 = (amplitude_par1 * sin(2*pi*(1:(sr*0.025))/sr*tinf1)) ;
s3 = (amplitude_par2 * sin(2*pi*(1:(sr*0.025))/sr*tinf2)) ;

sx = (s1+s2+s3)/3;

s_tin_dur_17 = o_ptb.stimuli.auditory.FromMatrix(sx,sr) ;
s_tin_dur_17.db = std_db;
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
gap_11 = (amplitude_par1 * sin(2*pi*(1:(sr*0.035))/sr*tinf1)) .* r;
gap_12 = (amplitude_par2 * sin(2*pi*(1:(sr*0.035))/sr*tinf2)) .* r;

gap_1 = ((gap_1 + gap_11 + gap_12) / 3);

gap_2 = (amplitude * sin(2*pi*(1:(sr*0.035))/sr*tinf0)) .* r_z;
gap_21 = (amplitude_par1 * sin(2*pi*(1:(sr*0.035))/sr*tinf1)) .* r_z;
gap_22 = (amplitude_par2 * sin(2*pi*(1:(sr*0.035))/sr*tinf2)) .* r_z;

gap_2 = ((gap_2 + gap_21 + gap_22) / 3);

gap   = zeros(1,220)    ;

gap_x = [gap_1,gap,gap_2];

s_tin_gap_18 = o_ptb.stimuli.auditory.FromMatrix(gap_x, sr);
s_tin_gap_18.db = std_db;

%% main block, pseudo random sequence init

% init rndm dev seq 500
dev_rnd = [1 2 3 4 5];
rng('shuffle');     % reset the time of the computer to create real randomisation with each new start of Matlab
dev_rnd_seq = [];

% init rndm dev seq tin
dev_rnd_tin = [1 2 3 4 5];
rng('shuffle');     % reset the time of the computer to create real randomisation with each new start of Matlab
dev_rnd_seq_tin = [];


%% single dev blocks, full rndm and no neighbors, dichotomous devs with 1/2 probability

% 500
for i = 1:60
    dev_rnd_seq(i).name = randperm(length(dev_rnd));
end

for j =2:60
    if dev_rnd_seq(j-1).name(5) == dev_rnd_seq(j).name(1)
      [dev_rnd_seq(j).name(2), dev_rnd_seq(j).name(1)] =  deal(dev_rnd_seq(j).name(1), dev_rnd_seq(j).name(2));
    end 
end

dev_sub_rnd = [1 2];

for k = 1:60
    dev_sub_rnd_seq(k).name = randperm(length(dev_sub_rnd));
end

% tin

for i = 1:60
    dev_rnd_seq_tin(i).name = randperm(length(dev_rnd_tin));
end

for j =2:60
    if dev_rnd_seq_tin(j-1).name(5) == dev_rnd_seq_tin(j).name(1)
      [dev_rnd_seq_tin(j).name(2), dev_rnd_seq_tin(j).name(1)] =  deal(dev_rnd_seq_tin(j).name(1), dev_rnd_seq_tin(j).name(2));
    end 
end

dev_sub_rnd_tin = [1 2];

for k = 1:60
    dev_sub_rnd_seq_tin(k).name = randperm(length(dev_sub_rnd_tin));
end



%% sub deviants

% init list
M=1;
N=60;

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


%% create final deviant stim matrix with sub deviants
%make more elegant, efficient: if any subfield = target number...

% 500
for i =1:60
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
    end
end

for i =1:60
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
    end
end

for i =1:60 
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
    end
end

for i =1:60 
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
    end
end

for i =1:60 
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
    end
end

% tin

for i =1:60
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
    end
end

for i =1:60
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
    end
end

for i =1:60 
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
    end
end

for i =1:60 
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
    end
end

for i =1:60 
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
    end
end

%% weave in standards, create final stim block lists

% 500
for i = 1:60
       dev_rnd_seq(i).name = [10 dev_rnd_seq(i).name(1) 10 dev_rnd_seq(i).name(2) ...
                           10 dev_rnd_seq(i).name(3) 10 dev_rnd_seq(i).name(4)...
                           10 dev_rnd_seq(i).name(5)];
end

% tin

for i = 1:60
       dev_rnd_seq_tin(i).name = [10 dev_rnd_seq_tin(i).name(1) 10 dev_rnd_seq_tin(i).name(2) ...
                           10 dev_rnd_seq_tin(i).name(3) 10 dev_rnd_seq_tin(i).name(4)...
                           10 dev_rnd_seq_tin(i).name(5)];
end

%% FINAL SEQUENCES, for 500 and TIN

dev_rnd_seq_500 = dev_rnd_seq;





%%
%% EXPERIMENT
%prep, screen needed? instructions?

WaitSecs(10);

% set isi
isi = 0.5;

% make trig struct
trigs = [];
for i = 1:9
    trigs(i) = 9+i ;
end


%% 500 HZ
% main trail, 615 reps

while(1)
    
for i = 1:15
        ptb.prepare_audio(s_500_st_10, isi, true);
        ptb.schedule_audio;
        ptb.play_without_flip;
        outp(address,trigs(1))
        WaitSecs(0.0009765625);
        outp(address,0);
end 

choice = menu('Press Yes to START or question the meaning of life...','Yes');
if choice==1
   disp('lezze go!');
end

WaitSecs(3);

for h = 1:3

for i = 1:15
        ptb.prepare_audio(s_500_st_10, isi, true);
        ptb.schedule_audio;
        ptb.play_without_flip;
        outp(address,trigs(1))
        WaitSecs(0.0009765625);
        outp(address,0);
end 

for i = 1:60
    for j = 1:10                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
        if dev_rnd_seq_500(i).name(j) == 10
            ptb.prepare_audio(s_500_st_10, isi, true)
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs(1)) 
            WaitSecs(0.0009765625);
            outp(address,0);
        elseif dev_rnd_seq_500(i).name(j) == 11
            ptb.prepare_audio(s_500_freq_up_11, isi, true)
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs(2)) 
                    WaitSecs(0.0009765625);
        outp(address,0);
        elseif dev_rnd_seq_500(i).name(j) == 12
            ptb.prepare_audio(s_500_freq_down_12, isi, true);
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs(3)) 
                    WaitSecs(0.0009765625);
        outp(address,0);
        elseif dev_rnd_seq_500(i).name(j) == 13
            ptb.prepare_audio(s_500_loud_up_13, isi, true);
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs(4)) 
                    WaitSecs(0.0009765625);
        outp(address,0);
        elseif dev_rnd_seq_500(i).name(j) == 14
            ptb.prepare_audio(s_500_loud_dwn_14, isi, true);
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs(5)) 
                    WaitSecs(0.0009765625);
        outp(address,0);
        elseif dev_rnd_seq_500(i).name(j) == 15
            ptb.prepare_audio(s_500_loc_l_15, isi, true);
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs(6))
                    WaitSecs(0.0009765625);
        outp(address,0);
        elseif dev_rnd_seq_500(i).name(j) == 16
            ptb.prepare_audio(s_500_loc_r_16, isi, true);
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs(7)) 
                    WaitSecs(0.0009765625);
        outp(address,0);
        elseif dev_rnd_seq_500(i).name(j) == 17
            ptb.prepare_audio(s_500_dur_17, isi, true);
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs(8)) 
                    WaitSecs(0.0009765625);
        outp(address,0);
        elseif dev_rnd_seq_500(i).name(j) == 18
            ptb.prepare_audio(s_500_gap_18, isi, true);
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs(9)) 
                    WaitSecs(0.0009765625);
        outp(address,0);
        end
    end 
end

WaitSecs(15);

end

choice = menu('Press Yes to CONTINUE or question the meaning of life...','Yes');
if choice==1
   disp('lezze go!');
end

WaitSecs(3);

% TINNITUS FREQ
% main trail, 600 reps

for h = 1:3

for i = 1:15
        ptb.prepare_audio(s_tin_st_10, isi, true);
        ptb.schedule_audio;
        ptb.play_without_flip;
        outp(address,trigs(1))
        WaitSecs(0.0009765625);
        outp(address,0);
end 

for i = 1:60
    for j = 1:10                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
        if dev_rnd_seq_tin(i).name(j) == 10 
            ptb.prepare_audio(s_tin_st_10, isi, true)
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs(1)) 
            WaitSecs(0.0009765625);
            outp(address,0);
        elseif dev_rnd_seq_tin(i).name(j) == 11
            ptb.prepare_audio(s_tin_freq_up_11, isi, true)
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs(2)) 
                    WaitSecs(0.0009765625);
        outp(address,0);
        elseif dev_rnd_seq_tin(i).name(j) == 12
            ptb.prepare_audio(s_tin_freq_down_12, isi, true);
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs(3)) 
                    WaitSecs(0.0009765625);
        outp(address,0);
        elseif dev_rnd_seq_tin(i).name(j) == 13
            ptb.prepare_audio(s_tin_loud_up_13, isi, true);
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs(4)) 
                    WaitSecs(0.0009765625);
        outp(address,0);
        elseif dev_rnd_seq_tin(i).name(j) == 14
            ptb.prepare_audio(s_tin_loud_dwn_14, isi, true);
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs(5)) 
                    WaitSecs(0.0009765625);
        outp(address,0);
        elseif dev_rnd_seq_tin(i).name(j) == 15
            ptb.prepare_audio(s_tin_loc_l_15, isi, true);
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs(6))
                    WaitSecs(0.0009765625);
        outp(address,0);
        elseif dev_rnd_seq_tin(i).name(j) == 16
            ptb.prepare_audio(s_tin_loc_r_16, isi, true);
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs(7)) 
                    WaitSecs(0.0009765625);
        outp(address,0);
        elseif dev_rnd_seq_tin(i).name(j) == 17
            ptb.prepare_audio(s_tin_dur_17, isi, true);
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs(8)) 
                    WaitSecs(0.0009765625);
        outp(address,0);
        elseif dev_rnd_seq_tin(i).name(j) == 18
            ptb.prepare_audio(s_tin_gap_18, isi, true);
            ptb.schedule_audio;
            ptb.play_without_flip;
            outp(address,trigs(9)) 
                    WaitSecs(0.0009765625);
        outp(address,0);
        end
    end 
end

WaitSecs(15);

end

disp('Done for today!');
break



end

%% addendum
%%%%%%%%%%%%

%% spectrogram, waveforms of stimuli

% wav_plots = who('s_500*');
% 
% for i = 1:9
% wav_plots{i}.plot_waveform;
% end

% s_500_st_10.plot_waveform
% s_500_freq_up_11.plot_waveform
% s_500_freq_down_12.plot_waveform
% s_500_loud_up_13.plot_waveform
% s_500_loud_dwn_14.plot_waveform
% s_500_loc_l_15.plot_waveform
% s_500_loc_r_16.plot_waveform
% s_500_dur_17.plot_waveform
% s_500_gap_18.plot_waveform
