%% TRNS NOISE SCRIPT

Fs = 44100;                        % sampling frequency (Hz)
d = 10.0;                         % <-----------------duration
n = Fs * d;                        % number of samples

%  carrier white

rand('state',sum(100 * clock));    % initialize random seed
noise = randn(1, n);               % gaussian noise
s = noise / max(abs(noise));   % -1 to 1 normalization


%%

Fc1 = 0.1;
Fc2 = 640;

h=fdesign.bandpass('N,Fc1,Fc2',64,Fc1,Fc2,Fs);
Hd = design(h, 'butter');
fvtool(Hd);
bandpass=filter(Hd,s);

