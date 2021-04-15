%% CLEAR - DEFAULT - PATH

% <<<<<<< HEAD
addpath('C:\Users\pleiad\Downloads\fieldtrip-20181231');
%addpath(genpath('/beam/aaeeg_eeg'));
%addpath(genpath('/Users/shanti/Documents/GitHub/exp_aaeeg/'));%source script folder
%cd '/beam/aaeeg_eeg/WN' %source file folder
% =======
% addpath('/Users/stefan/Documents/MATLAB/Toolboxes/fieldtrip-20180704');
% addpath(genpath('/Users/stefan/Desktop/AAEEG_EEG/WN_cleaned(exclusion)'));
% cd '/Users/stefan/Desktop/AAEEG_EEG/WN_cleaned(exclusion)'
% >>>>>>> 4d6bec9fc4e9421dbac4c0cebea6726486ece283

ft_defaults;

set(0,'DefaultFigureColormap',hot); %set colormap to hot

clear all;



%% %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%
%%%SOURCE (beamformer,boundary element, chris philipps)
% PN :http://www.fieldtriptoolbox.org/tutorial/beamformer/ etc.

%% %% FREQANALYSIS FOR SOURCE ESTIMATION
%PN: check if mtmconvol method is suitable and doable in source space  -->
%it is not!

%% just once!!!!!!!!!
%load xy_post noise RI
cd '/Users/stefan/Desktop/AAEEG_EEG/noise_50' %<<<<<<<<<<<<<<<<<<<

files = dir('*_post.mat');

for i=1:length(files)
cfg = [];
cfg.inputfile = files(i).name;
cfg.detrend = "no";

data = ft_preprocessing(cfg);

fname = sprintf('RI_post_%d.mat',i); %<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

save(fname, 'data');

end

%load xy_post noise noRI
cd '/Users/stefan/Desktop/AAEEG_EEG/noise_100' %<<<<<<<<<<<<<<<<<<<

files = dir('*_post.mat');

for i=1:length(files)
cfg = [];
cfg.inputfile = files(i).name;
cfg.detrend = "no";

data = ft_preprocessing(cfg);

fname = sprintf('noRI_post_%d.mat',i); %<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

save(fname, 'data');

end

%%
%% just once!!!!!!!!!
%load xy_post noise RI
cd '/Users/stefan/Desktop/AAEEG_EEG/noise_50' %<<<<<<<<<<<<<<<<<<<

files = dir('*_pre.mat');

for i=1:length(files)
cfg = [];
cfg.inputfile = files(i).name;
cfg.detrend = "no";

data = ft_preprocessing(cfg);

fname = sprintf('RI_pre_%d.mat',i); %<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

save(fname, 'data');

end

%load xy_post noise noRI
cd '/Users/stefan/Desktop/AAEEG_EEG/noise_100' %<<<<<<<<<<<<<<<<<<<

files = dir('*_pre.mat');

for i=1:length(files)
cfg = [];
cfg.inputfile = files(i).name;
cfg.detrend = "no";

data = ft_preprocessing(cfg);

fname = sprintf('noRI_pre_%d.mat',i); %<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

save(fname, 'data');

end

%% PREPARE NEIGHBOURS (get electrode positions, layout, from 62 channel brainamp system....)

elec = ft_read_sens('standard_1020_mod.elc'); %get electrode files from system...

cfg = [];
% cfg.layout = 'BrainVision63.elp'; %get/create layout from system....
%cfg.channel          = {'all', '-Fp1', '-Fp2', '-AF3', '-AF4', '-AF7', '-AF8', '-Fpz', '-Iz', '-TP9', '-TP10'}; % see CHANNELSELECTION %bug with Fpz wird oben bei neighbors schon raus deshaln hier nicht mit rein 
cfg.elec           = elec;
cfg.method = 'triangulation'; %subject to change....
cfg.feedback = 'yes';

neighbours = ft_prepare_neighbours(cfg);



%% channel repair
cd '/Users/stefan/Desktop/AAEEG_EEG/noise_50' %<<<<<<<<<<<<<<<<<<<

files = dir('RI_post_*.mat');

for i=1:length(files)

