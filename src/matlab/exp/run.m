%% clear...

clear all global
close all

%% init...

exp.init.config_ptb;


%% set variables....

subject_id = '19800908igdb';


%% run tones

exp.parts.runs.tones(subject_id);

