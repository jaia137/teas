function paradigm_tEAS_LDL(handles)
global stimulusParameters experiment betweenRuns

paradigmBase(handles) % default

stimulusParameters.WRVname='targetLevel';
stimulusParameters.WRVstartValues=75 ;
stimulusParameters.WRVsteps=[3 3];
stimulusParameters.WRVlimits=[-30 115];
stimulusParameters.includeCue=0;

betweenRuns.variableName1='targetFrequency';
betweenRuns.variableList1=[500 1000 2000 4000];
betweenRuns.variableName2='targetDuration';
betweenRuns.variableList2=0.5 ;
% 'randomize within blocks', 'fixed sequence', 'randomize across blocks'
betweenRuns.randomizeSequence='randomize within blocks'; 

stimulusParameters.stimulusDelay=0;

experiment.maskerInUse=0;

stimulusParameters.targetType='tone';
stimulusParameters.targetPhase='sin';
%stimulusParameters.targetFrequency=[500 1000 2000 4000];
stimulusParameters.targetDuration=0.5;
stimulusParameters.targetLevel=stimulusParameters.WRVstartValues(1);

stimulusParameters.instructions{1}= ['Ist der Ton ''angenehm'', ''laut'' or ''unangenehm''?'];
%   single interval up/down with cue
stimulusParameters.instructions{2}= [];