load([files(i).name]);
cfg = [];
cfg.method         =  'weighted'; %'weighted', 'average', 'spline', 'slap' or 'nan' (default = 'weighted')
cfg.badchannel     = {'F6';'F5'; 'TP8'; 'TP7'};%cell-array, see FT_CHANNELSELECTION for details
cfg.elec           = elec;

cfg.missingchannel = [];%cell-array, see FT_CHANNELSELECTION for details

cfg.neighbours     = neighbours;%neighbourhood structure, see also FT_PREPARE_NEIGHBOURS
%cfg.trials         = 'all'; %'all' or a selection given as a 1xN vector (default = 'all')
%     cfg.lambda         = %regularisation parameter (default = 1e-5, not for method 'distance')
%     cfg.order          = %order of the polynomial interpolation (default = 4, not for method 'distance')

data = ft_channelrepair(cfg,data);


fname = sprintf('RI_post_rep_%d.mat',i); %<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
save(fname, 'data');

end



cd '/Users/stefan/Desktop/AAEEG_EEG/noise_100' %<<<<<<<<<<<<<<<<<<<

files = dir('noRI_post_*.mat');

for i=1:length(files)

load([files(i).name]);
cfg = [];
cfg.method         =  'weighted'; %'weighted', 'average', 'spline', 'slap' or 'nan' (default = 'weighted')
cfg.badchannel     = {'F6';'F5'; 'TP8'; 'TP7'};%cell-array, see FT_CHANNELSELECTION for details
cfg.elec           = elec;

cfg.missingchannel = [];%cell-array, see FT_CHANNELSELECTION for details

cfg.neighbours     = neighbours;%neighbourhood structure, see also FT_PREPARE_NEIGHBOURS
%cfg.trials         = 'all'; %'all' or a selection given as a 1xN vector (default = 'all')
%     cfg.lambda         = %regularisation parameter (default = 1e-5, not for method 'distance')
%     cfg.order          = %order of the polynomial interpolation (default = 4, not for method 'distance')

data = ft_channelrepair(cfg,data);


fname = sprintf('noRI_post_rep_%d.mat',i); %<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
save(fname, 'data');

end


%%
%% channel repair
cd '/Users/stefan/Desktop/AAEEG_EEG/noise_50' %<<<<<<<<<<<<<<<<<<<

files = dir('RI_pre_*.mat');

for i=1:length(files)

load([files(i).name]);
cfg = [];
cfg.method         =  'weighted'; %'weighted', 'average', 'spline', 'slap' or 'nan' (default = 'weighted')
cfg.badchannel     = {'F6';'F5'; 'TP8'; 'TP7'};%cell-array, see FT_CHANNELSELECTION for details
cfg.elec           = elec;

cfg.missingchannel = [];%cell-array, see FT_CHANNELSELECTION for details

cfg.neighbours     = neighbours;%neighbourhood structure, see also FT_PREPARE_NEIGHBOURS
%cfg.trials         = 'all'; %'all' or a selection given as a 1xN vector (default = 'all')
%     cfg.lambda         = %regularisation parameter (default = 1e-5, not for method 'distance')
%     cfg.order          = %order of the polynomial interpolation (default = 4, not for method 'distance')

data = ft_channelrepair(cfg,data);


fname = sprintf('RI_pre_rep_%d.mat',i); %<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
save(fname, 'data');

end



cd '/Users/stefan/Desktop/AAEEG_EEG/noise_100' %<<<<<<<<<<<<<<<<<<<

files = dir('noRI_pre_*.mat');

for i=1:length(files)

load([files(i).name]);
cfg = [];
cfg.method         =  'weighted'; %'weighted', 'average', 'spline', 'slap' or 'nan' (default = 'weighted')
cfg.badchannel     = {'F6';'F5'; 'TP8'; 'TP7'};%cell-array, see FT_CHANNELSELECTION for details
cfg.elec           = elec;

cfg.missingchannel = [];%cell-array, see FT_CHANNELSELECTION for details

cfg.neighbours     = neighbours;%neighbourhood structure, see also FT_PREPARE_NEIGHBOURS
%cfg.trials         = 'all'; %'all' or a selection given as a 1xN vector (default = 'all')
%     cfg.lambda         = %regularisation parameter (default = 1e-5, not for method 'distance')
%     cfg.order          = %order of the polynomial interpolation (default = 4, not for method 'distance')

