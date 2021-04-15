%% PATHS, INIT

% cd(m1path);

addpath('C:\Users\pleiad\Documents\GitHub\fieldtrip');
addpath('C:\Users\pleiad\Documents\GitHub\teas\src\matlab\erp');
cd( 'C:\Users\pleiad\Desktop');
% cd((m1dir(i));    

ft_defaults


%% FILENAME

dataset = 'MD1312_EEG_erp_visittest.bdf';


%% CHECK EVENTS

event = ft_read_event(dataset);

sel =  find(strcmp({event.type}, 'STATUS'));
event = event(sel);

plot([event.sample], [event.value], '.')


%% LOAD, FILTER 1: ERP

cfg = [];
cfg.dataset = dataset;
cfg.trialdef.eventtype  = 'STATUS';
% cfg.trialdef.eventvalue = [1 2];
% cfg.continuous = 'yes';
cfg.trialdef.prestim    = 0;
cfg.trialdef.poststim   = 0.5;
% cfg.overlap = 0.125;

cfg = ft_definetrial(cfg);


cfg.channel = {'all','-1-EXG1', '-1-EXG2','-1-EXG3', '-1-EXG5','-1-EXG6', '-1-EXG7','-Status'};
cfg.dftfilter = 'yes';
cfg.dtfreq = [50 100 150];
%cfg.detrend = 'yes';
cfg.bpfilter = 'yes';
cfg.bpfreq = [1 30];  

cfg.reref = 'yes';
cfg.refchannel = {'1-EXG4', '1-EXG8'};
cfg.demean = 'yes';
cfg.baselinewindow = [-0.1 0];

data = ft_preprocessing(cfg);

% fix to somehow just have the exp trials (not pre run)
trl = cfg.trl;
trl = trl(76:3765,1:4); %make a generic remove test trial standards function, here the paradigm has been repeatedly restarted...

%% FIX channel labels 1 (run once, else deleted. go for if...)

for k = 1 : length(data.label)
    cellContents = data.label{k};
    data.label{k} = cellContents(3:end);
end

for j = 1 : length(data.cfg.channel)
    cellContents = data.cfg.channel{j};
    data.cfg.channel{j} = cellContents(3:end);
end


%% LOAD, FILTER 2: Continuous

cfg = [];
cfg.dataset = dataset;
% cfg.trialdef.eventtype  = 'STATUS';
% cfg.trialdef.eventvalue = [1 2];
cfg.continuous = 'yes';
% cfg.trialdef.prestim    = 0;
% cfg.trialdef.poststim   = 0.5;
% cfg.overlap = 0.125;

% cfg = ft_definetrial(cfg);


cfg.channel = {'all','-1-EXG1', '-1-EXG2','-1-EXG3', '-1-EXG5','-1-EXG6', '-1-EXG7','-Status'};
cfg.dftfilter = 'yes';
cfg.dtfreq = [50 100 150];
%cfg.detrend = 'yes';
cfg.bpfilter = 'yes';
cfg.bpfreq = [1 30];  

cfg.reref = 'yes';
cfg.refchannel = {'1-EXG4', '1-EXG8'};
cfg.demean = 'yes';
cfg.baselinewindow = [-0.1 0];

data_cont = ft_preprocessing(cfg);


%% FIX channel labels 2 (run once, else deleted. go for if...)

for k = 1 : length(data_cont.label)
    cellContents = data_cont.label{k};
    data_cont.label{k} = cellContents(3:end);
end

for j = 1 : length(data_cont.cfg.channel)
    cellContents = data_cont.cfg.channel{j};
    data_cont.cfg.channel{j} = cellContents(3:end);
end


%% RAW DATA INSPECT

cfg =[];
cfg.viewmode 	= 'butterfly';
% cfg.continuous = 'yes';
% cfg.channel = {'1-A1', '1-B3','1-EXG4', '1-EXG8'};

ft_databrowser(cfg, data_cont);

%% REMOVE REF CHANNELS EXG4/8

% data.label = data.label(1:128,:);
% data.cfg.channel = data.cfg.channel(1:128,:);
% 
% data_cont.label = data_cont.label(1:128,:);
% data_cont.cfg.channel = data_cont.cfg.channel(1:128,:);


%% PREP layout, elecs

cfg      = [];
cfg.layout = 'biosemi128_elec.elc';
cfg.unit = 'cm';

layout_eeg = ft_prepare_layout(cfg);

elec = ft_read_sens('biosemi128_elec.elc');

cfg = [];
cfg.layout = layout_eeg;

ft_layoutplot(cfg)

close all


%% PREP neighbours

cfg = [];
cfg.layout = layout_eeg;
% cfg.elec   = elec;
cfg.method = 'triangulation'; 
cfg.feedback = 'yes';

neighbours = ft_prepare_neighbours(cfg);

close all


%% PREPROC 1: Channels

cfg        = [];
cfg.metric = 'zvalue';  
cfg.method = 'summary'; 

data_badchan       = ft_rejectvisual(cfg, data);

removed_channels = setdiff(data.label,data_badchan.label);
    

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

% 500
cfg        = [];
cfg.trials = find(data_clean.trialinfo(:,1)==10);
avg_500_st = ft_timelockanalysis(cfg, data_clean);

cfg.trials = find(data_clean.trialinfo(:,1)==11);
avg_500_fu = ft_timelockanalysis(cfg, data_clean);

cfg.trials = find(data_clean.trialinfo(:,1)==12);
avg_500_fd = ft_timelockanalysis(cfg, data_clean);

cfg.trials = find(data_clean.trialinfo(:,1)==13);
avg_500_lu = ft_timelockanalysis(cfg, data_clean);

cfg.trials = find(data_clean.trialinfo(:,1)==14);
avg_500_ld = ft_timelockanalysis(cfg, data_clean);

cfg.trials = find(data_clean.trialinfo(:,1)==15);
avg_500_ll = ft_timelockanalysis(cfg, data_clean);

cfg.trials = find(data_clean.trialinfo(:,1)==16);
avg_500_lr = ft_timelockanalysis(cfg, data_clean);

cfg.trials = find(data_clean.trialinfo(:,1)==17);
avg_500_dr = ft_timelockanalysis(cfg, data_clean);

cfg.trials = find(data_clean.trialinfo(:,1)==18);
avg_500_gp = ft_timelockanalysis(cfg, data_clean);


% tin
cfg        = [];
cfg.trials = find(data_clean.trialinfo(:,1)==20);
avg_tin_st = ft_timelockanalysis(cfg, data_clean);

cfg.trials = find(data_clean.trialinfo(:,1)==21);
avg_tin_fu = ft_timelockanalysis(cfg, data_clean);

cfg.trials = find(data_clean.trialinfo(:,1)==22);
avg_tin_fd = ft_timelockanalysis(cfg, data_clean);

cfg.trials = find(data_clean.trialinfo(:,1)==23);
avg_tin_lu = ft_timelockanalysis(cfg, data_clean);

cfg.trials = find(data_clean.trialinfo(:,1)==24);
avg_tin_ld = ft_timelockanalysis(cfg, data_clean);

cfg.trials = find(data_clean.trialinfo(:,1)==25);
avg_tin_ll = ft_timelockanalysis(cfg, data_clean);

cfg.trials = find(data_clean.trialinfo(:,1)==26);
avg_tin_lr = ft_timelockanalysis(cfg, data_clean);

cfg.trials = find(data_clean.trialinfo(:,1)==27);
avg_tin_dr = ft_timelockanalysis(cfg, data_clean);

cfg.trials = find(data_clean.trialinfo(:,1)==28);
avg_tin_gp = ft_timelockanalysis(cfg, data_clean);


%% MULTIPLOT

cfg        = [];
cfg.layout = layout_eeg;
cfg.channel = {'all', '-COMNT','-EXG1', '-EXG2', '-EXG3', '-EXG4', '-EXG5', '-EXG6', '-EXG7', '-EXG8', '-STATUS'};

figure; ft_multiplotER(cfg, avg_500_st, avg_500_fu, avg_500_fd, avg_500_lu, avg_500_ld, avg_500_ll, avg_500_lr, avg_500_dr, avg_500_gp)

figure; ft_multiplotER(cfg, avg_tin_st, avg_tin_fu, avg_tin_fd, avg_tin_lu, avg_tin_ld, avg_tin_ll, avg_tin_lr, avg_tin_dr, avg_tin_gp)


%% SINGLEPLOT
% Cz

cfg= [];

cfg.trialdef.prestim    = 0.2;
cfg.trialdef.poststim   = 0.5;

cfg.channel = {'A1'};

figure; ft_singleplotER(cfg, avg_500_st, avg_500_fu, avg_500_fd, avg_500_lu, avg_500_ld, avg_500_ll, avg_500_lr, avg_500_dr, avg_500_gp);

figure; ft_singleplotER(cfg, avg_tin_st, avg_tin_fu, avg_tin_fd, avg_tin_lu, avg_tin_ld, avg_tin_ll, avg_tin_lr, avg_tin_dr, avg_tin_gp);


%% TOPOPLOT

cfg = [];
cfg.xlim = [0.08 0.1];
% cfg.zlim = [0 6e-14];
cfg.layout = layout_eeg;
% cfg.parameter = 'individual'; % the default 'avg' is not present in the data

figure; ft_topoplotER(cfg,avg_500_st, avg_500_fu, avg_500_fd, avg_500_lu, avg_500_ld, avg_500_ll, avg_500_lr, avg_500_dr, avg_500_gp); colorbar

figure; ft_topoplotER(cfg,avg_tin_st, avg_tin_fu, avg_tin_fd, avg_tin_lu, avg_tin_ld, avg_tin_ll, avg_tin_lr, avg_tin_dr, avg_tin_gp); colorbar

% pause(10);

% close all


%% SOURCE (only call when necessary!!!!!)

% chan_src = data_clean.label(1:128,:);

load standard_bem

cfg                 = [];
% cfg.channel         = data_clean.label; % ensure that rejected sensors are not present
cfg.elec            = elec;
cfg.resolution = 1;   % use a 3-D grid with a 1 cm resolution
cfg.unit       = 'cm';
cfg.headmodel       = vol;
cfg.reducerank = 3; % default for MEG is 2, for EEG is 3
% cfg.tight      = 'yes';
% cfg.normalize = 'yes';


[sourcemodel] = ft_prepare_leadfield(cfg);

% [grid] = ft_convert_units(grid, 'cm');


%% SAVE sourcemodel

save ('sourcemodel.mat','sourcemodel');


%% PLOT headmodel, grid, sensor
%PN: aufpassen, stimmen die units (mm/cm)

cfg = [];
figure;
ft_plot_vol(vol, 'edgecolor', 'black','facealpha', 0.1, 'unit', 'mm'); %alpha 0.4;
ft_plot_mesh(sourcemodel.pos(sourcemodel.inside,:));
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

%% SAVE electrode alignment

save ('elec_aligned.mat','elec_aligned');


%% %% SOURCEFILTER

cfg              = [];
cfg.elec        = elec_aligned;
cfg.method       = 'eloreta';
cfg.grid         = sourcemodel;
% cfg.mne.prewhiten = 'yes';
% cfg.mne.lambda    = 3;
% cfg.mne.scalesourcecov = 'yes';
cfg.headmodel    = vol;
% cfg.dics.projectnoise = 'yes';
% cfg.dics.lambda       = '10%';
% cfg.dics.keepfilter   = 'yes';
% cfg.dics.realfilter   = 'yes';

sourcefilt_ERP = ft_sourceanalysis(cfg, avg_500_lr);


%% SOURCE INTERPOL 

load standard_mri

cfg            = [];
cfg.parameter = 'all';                                                                                                                                                                              

sourcefilt_ERP_interp  = ft_sourceinterpolate(cfg, m, mri); 

%% VOLUME normalize

cfg = [];
cfg.nonlinear = 'no';
final = ft_volumenormalise(cfg, sourcefilt_ERP_interp);


%% PLOT MESH

m=sourcefilt_ERP; % plotting the result at the 450th time-point that is 500 ms after the zero time-point
m.avg.pow=sourcefilt_ERP.avg.pow(:,75);

ft_plot_mesh(m, 'vertexcolor','r');
view([180 0]); h = light; set(h, 'position', [0 1 0.2]); lighting gouraud; material dull


%% SOURCEPLOT

cfg = [];
cfg.method        = 'vertex';
cfg.funparameter  = 'pow';
cfg.funcolorlim   = 'maxabs';
% cfg.opacitylim    = [0 1e-4];
% cfg.opacitymap    = 'rampup';

ft_sourceplot(cfg, m);


%% 

cfg = [];
cfg.projectmom = 'yes';
sdFC  = ft_sourcedescriptives(cfg,sourcefilt_ERP);

cfg = [];
cfg.funparameter = 'pow';
ft_sourcemovie(cfg,sdFC);


%%

load standard_sourcemodel3d10mm.mat

figure
plot3(sourcemodel.pos(:,1), sourcemodel.pos(:,2), sourcemodel.pos(:,3), '.')
axis equal
axis vis3d
grid on


figure
ft_plot_mesh(sourcemodel)


%%

sourcemodel = ft_read_headshape('cortex_20484.surf.gii');

ft_plot_mesh(sourcemodel, 'facecolor', 'brain', 'edgecolor', 'none')
camlight
lighting gouraud



%% 

cfg = [];
cfg.method         = 'surface';
cfg.funparameter   = 'pow';
% cfg.maskparameter  = cfg.funparameter;
cfg.funcolorlim    = [0.0 1.2];
cfg.funcolormap    = 'jet';
cfg.opacitylim     = [0.0 1.2];
cfg.opacitymap     = 'rampup';
cfg.projmethod     = 'nearest';
cfg.surffile       = 'surface_white_both.mat'; % Cortical sheet from canonical MNI brain
cfg.surfdownsample = 10;  % downsample to speed up processing
ft_sourceplot(cfg, final);
view ([90 0])             % rotate the object in the view


%%


cfg = [];
cfg.method        = 'slice';
cfg.funparameter  = 'pow';
cfg.maskparameter = cfg.funparameter;
% cfg.funcolorlim   = [0.0 1.2];
% cfg.opacitylim    = [0.0 1.2];
cfg.opacitymap    = 'rampup';
ft_sourceplot(cfg, final);
