% TEAS Experiment Masterscript, Visit 2 and X


%% INIT, ADDPATH, CD

MT_path = 'C:\Users\EEG_SUM\Desktop\MultiThreshold\MAP1_14\USZmultiThreshold\multiThreshold 1.46';

ERP_path = 'E:\TEAS\_git\teas\src\matlab\erp';

addpath(genpath('C:\Users\EEG_SUM\Desktop\MultiThreshold\MAP1_14\USZmultiThreshold\multiThreshold 1.46'));

addpath(genpath('E:\TEAS\_git\teas\src\matlab'));

%% MultiThreshold Session 1

cd(MT_path);

run('USZmultiThreshold.m');

% pick paradigms in order...


%% MultiThreshold Session 2

cd(MT_path);

run('USZmultiThreshold.m');

%% ERP 

cd(ERP_path);

open('TEAS_mfp_erp_v2_lab.m');