data = ft_channelrepair(cfg,data);


fname = sprintf('noRI_pre_rep_%d.mat',i); %<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
save(fname, 'data');

end



%%
%%%%%

cd ('/Users/stefan/Desktop/AAEEG_EEG/noise_50');
filespost = dir('RI_post_rep_*.mat');

for i = 1:length(filespost)

fullname = filespost(i).name;

load(filespost(i).name); 
    

cfg = [];
cfg.method    = 'mtmfft';
cfg.taper = 'hanning';
cfg.output    = 'powandcsd';
cfg.tapsmofrq = 1;
cfg.foi = 9; %<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% cfg.foilim = [27 80]; 

cfg.keeptrials = 'no';
  
freqsrcpre       = ft_freqanalysis (cfg, data);

% % normalization
    %pow_lo_norm = freqsrcpre;
    tmp = [freqsrcpre.powspctrm];
    
    for j = 1:length(freqsrcpre.label)
        freqsrcpre.powspctrm(j,:) = freqsrcpre.powspctrm(j,:)/mean(tmp(:));
    end

fname = sprintf(strcat('9hz_',fullname), i);
save (fname, 'freqsrcpre');
  
end


%%
%%%%%

cd ('/Users/stefan/Desktop/AAEEG_EEG/noise_100');
filespost = dir('noRI_post_rep_*.mat');

for i = 1:length(filespost)

fullname = filespost(i).name;

load(filespost(i).name); 
    

cfg = [];
cfg.method    = 'mtmfft';
cfg.taper = 'hanning';
cfg.output    = 'powandcsd';
cfg.tapsmofrq = 1;
cfg.foi = 9; %<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% cfg.foilim = [27 80]; 

cfg.keeptrials = 'no';
  
    freqsrcpre       = ft_freqanalysis (cfg, data);
    
% % normalization
    %pow_lo_norm = freqsrcpre;
    tmp = [freqsrcpre.powspctrm];
    
    for j = 1:length(freqsrcpre.label)
        freqsrcpre.powspctrm(j,:) = freqsrcpre.powspctrm(j,:)/mean(tmp(:));
    end
    
 fname = sprintf(strcat('9hz_',fullname), i);
save (fname, 'freqsrcpre');
  
end




%%
%%%%%

cd ('/Users/stefan/Desktop/AAEEG_EEG/noise_50');
filespost = dir('RI_pre_rep_*.mat');

for i = 1:length(filespost)

fullname = filespost(i).name;

load(filespost(i).name); 
    

cfg = [];
cfg.method    = 'mtmfft';
cfg.taper = 'hanning';
cfg.output    = 'powandcsd';
cfg.tapsmofrq = 1;
cfg.foi = 9; %<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% cfg.foilim = [27 80]; 

cfg.keeptrials = 'no';
  
freqsrcpre       = ft_freqanalysis (cfg, data);

% % normalization
    %pow_lo_norm = freqsrcpre;
    tmp = [freqsrcpre.powspctrm];
    
    for j = 1:length(freqsrcpre.label)
        freqsrcpre.powspctrm(j,:) = freqsrcpre.powspctrm(j,:)/mean(tmp(:));
    end

fname = sprintf(strcat('9hz_',fullname), i);
save (fname, 'freqsrcpre');
  
end


%%
%%%%%

cd ('/Users/stefan/Desktop/AAEEG_EEG/noise_100');
filespost = dir('noRI_pre_rep_*.mat');

for i = 1:length(filespost)

fullname = filespost(i).name;

load(filespost(i).name); 
    

cfg = [];
cfg.method    = 'mtmfft';
cfg.taper = 'hanning';
cfg.output    = 'powandcsd';
cfg.tapsmofrq = 1;
cfg.foi = 9; %<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% cfg.foilim = [27 80]; 

cfg.keeptrials = 'no';
  
    freqsrcpre       = ft_freqanalysis (cfg, data);
    
% % normalization
    %pow_lo_norm = freqsrcpre;
    tmp = [freqsrcpre.powspctrm];
    
    for j = 1:length(freqsrcpre.label)
        freqsrcpre.powspctrm(j,:) = freqsrcpre.powspctrm(j,:)/mean(tmp(:));
    end
    
 fname = sprintf(strcat('9hz_',fullname), i);
