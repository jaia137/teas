function paradigm_tEAS_forwardMasking(handles)
global stimulusParameters experiment betweenRuns

paradigmBase(handles) % default

stimulusParameters.WRVname='targetLevel';
stimulusParameters.WRVstartValues=50;
stimulusParameters.WRVsteps= [10 2];
stimulusParameters.WRVlimits=[-30 110];

betweenRuns.variableName1='gapDuration';
betweenRuns.variableList1=[.005 0.01 0.02 0.04];
betweenRuns.variableName2='maskerLevel';
betweenRuns.variableList2=[80 60 40 20];

experiment.maskerInUse=1;
stimulusParameters.maskerType='tone';
stimulusParameters.maskerPhase='cos';
stimulusParameters.maskerDuration=0.108;
stimulusParameters.maskerLevel=20;
stimulusParameters.maskerRelativeFrequency=1;
stimulusParameters.includeCue=0;  
stimulusParameters.targetLevel =30;

stimulusParameters.gapDuration=betweenRuns.variableList1;

stimulusParameters.targetType='tone';
stimulusParameters.targetPhase='sin';
stimulusParameters.targetFrequency=[500];
stimulusParameters.targetDuration=0.02;
stimulusParameters.targetLevel=-stimulusParameters.WRVstartValues(1);

stimulusParameters.rampDuration=0.01;

% instructions to user
% single interval up/down no cue
stimulusParameters.instructions{1}=[{'YES if you hear the added click'}, { }, { 'NO if not (or you are uncertain'}];
% single interval up/down with cue
stimulusParameters.instructions{2}=[{'count how many distinct clicks you hear'},{'ignore the tones'},{' '},...
    {'The clicks must be **clearly distinct** to count'}];

stimulusParameters.instructionsGER{1}=[{'YES wenn Sie das Klicken nach dem Ton hören'}, {'' }, {'NO falls nicht (oder Sie unsicher sind)'}];

experiment.maxTrials=10;
% catchTrials
experiment.allowCatchTrials= 1;


