function cfg = prepare_cfg()
%PREPARE_CFG Summary of this function goes here
%   Detailed explanation goes here
cfg = [];
cfg.data_path = 'data_test';

cfg.add_db = 50;

base_freq = 440;
fourth_ratio = 4/3;

freqs = zeros(1, 4);
for idx_freq = 1:length(freqs)
    freqs(idx_freq) = base_freq * (fourth_ratio^(idx_freq-1));
end %for

cfg.sounds.freqs = freqs;
cfg.sounds.stim_length = 0.1;
cfg.sounds.fade = 5e-3;


cfg.runs.tones.n_trials_per_sound = 100;
cfg.runs.tones.iti_mean = 0.3;
cfg.runs.tones.iti_jitter = 0.05;
cfg.runs.tones.initial_delay = 1;

end