save (fname, 'freqsrcpre');
  
end

%% LOAD MRI 

% mri = ft_read_mri('Subject01.mri');
% cfg = [];
% cfg.write      = 'no';
% [segmentedmri] = ft_volumesegment(cfg, mri);
% Alternatively, you can load the segmented MRI available from the FieldTrip ftp server (segmentedmri.mat):
load /Users/stefan/Documents/MATLAB/Toolboxes/fieldtrip-20180704/template/headmodel/segmentedmri.mat
load '/Users/stefan/Documents/MATLAB/Toolboxes/fieldtrip-20180704/template/headmodel/standard_mri.mat'
% load '/Users/stefan/Documents/MATLAB/Toolboxes/fieldtrip-20180704/template/headmodel/standard_mri.mat'

% load segmentedmri
%load '/Users/stefan/Documents/MATLAB/Toolboxes/fieldtrip-20180704/template/headmodel/standard_mri.mat'

%% HEADMODEL (1 mit standard, 3 mit bemcp)

% cfg = [];
% cfg.method = 'bemcp';
% cfg.tissue = [3];
% headmodel = ft_prepare_headmodel(cfg, segmentedmri);

%% HEADMODEL 2 load bem

load '/Users/stefan/Documents/MATLAB/Toolboxes/fieldtrip-20180704/template/headmodel/standard_bem.mat';

headmodel = vol;

%% LEADFIELD

elec = ft_read_sens('/Users/stefan/Documents/GitHub/exp_aaeeg/Matlab/standard_1020_mod.elc'); %<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

cfg                 = [];
cfg.elec           = elec;
cfg.headmodel       = vol;
cfg.reducerank      = 3;
%cfg.channel          = {'all', '-Fp1', '-Fp2', '-AF3', '-AF4', '-AF7', '-AF8', '-FPz', '-Iz', '-TP9', '-TP10'}; %<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% cfg.normalize='yes';
cfg.grid.resolution = 1;   % use a 3-D grid with a 1 cm resolution
cfg.grid.unit       = 'cm';
[grid] = ft_prepare_leadfield(cfg);
[grid] = ft_convert_units(grid, 'mm');


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

% cfg           = [];
% cfg.method    = 'interactive';
% cfg.elec      = elec;
% cfg.headshape = vol.bnd(1);
% elec_aligned  = ft_electroderealign(cfg);



%% SOURCEFILTER ALL - RI

load('/Users/stefan/Documents/GitHub/exp_aaeeg/Matlab/elec_aligned.mat');
cd '/Users/stefan/Desktop/AAEEG_EEG/noise_50'

frqsrcfiles1 = dir('/Users/stefan/Desktop/AAEEG_EEG/noise_50/9hz_*.mat'); %<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

% m1
for i = 1:length(frqsrcfiles1)

% read data

fullname = frqsrcfiles1(i).name;

load(frqsrcfiles1(i).name); 

cfg              = [];
cfg.elec        = elec_aligned;
cfg.channel          = {'all', '-Fp1', '-Fp2', '-AF3', '-AF4', '-AF7', '-AF8', '-FPz', '-Iz', '-TP9', '-TP10', '-F4', '-FC5', '-FC6', '-C4', '-FT7'}; %<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
cfg.method       = 'dics';
cfg.grid         = grid;
cfg.headmodel    = vol;
cfg.dics.projectnoise = 'yes';
cfg.dics.lambda       = '10%';
cfg.dics.keepfilter   = 'yes';
cfg.dics.realfilter   = 'yes';
sourcefiltRS = ft_sourceanalysis(cfg, freqsrcpre);

%save

 fname = sprintf(strcat('dics_', fullname), i);   
 save (fname, 'sourcefiltRS');
end


%%
%SOURCEFILTER ALL - noRI

load('/Users/stefan/Documents/GitHub/exp_aaeeg/Matlab/elec_aligned.mat');
cd '/Users/stefan/Desktop/AAEEG_EEG/noise_100'

frqsrcfiles1 = dir('/Users/stefan/Desktop/AAEEG_EEG/noise_100/9hz_*.mat'); %<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

% m1
for i = 1:length(frqsrcfiles1)

% read data

fullname = frqsrcfiles1(i).name;

