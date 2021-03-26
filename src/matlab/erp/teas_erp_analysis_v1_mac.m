%% PATHS

% cd(m1path);

addpath('/Users/shanti/Documents/GitHub/fieldtrip');
cd( '/Users/shanti/Desktop');
% cd((m1dir(i));    

ft_defaults

%% FILENAME

dataset = 'MD1312_EEG_erp_visittest.bdf';


%% CHECK EVENTS

event = ft_read_event(dataset);

sel =  find(strcmp({event.type}, 'STATUS'));
event = event(sel);

plot([event.sample], [event.value], '.')

%% TRIALS and LOAD/PREPROC

cfg = [];
cfg.dataset = dataset;               
% cfg.overlap = 1;
cfg.trialdef.eventtype = 'STATUS';
cfg.trialdef.pre  = 0;
cfg.trialdef.post = 0.5;

cfg = ft_definetrial(cfg);                  

trl = cfg.trl;

trl = trl(76:3765,1:4); %make a generic remove test trial standards function, here the paradigm has been repeatedly restarted...

% 

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
% cfg.continuous		= 'yes';
% cfg.trialfun		= 'trialfuck';  
%cfg.channel = {'1-A1','1-A2','1-A3','1-A4','1-A5','1-A6','1-A7','1-A8','1-A9','1-A10','1-A11','1-A12','1-A13','1-A14','1-A15','1-A16','1-A17','1-A18','1-A19','1-A20','1-A21','1-A22','1-A23','1-A24','1-A25','1-A26','1-A27','1-A28','1-A29','1-A30','1-A31','1-A32','1-B1','1-B2','1-B3','1-B4','1-B5','1-B6','1-B7','1-B8','1-B9','1-B10','1-B11','1-B12','1-B13','1-B14','1-B15','1-B16','1-B17','1-B18','1-B19','1-B20','1-B21','1-B22','1-B23','1-B24','1-B25','1-B26','1-B27','1-B28','1-B29','1-B30','1-B31','1-B32','STATUS'};
% cfg.layout		= 'biosemi_testin.lay';
% cfg 			= ft_definetrial(cfg);


% cfg.hdr = ft_read_header (dataset);
% cfg.channel = {'1-A1','1-A2','1-A3','1-A4','1-A5','1-A6','1-A7','1-A8','1-A9','1-A10','1-A11','1-A12','1-A13','1-A14','1-A15','1-A16','1-A17','1-A18','1-A19','1-A20','1-A21','1-A22','1-A23','1-A24','1-A25','1-A26','1-A27','1-A28','1-A29','1-A30','1-A31','1-A32','1-B1','1-B2','1-B3','1-B4','1-B5','1-B6','1-B7','1-B8','1-B9','1-B10','1-B11','1-B12','1-B13','1-B14','1-B15','1-B16','1-B17','1-B18','1-B19','1-B20','1-B21','1-B22','1-B23','1-B24','1-B25','1-B26','1-B27','1-B28','1-B29','1-B30','1-B31','1-B32'};
% cfg.channel = {'all'};
% cfg.hpfilter = 'yes';
% cfg.hpfreq = 1;

data = ft_preprocessing(cfg);

%% RAW DATA INSPECT

cfg =[];
% cfg.channel = {'all'};
% cfg.continuous 	= 'yes';
% % cfg.blocksize 	= 2;
% cfg.eventfile 	= event;
cfg.viewmode 	= 'vertical';

ft_databrowser(cfg, data);


%%


cfg = [];
cfg.layout = 'biosemi128.lay';
ft_layoutplot(cfg)



%%

cfg = [];
cfg.dataset = dataset;
cfg.trialdef.eventtype  = 'STATUS';
% cfg.trialdef.eventvalue = [1 2];
cfg.trialdef.prestim    = 0.1;
cfg.trialdef.poststim   = 0.5;
% cfg.overlap = 0.125;
cfg = ft_definetrial(cfg);

cfg.dftfilter = 'yes';
cfg.dtfreq = [50 100 150];
%cfg.detrend = 'yes';
cfg.bpfilter = 'yes';
cfg.bpfreq = [1 30];  

cfg.reref = 'yes';
cfg.refchannel = {'1-EXG4', '1-EXG8'};
% cfg.demean = 'yes';
% cfg.baselinewindow = [-0.2 0];


data = ft_preprocessing(cfg);

% cfg = [];
% timelock = ft_timelockanalysis(cfg, data);


%%

cfg        = [];
cfg.trials = find(data.trialinfo(:,1)==10);
cfg.preproc.demean = 'yes';
cfg.preproc.baselinewindow = [-0.1 0];
avg_500_st = ft_timelockanalysis(cfg, data);

cfg.trials = find(data.trialinfo(:,1)==11);
cfg.preproc.demean = 'yes';
cfg.preproc.baselinewindow = [-0.1 0];
avg_500_fu = ft_timelockanalysis(cfg, data);

cfg.trials = find(data.trialinfo(:,1)==12);
cfg.preproc.demean = 'yes';
cfg.preproc.baselinewindow = [-0.1 0];
avg_500_fd = ft_timelockanalysis(cfg, data);

cfg.trials = find(data.trialinfo(:,1)==13);
cfg.preproc.demean = 'yes';
cfg.preproc.baselinewindow = [-0.1 0];
avg_500_lu = ft_timelockanalysis(cfg, data);

cfg.trials = find(data.trialinfo(:,1)==14);
cfg.preproc.demean = 'yes';
cfg.preproc.baselinewindow = [-0.1 0];
avg_500_ld = ft_timelockanalysis(cfg, data);

cfg.trials = find(data.trialinfo(:,1)==15);
cfg.preproc.demean = 'yes';
cfg.preproc.baselinewindow = [-0.1 0];
avg_500_ll = ft_timelockanalysis(cfg, data);

cfg.trials = find(data.trialinfo(:,1)==16);
cfg.preproc.demean = 'yes';
cfg.preproc.baselinewindow = [-0.1 0];
avg_500_lr = ft_timelockanalysis(cfg, data);

cfg.trials = find(data.trialinfo(:,1)==17);
cfg.preproc.demean = 'yes';
cfg.preproc.baselinewindow = [-0.1 0];
avg_500_dr = ft_timelockanalysis(cfg, data);

cfg.trials = find(data.trialinfo(:,1)==18);
cfg.preproc.demean = 'yes';
cfg.preproc.baselinewindow = [-0.1 0];
avg_500_gp = ft_timelockanalysis(cfg, data);



%%

% create an EEG channel layout on-the-fly and visualise the eeg data
cfg      = [];
cfg.layout = 'biosemi128.lay';
layout_eeg = ft_prepare_layout(cfg);

cfg        = [];
cfg.layout = layout_eeg;
cfg.channel = {'all', '-SCALE', '-COMNT'};
figure; ft_multiplotER(cfg, avg_500_st, avg_500_fu, avg_500_fd, avg_500_lu, avg_500_ld, avg_500_ll, avg_500_lr, avg_500_dr, avg_500_gp);


%%

cfg= [];
cfg.channel = {'1-A1'};


ft_singleplotER(cfg, avg_500_st, avg_500_fu, avg_500_fd, avg_500_lu, avg_500_ld, avg_500_ll, avg_500_lr, avg_500_dr, avg_500_gp);












