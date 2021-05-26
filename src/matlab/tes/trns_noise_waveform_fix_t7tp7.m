%% TRNS NOISE SCRIPT

Fs = 12800;                        % sampling frequency (Hz)
d = 10.0;                         % <-----------------duration
n = Fs * d;                        % number of samples
amp = [0.7849 0.6862];

amp_electrode_list = {'T8' 'TP7'};

for i = 1:2
%%  carrier white

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
    waves_txt = readmatrix(filename);
end

%%


