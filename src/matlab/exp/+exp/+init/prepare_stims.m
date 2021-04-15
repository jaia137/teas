function stims = prepare_stims(cfg)

stims.audio = {};
stims.trigger = {};

for i=1:length(cfg.sounds.freqs)
  cur_freq = cfg.sounds.freqs(i);
  stims.audio{i} = o_ptb.stimuli.auditory.Sine(cur_freq, cfg.sounds.stim_length);
  stims.audio{i}.apply_cos_ramp(cfg.sounds.fade);
  stims.trigger{i} = cfg.triggers.stims(i);
end %for
end

