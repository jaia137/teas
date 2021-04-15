%% clear...

clear all global
close all

%% init...
exp.init.config_ptb;

%% set variables....
subject_id = '19800908igdb';

%% prepare...
exp.init.prepare_subject(subject_id);

%% run auditory threshold
exp.parts.auditory_threshold(subject_id);

%% run noise burst localizer
exp.parts.localizers.noise_bursts(subject_id);

%% run circle localizer
exp.parts.localizers.circle(subject_id);

%% run resting localizer
exp.parts.localizers.resting(subject_id);

%% run movie localizer
exp.parts.localizers.movie(subject_id);

%% run gabor run
exp.parts.runs.gabor_orientation(subject_id);

%% run facehouse
exp.parts.runs.facehouse(subject_id);

%% run audiobook
exp.parts.runs.audiobook(subject_id);

%% run tones
exp.parts.runs.tones(subject_id);
