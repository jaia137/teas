% TEAS Experiment Masterscript, Visit 2 and X


%% INIT, ADDPATH, CD

MT_path = 'C:\Users\EEG_SUM\Desktop\MultiThreshold\MAP1_14\USZmultiThreshold\multiThreshold 1.46';

ERP_path = 'E:\TEAS\_git\teas\src\matlab\erp';

addpath(genpath('C:\Users\EEG_SUM\Desktop\MultiThreshold\MAP1_14\USZmultiThreshold\multiThreshold 1.46'));

addpath(genpath('E:\TEAS\_git\teas\src\matlab'));

%% In Matlab 2016: Run MultiThreshold once, press any key/click, to debug (it's fine in ML2020 but there ERP does not work....omfg)

cd(MT_path); 

run('USZmultiThreshold.m');

waitforbuttonpress;

close all;

%% MultiThreshold Session 1

cd(MT_path); 

run('USZmultiThreshold.m');

% in general:
% use over ear headphones
% pick paradigms in study order...
% enter study code_visit_test etc.
% choose ear
% run paradigm
%
% 
% specific:
% pick tEAS_absThreshold_train, instruct patient, run, save, one ear is enough
% pick tEAS_absThreshold, run, save, for both ears


%% MultiThreshold Session 2

cd(MT_path);

run('USZmultiThreshold.m');

% specific:
% pick tEAS_LDL, instruct patient, run, save, for both ears
% pick tEAS_IFMC, enter target level 30 (or more), enter PTA frequency closest to tinnitus pitch besides 1000 (will be fixed), instruct patient, run one trial, check if clear, run the whole paradigm, save, for both ears
% pick tEAS_forwardMasking, enter PTA frequency closest to tinnitus pitch besides 1000 (will be fixed), instruct patient, run one trial, check if clear, run the whole paradigm, save, for both ears
% 
% change to in-ear headphones
% pick tEAS_IFMC, choose no calibration file, choose diotic, enter tinnitus pitch, instruct patient, run, note SL values for both frequencies, save


%% ERP 

cd(ERP_path);

open('TEAS_mfp_erp_v2_lab.m');

% run script and follow instructions, close when done

