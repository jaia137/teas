function paradigm_tEAS_absThreshold(handles)
global stimulusParameters experiment betweenRuns

paradigmBase(handles) % default

betweenRuns.variableName1='targetFrequency';
betweenRuns.variableList1=[125 250 500 1000 1500 2000 3000 4000 6000 8000 10000 12000 14000];
betweenRuns.variableName2='targetDuration';
betweenRuns.variableList2= 0.25;

experiment.maskerInUse=0;
experiment.singleIntervalMaxTrials=[16];


stimulusParameters.targetFrequency=betweenRuns.variableList1;
stimulusParameters.targetDuration=betweenRuns.variableList2;
stimulusParameters.targetLevel=stimulusParameters.WRVstartValues(1);
stimulusParameters.includeCue=0;  

stimulusParameters.WRVstartValues=30;


% forced choice window interval
stimulusParameters.AFCsilenceDuration=0.5;


% instructions to user
%   single interval up/down no cue
stimulusParameters.instructions{1}=[{'YES if you hear the tone clearly'}, {'' }, { 'NO if not (or you are uncertain)'}];
%   single interval up/down with cue
stimulusParameters.instructions{2}=[{'count the tones you hear clearly'}, { ''}, { 'ignore indistinct tones'}];

stimulusParameters.instructionsGER{1}=[{'YES wenn Sie den Ton deutlich hören'}, { ''}, {'NO falls nicht (oder Sie unsicher sind)'}];
stimulusParameters.instructionsGER{2}=[{'zählen Sie die Töne, die Sie deutlich hören'}, {'' }, {'ignorieren Sie undeutliche Töne'}];