load(frqsrcfiles1(i).name); 

cfg              = [];
cfg.elec        = elec_aligned;
cfg.channel          = {'all', '-Fp1', '-Fp2', '-AF3', '-AF4', '-AF7', '-AF8', '-FPz', '-Iz', '-TP9', '-TP10', '-F4', '-FC5', '-FC6', '-C4', '-FT7'}; %<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
cfg.method       = 'dics';
cfg.grid         = grid;
cfg.headmodel    = vol;
cfg.dics.projectnoise = 'yes';
cfg.dics.lambda       = '10%';
cfg.dics.keepfilter   = 'yes';
cfg.dics.realfilter   = 'yes';
sourcefiltRS = ft_sourceanalysis(cfg, freqsrcpre);

%save

 fname = sprintf(strcat('dics_', fullname), i);   
 save (fname, 'sourcefiltRS');
end

%% SOURCEFILTER SINGLE (do not run unless needed)

% frqsrcfiles1 = dir('/beam/aaeeg_eeg/WN/11hz_WN_pre*.mat');
% 
% % m1
% for i = 1:length(frqsrcfiles1)
% 
% % read data
% 
% fullname = frqsrcfiles1(i).name;
% 
% load(frqsrcfiles1(i).name); 
% 
% cfg              = [];
% cfg.elec        = elec_aligned;
% cfg.method       = 'dics';
% cfg.grid         = grid;
% cfg.headmodel    = vol;
% cfg.dics.projectnoise = 'yes';
% cfg.dics.lambda       = '10%';
% cfg.dics.keepfilter   = 'yes';
% cfg.dics.realfilter   = 'yes';
% sourcefiltRS = ft_sourceanalysis(cfg, freqsrcpre);
% 
% %save
% 
%  fname = sprintf(strcat('dics_', fullname), i);   
%  save (fname, 'sourcefiltRS');
% end




%% CONCATENATE RI 

cd '/Users/stefan/Desktop/AAEEG_EEG/noise_50'

%PLS FIX, concatenate for freqs not all
dicsfiles_RI_pre_norm = dir ('/Users/stefan/Desktop/AAEEG_EEG/noise_50/dics_9hz_RI_pre*.mat');

for i = 1:length(dicsfiles_RI_pre_norm)

    % read data
load(dicsfiles_RI_pre_norm(i).name); 

    % struct
    dics_9hz_RI_pre_struct_norm{i} = sourcefiltRS ; 
    %      m1struct{i} = freq_avg1; 
end

save dics_9hz_RI_pre_struct_norm

%%
cd '/Users/stefan/Desktop/AAEEG_EEG/noise_50'

%PLS FIX, concatenate for freqs not all
dicsfiles_RI_post_norm = dir ('/Users/stefan/Desktop/AAEEG_EEG/noise_50/dics_9hz_RI_post*.mat');

for i = 1:length(dicsfiles_RI_post_norm)

    % read data
load(dicsfiles_RI_post_norm(i).name); 

    % struct
    dics_9hz_RI_post_struct_norm{i} = sourcefiltRS ; 
    %      m1struct{i} = freq_avg1; 
end

save dics_9hz_RI_post_struct_norm

%% CONCATENATE no RI

cd '/Users/stefan/Desktop/AAEEG_EEG/noise_100'
dicsfiles_noRI_pre_norm = dir ('/Users/stefan/Desktop/AAEEG_EEG/noise_100/dics_9hz_noRI_pre*.mat');

for i = 1:length(dicsfiles_noRI_pre_norm)

    % read data
load(dicsfiles_noRI_pre_norm(i).name); 

    % struct
    dics_9hz_noRI_pre_struct_norm{i} = sourcefiltRS ; 
    %      m1struct{i} = freq_avg1; 
end



% save
save dics_9hz_noRI_pre_struct_norm

%%
cd '/Users/stefan/Desktop/AAEEG_EEG/noise_100'
dicsfiles_noRI_post_norm = dir ('/Users/stefan/Desktop/AAEEG_EEG/noise_100/dics_9hz_noRI_post*.mat');

for i = 1:length(dicsfiles_noRI_post_norm)

    % read data
