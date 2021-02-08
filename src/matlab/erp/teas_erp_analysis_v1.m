%% PATHS

% cd(m1path);

addpath('C:\Users\pleiad\Documents\GitHub\fieldtrip');
cd 'C:\Users\pleiad\Desktop'
% cd((m1dir(i));    

%% FILENAME

dataset = 'tino2_erp.bdf';
   
%%  LOAD AND PREPROC

cfg = [];

cfg.dataset = dataset;

% cfg.trialdef.eventtype	= 'STATUS';
% cfg.trialdef.eventvalue = '60';
% cfg.trialdef.pre	= 0;
% cfg.trialdef.post	= 2;
%cfg.continuous		= 'no'; 
%cfg.dftfilter = 'yes';
%cfg.dtfreq = [50 100 150];
%cfg.detrend = 'yes';
% cfg.bpfilter = 'yes';
% cfg.bpfreq = [1 30];  
cfg.continuous		= 'yes';
% cfg.trialfun		= 'trialfuck';  
cfg.channel = {'1-A1','1-A2','1-A3','1-A4','1-A5','1-A6','1-A7','1-A8','1-A9','1-A10','1-A11','1-A12','1-A13','1-A14','1-A15','1-A16','1-A17','1-A18','1-A19','1-A20','1-A21','1-A22','1-A23','1-A24','1-A25','1-A26','1-A27','1-A28','1-A29','1-A30','1-A31','1-A32','1-B1','1-B2','1-B3','1-B4','1-B5','1-B6','1-B7','1-B8','1-B9','1-B10','1-B11','1-B12','1-B13','1-B14','1-B15','1-B16','1-B17','1-B18','1-B19','1-B20','1-B21','1-B22','1-B23','1-B24','1-B25','1-B26','1-B27','1-B28','1-B29','1-B30','1-B31','1-B32','STATUS'};
% cfg.layout		= 'biosemi_testin.lay';
% cfg 			= ft_definetrial(cfg);


% cfg.hdr = ft_read_header (dataset);
% cfg.channel = {'1-A1','1-A2','1-A3','1-A4','1-A5','1-A6','1-A7','1-A8','1-A9','1-A10','1-A11','1-A12','1-A13','1-A14','1-A15','1-A16','1-A17','1-A18','1-A19','1-A20','1-A21','1-A22','1-A23','1-A24','1-A25','1-A26','1-A27','1-A28','1-A29','1-A30','1-A31','1-A32','1-B1','1-B2','1-B3','1-B4','1-B5','1-B6','1-B7','1-B8','1-B9','1-B10','1-B11','1-B12','1-B13','1-B14','1-B15','1-B16','1-B17','1-B18','1-B19','1-B20','1-B21','1-B22','1-B23','1-B24','1-B25','1-B26','1-B27','1-B28','1-B29','1-B30','1-B31','1-B32'};
% cfg.channel = {'all'};
% cfg.hpfilter = 'yes';
% cfg.hpfreq = 1;



data = ft_preprocessing(cfg);
%%

event = ft_read_event(dataset);

sel =  find(strcmp({event.type}, 'STATUS'));
event = event(sel);

plot([event.sample], [event.value], '.')

%% TRIALS

cfg = [];
cfg.dataset                 = dataset;
% cfg.trialfun             = 'trialfuck';
%cfg.trialdef.triallength = 2;                   % in seconds
cfg.overlap = 0;
% cfg.trialdef.ntrials     = 120;                 % i.e. the complete file
cfg.trialdef.eventtype = 'TRIGGER';
cfg.trialdef.eventvalue = '1';
% cfg.trialdef.ntrials     = 3;
% cfg.trialdef.
cfg.trialdef.pre  = 0;
cfg.trialdef.post = 0.5;

[cfg] = ft_definetrial(cfg);                    % this creates 2-second data segments

trl = cfg.trl;

% EPOCHS

% cfg = [];
% % cfg.trials = ;
% data = ft_redefinetrial(cfg,data);
% % 
% clear trl

% SAVE

% fname = sprintf('43.mat');
% save(fname, 'data');
% 
% clear fname

%% RAW DATA INSPECT

% cfg =[];
% cfg.data = data;
cfg.channel = {'all'};
cfg.continuous 	= 'no';
cfg.blocksize 	= 2;
cfg.eventfile 	= [];
cfg.viewmode 	= 'vertical';

ft_databrowser(cfg, data);


%% FREQ

%    cfg = [];
    cfg.method = 'mtmfft';
    cfg.taper = 'hanning';
    cfg.tapsmofrq = 1;
    cfg.output = 'powandcsd';
    cfg.foi = [2 : 45]; 
cfg.keeptrials = 'yes';
%   cfg.trials = [1];
    freq       = ft_freqanalysis (cfg, data);
%     
%     freqlog = log(freq.powspctrm);


%%



%% IAFFT





cfg = [];
figure; ft_singleplotER(cfg,freq); %colorbar;


%% %% TOPOPLOT

cfg = [];                            
cfg.xlim = 'maxmin';  
cfg.xlim = [8 12];
cfg.zlim = 'maxmin';                
cfg.layout = 'biosemi_testin.lay';

figure; ft_topoplotTFR(cfg,freq); colorbar;

% ft_databrowser(cfg, data);





