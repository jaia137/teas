%% TRNS NOISE SCRIPT

Fs = 16000;                        % sampling frequency (Hz)
d = 10.0;                         % <-----------------duration
n = Fs * d;                        % number of samples

%  carrier white

rand('state',sum(100 * clock));    % initialize random seed
noise = randn(1, n);               % gaussian noise
s = noise / max(abs(noise));   % -1 to 1 normalization


%% filter

Fc1 = 0.1;
Fc2 = 100;

h=fdesign.bandpass('N,Fc1,Fc2',64,Fc1,Fc2,Fs);
Hd = design(h, 'butter');
fvtool(Hd);
bandpass=filter(Hd,s);

%% amplitude

wave = 0.001*(bandpass);

%% write to text

fileID = fopen('exp.txt','w');
fprintf(fileID,'%.6d\n',wave);
fclose(fileID);