load(dicsfiles_noRI_post_norm(i).name); 

    % struct
    dics_9hz_noRI_post_struct_norm{i} = sourcefiltRS ; 
    %      m1struct{i} = freq_avg1; 
end



% save
save dics_9hz_noRI_post_struct_norm

%%
% load relevant struct
cd /Users/stefan/Desktop/AAEEG_EEG
load('dics_9hz_RI_struct_norm.mat')
load('dics_9hz_noRI_struct_norm.mat') 

load('dics_9hz_RI_pre_struct_norm.mat')
load('dics_9hz_noRI_pre_struct_norm.mat') 


load('dics_9hz_RI_post_struct_norm.mat')
load('dics_9hz_noRI_post_struct_norm.mat') 

%% average ----.> RI
cfg = [];
cfg.parameter = 'pow';
cfg.keepindividual = 'yes';

RI_pre_average = ft_sourcegrandaverage(cfg, dics_9hz_RI_pre_struct_norm{:});

cfg = [];
cfg.parameter = 'pow';
cfg.keepindividual = 'yes';

RI_post_average = ft_sourcegrandaverage(cfg, dics_9hz_RI_post_struct_norm{:});


RI_average = RI_pre_average;
RI_average.pow = (RI_pre_average.pow + RI_post_average.pow) / 2;


%% average ----.> no RI
cfg = [];
cfg.parameter = 'pow';
cfg.keepindividual = 'yes';

noRI_pre_average = ft_sourcegrandaverage(cfg, dics_9hz_noRI_pre_struct_norm{:});

cfg = [];
cfg.parameter = 'pow';
cfg.keepindividual = 'yes';

noRI_post_average = ft_sourcegrandaverage(cfg, dics_9hz_noRI_post_struct_norm{:});


noRI_average = noRI_pre_average;
noRI_average.pow = (noRI_pre_average.pow + noRI_post_average.pow) / 2;



%% stat
cfg = [];
cfg.spmversion = 'spm12';
%cfg.dim         = m1srcstruct{1}.dim;
%cfg.parameter = 'pow';
cfg.method           = 'montecarlo';  % use the Monte Carlo method to calculate probabilities
cfg.statistic        = 'ft_statfun_indepsamplesT';    % use the dependent samples T-statistic as a measure to evaluate the effect at each sample
cfg.correctm         = 'cluster';
cfg.clusteralpha     = 0.05;                        % threshold for the sample-specific test, is used for thresholding
cfg.tail             = 0;                           % test the left, right or both tails of the distribution
%cfg.clustertail      = cfg.tail;
cfg.minnbchan = 1;  % min neighboorhood channels for cluster
cfg.alpha            = 0.05;                        % alpha level of the permutation test
cfg.correcttail      = 'alpha';                     % see http://www.fieldtriptoolbox.org/faq/why_should_i_use_the_cfg.correcttail_option_when_using_statistics_montecarlo/
cfg.computeprob      = 'yes';
cfg.numrandomization = 10000;                         % number of random permutations
    

nsubj                     = 12;
design                    = zeros(2,2*nsubj);
design(1,1:nsubj)         = 1;
design(1,nsubj+1:2*nsubj) = 2;
design(2,1:nsubj)         = 1:nsubj;
design(2,nsubj+1:2*nsubj) = 1:nsubj;

cfg.design   = design; % design matrix
cfg.ivar     = 1;      % the 1st row codes the independent variable
%cfg.uvar     = 2;      % the 2nd row codes the unit of observation (subject)

cfg.computestat    = 'yes'; %or ?no?, calculate the statistic (default=?yes?)
cfg.computecritval = 'yes'; %or ?no?, calculate the critical values of the test statistics (default=?no?)
cfg.computeprob    = 'yes'; %or ?no?, calculate the p-values (default=?no?)



[stat] = ft_sourcestatistics(cfg, RI_average, noRI_average);



%% PLOT PREPARATION:INTERPOL STAT
% interpolate the t maps to the structural MRI of the subject %
cfg = [];
cfg.parameter = 'all';
statplot = ft_sourceinterpolate(cfg, stat, mri); 

%% PLOT PREPARATION: NORMALIZE
% % normalize
% 
% cfg = [];
% % cfg.parameter = 'pow';
% cfg.spmversion= 'spm12';
% cfg.nonlinear     = 'no';
% mrinorm = ft_volumenormalise(cfg, mri);

