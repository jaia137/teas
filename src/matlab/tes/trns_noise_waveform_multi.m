%% TRNS NOISE SCRIPT

Fs = 16000;                        % sampling frequency (Hz)
d = 10.0;                         % <-----------------duration
n = Fs * d;                        % number of samples
amp = [-0.1526 0.5289 0.7849 -0.0503 -0.1593 -0.2068 -0.0981 ...
    -0.2222 0.6862 -0.171 -0.1219 -0.0495 -0.2499 -0.1843 -0.062 -0.2048 -0.0673];

amp_electrode_list = {'P4' 'T7' 'T8' 'PZ' 'FC1' 'C1' 'C2' 'FC3' 'TP7' 'PO10' '010' 'EX4' 'EX17' 'EX18' 'IZ' 'CP1' 'CP2' };

for i = 1:17
%  carrier white

rand('state',sum(100 * clock));    % initialize random seed
noise = randn(1, n);               % gaussian noise

%% filter, alternatively use fieldtrip filters

Fc1 = 0.1;
Fc2 = 100;

h=fdesign.bandpass('N,Fc1,Fc2',64,Fc1,Fc2,Fs);
Hd = design(h, 'butter');
bandpass=filter(Hd,noise);
bp_norm = bandpass / max(abs(bandpass));   % -1 to 1 normalization

%% amplitude

wave = 0.001*(amp(i))*(bp_norm);

%% write to text

fileID = fopen(['wave_' amp_electrode_list{i} '.txt'],'w');
fprintf(fileID,'%.6d\n',wave);
fclose(fileID);

end


%% adjust amplitude of text files

cd ('/Users/shanti/Documents/GitHub/teas/src/matlab/tes');

waves = dir ('*.txt');

%% load files

for i = 1:length(waves)
    filename = waves(i).name;
    A = readmatrix(filename);
end

%%

o10 = readmatrix('wave_O10.TXT') ;
c1 = readmatrix('wave_c1.TXT') ;
o10 = readmatrix('wave_O10.TXT') ;
o10 = readmatrix('wave_O10.TXT') ;
o10 = readmatrix('wave_O10.TXT') ;
o10 = readmatrix('wave_O10.TXT') ;
o10 = readmatrix('wave_O10.TXT') ;
o10 = readmatrix('wave_O10.TXT') ;
o10 = readmatrix('wave_O10.TXT') ;
o10 = readmatrix('wave_O10.TXT') ;
o10 = readmatrix('wave_O10.TXT') ;
o10 = readmatrix('wave_O10.TXT') ;
o10 = readmatrix('wave_O10.TXT') ;

