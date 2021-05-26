%% PATHS, INIT

% cd(m1path);

addpath('C:\Users\EEG_SUM\Documents\MATLAB\fieldtrip-20170119');
cd( 'G:\');
% cd((m1dir(i));    

ft_defaults


%% FILENAME

dataset = 'v4.bdf';


%% CHECK EVENTS

event = ft_read_event(dataset);

sel =  find(strcmp({event.type}, 'STATUS'));
event = event(sel);

plot([event.sample], [event.value], '.')


%% LOAD, FILTER

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

% fix to somehow just have the exp trials (not pre run)
trl = cfg.trl;
trl = trl(76:3765,1:4); %make a generic remove test trial standards function, here the paradigm has been repeatedly restarted...

%% FIX channel labels (run once, else deleted. go for if...)

for k = 1 : length(data.label)
    cellContents = data.label{k};
    data.label{k} = cellContents(3:end);
end

for j = 1 : length(data.cfg.channel)
    cellContents = data.cfg.channel{j};
    data.cfg.channel{j} = cellContents(3:end);
end

%% RAW DATA INSPECT

cfg =[];
cfg.viewmode 	= 'vertical';

ft_databrowser(cfg, data);


%% PREP layout, elecs

cfg      = [];
cfg.elec = 'biosemi128_elec.elc';
layout_eeg = ft_prepare_layout(cfg);

elec = ft_read_sens('biosemi128_elec.elc');

cfg = [];
cfg.layout = layout_eeg;
ft_layoutplot(cfg)


%% PREP neighbours

cfg = [];
cfg.layout = layout_eeg;
% cfg.elec   = elec;
cfg.method = 'triangulation'; 
cfg.feedback = 'yes';

neighbours = ft_prepare_neighbours(cfg);


%% PREPROC 1: Channels

cfg        = [];
cfg.metric = 'zvalue';  
cfg.method = 'summary'; 

data_badchan       = ft_rejectvisual(cfg, data);

removed_channels = setdiff(data.label,data_badchan.cfg.channel);


%% INTERPOLATE badchan

cfg = [];
cfg.method         =  'weighted'; %'weighted', 'average', 'spline', 'slap' or 'nan' (default = 'weighted')
cfg.badchannel     = removed_channels;
cfg.elec           = elec;
cfg.missingchannel = []; %cell-array, see FT_CHANNELSELECTION for details
cfg.neighbours     = neighbours; %neighbourhood structure, see also FT_PREPARE_NEIGHBOURS

data_interp = ft_channelrepair(cfg, data_badchan);


%% PREPROC 2: Trials

cfg        = [];
cfg.metric = 'zvalue';  
cfg.method = 'summary'; 

data_clean       = ft_rejectvisual(cfg, data_interp);


%% SAVE clean data

save ('data_clean.mat','data_clean','-v7.3');


%% MAKE ERPs

cfg        = [];
cfg.trials = find(data_clean.trialinfo(:,1)==10);
cfg.preproc.demean = 'yes';
cfg.preproc.baselinewindow = [-0.1 0];
avg_500_st = ft_timelockanalysis(cfg, data_clean);

cfg.trials = find(data_clean.trialinfo(:,1)==11);
cfg.preproc.demean = 'yes';
cfg.preproc.baselinewindow = [-0.1 0];
avg_500_fu = ft_timelockanalysis(cfg, data_clean);

cfg.trials = find(data_clean.trialinfo(:,1)==12);
cfg.preproc.demean = 'yes';
cfg.preproc.baselinewindow = [-0.1 0];
avg_500_fd = ft_timelockanalysis(cfg, data_clean);

cfg.trials = find(data_clean.trialinfo(:,1)==13);
cfg.preproc.demean = 'yes';
cfg.preproc.baselinewindow = [-0.1 0];
avg_500_lu = ft_timelockanalysis(cfg, data_clean);

cfg.trials = find(data_clean.trialinfo(:,1)==14);
cfg.preproc.demean = 'yes';
cfg.preproc.baselinewindow = [-0.1 0];
avg_500_ld = ft_timelockanalysis(cfg, data_clean);

cfg.trials = find(data_clean.trialinfo(:,1)==15);
cfg.preproc.demean = 'yes';
cfg.preproc.baselinewindow = [-0.1 0];
avg_500_ll = ft_timelockanalysis(cfg, data_clean);

cfg.trials = find(data_clean.trialinfo(:,1)==16);
cfg.preproc.demean = 'yes';
cfg.preproc.baselinewindow = [-0.1 0];
avg_500_lr = ft_timelockanalysis(cfg, data_clean);

cfg.trials = find(data_clean.trialinfo(:,1)==17);
cfg.preproc.demean = 'yes';
cfg.preproc.baselinewindow = [-0.1 0];
avg_500_dr = ft_timelockanalysis(cfg, data_clean);

cfg.trials = find(data_clean.trialinfo(:,1)==18);
cfg.preproc.demean = 'yes';
cfg.preproc.baselinewindow = [-0.1 0];
avg_500_gp = ft_timelockanalysis(cfg, data_clean);


%% MULTIPLOT

cfg        = [];
cfg.layout = layout_eeg;
cfg.channel = {'all', '-COMNT','-EXG1', '-EXG2', '-EXG3', '-EXG4', '-EXG5', '-EXG6', '-EXG7', '-EXG8', '-STATUS'};

figure; ft_multiplotER(cfg, avg_500_st, avg_500_fu, avg_500_fd, avg_500_lu, avg_500_ld, avg_500_ll, avg_500_lr, avg_500_dr, avg_500_gp)


%% SINGLEPLOT
% Cz

cfg= [];
cfg.channel = {'A1'};

ft_singleplotER(cfg, avg_500_st, avg_500_fu, avg_500_fd, avg_500_lu, avg_500_ld, avg_500_ll, avg_500_lr, avg_500_dr, avg_500_gp);


%% TOPOPLOT

cfg = [];
cfg.xlim = [0.0 0.2];
% cfg.zlim = [0 6e-14];
cfg.layout = layout_eeg;
% cfg.parameter = 'individual'; % the default 'avg' is not present in the data
figure; ft_topoplotER(cfg,avg_500_st, avg_500_fu, avg_500_fd, avg_500_lu, avg_500_ld, avg_500_ll, avg_500_lr, avg_500_dr, avg_500_gp); colorbar


%% SOURCE

cfg                 = [];
% cfg.channel         = data_clean.label; % ensure that rejected sensors are not present
cfg.elec            = elec;
cfg.headmodel       = vol;
cfg.reducerank = 3; % default for MEG is 2, for EEG is 3
cfg.resolution = 1;   % use a 3-D grid with a 1 cm resolution
cfg.unit       = 'cm';
% cfg.tight      = 'yes';
cfg.normalize = 'yes';


[grid] = ft_prepare_leadfield(cfg);
% [grid] = ft_convert_units(grid, 'mm');


%% PLOT headmodel, grid, sensor
%PN: aufpassen, stimmen die units (mm/cm)

cfg = [];
figure;
ft_plot_vol(vol, 'edgecolor', 'black','facealpha', 0.1, 'unit', 'mm'); %alpha 0.4;
ft_plot_mesh(grid.pos(grid.inside,:));
ft_plot_sens(elec, 'style', 'g*');
    
    
% head surface (scalp)
ft_plot_mesh(vol.bnd(1), 'edgecolor','none','facealpha',0.8,'facecolor',[0.6 0.6 0.8]); 
hold on;
% electrodes
ft_plot_sens(elec,'style', 'g*');

    
%% REALIGN if needed

cfg           = [];
cfg.method    = 'interactive';
cfg.elec      = elec;
cfg.headshape = vol.bnd(1);
elec_aligned  = ft_electroderealign(cfg);