%% PLOT PREPARATION: INTERPOL - MRI
% interpolate filter source files
% cfg = [];
% cfg.parameter = 'all';
% %sourceplot = ft_sourceinterpolate(cfg, sourcefiltRSNorm, mri); 
% sourceplot = ft_sourceinterpolate(cfg, statplot, mri); 

%%  SOURCEPLOT 
%% ABSOLUTE VALUE HACK FOR BETTER PLOTTING

statplot_abs = statplot;

statplot_abs.stat = abs(statplot_abs.stat);



%% surface plot (SBG script)
aal = ft_read_atlas('/Users/stefan/Documents/MATLAB/Toolboxes/fieldtrip-20180704/template/atlas/aal/ROI_MNI_V4.nii');

cfg = [];
cfg.method         = 'surface';
cfg.atlas = aal;
cfg.funparameter   = 'stat';
cfg.funcolormap    = 'hot';
cfg.projmethod     = 'nearest';
cfg.projthresh     = 0.5;
cfg.camlight       = 'no';
cfg.colorbar = 'yes';
cfg.maskparameter= cfg.funparameter;% 'mask';
%cfg.surffile   = 'surface_white_both.mat'%'surface_inflated_both_caret.mat';%'surface_white_both.mat';%'surface_inflated_both.mat';% 'surface_pial_both.mat';%  %This one is in mm
cfg.surfinflated   = 'surface_inflated_both_caret.mat';
%cfg.funcolorlim   = [abs(stat.critval(1,1)) abs(min(stat.stat))];
% cfg.funcolorlim   = [abs(stat.critval(1,1)) max(stat.stat)];
%cfg.funcolorlim   = 'zeromax';
cfg.funcolorlim   = [1.5 2.7];
ft_sourceplot(cfg, statplot);
view([-90, 0])
material dull
camlight
%%% saveas(gcf,[fileDir 'PatEarlyRight_th50.tif']);
%view([-90, 0])
% camlight
%%% saveas(gcf,[fileDir 'PatEarlyLeft_th50.tif']);
%%
ft_sourceplot(cfg, source2plotL);
view([90, 0])

%% SOURCEPLOT WITH ABSOLUTE STATPLOT VALUES
% workaround idea to make it more nice: use 0.01 or 0.001 or 0.0001
% thresholds for lower bound of color bar

aal = ft_read_atlas('/Users/stefan/Documents/MATLAB/Toolboxes/fieldtrip-20180704/template/atlas/aal/ROI_MNI_V4.nii');

cfg = [];
cfg.method        = 'ortho';
cfg.funparameter  = 'stat';
cfg.maskparameter = cfg.funparameter;
cfg.interactive = 'yes';
cfg.funcolorlim = [abs(stat.critval(1,1)) abs(min(stat.stat))]; 
%cfg.funcolorlim   = [3.5 5.1];
cfg.funcolorlim   = 'zeromax';
%cfg.opacitylim = [2.2 10];
% cfg.opacitymap = 'rampdown';
% cfg.frequency = 'all';
% cfg.frequency = [10];
% cfg.surffile = 'surface_inflated_both_caret.mat'; 
% cfg.surfdownsample = 10;

% cfg.surfinflated = 'surface_inflated_both.mat';
cfg.projmethod = 'nearest';
cfg.atlas = aal;
% figure
ft_sourceplot(cfg, statplot);

%% Neural Activity Index (for validation purposes)

sourceNAI = sourcefiltRS;
sourceNAI.avg.pow = sourcefiltRS.avg.pow ./ sourcefiltRS.avg.noise;
 
cfg = [];
cfg.downsample = 2;
cfg.parameter = 'avg.pow';
sourceNAIInt = ft_sourceinterpolate(cfg, sourceNAI , mri);
  
%%
maxval = max(sourceNAIInt.pow);

cfg = [];
cfg.method        = 'ortho';
cfg.funparameter  = 'pow';
cfg.maskparameter = cfg.funparameter;
cfg.funcolorlim   = [0 maxval];
cfg.opacitylim    = [0 maxval];
cfg.opacitymap    = 'rampup';
cfg.atlas = aal;

ft_sourceplot(cfg, sourceNAIInt);