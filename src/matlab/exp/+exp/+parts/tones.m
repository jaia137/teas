function tones(subject_id)
%% get cfg
cfg = exp.init.prepare_cfg;

%% init ptb
ptb_config = exp.init.config_ptb;
ptb = exp.init.init_ptb(ptb_config);

%% create stimuli...
ptb.draw(o_ptb.stimuli.visual.Text('Bitte warten Sie, wir laden die Stimulation...'));
ptb.flip();

fixcross = o_ptb.stimuli.visual.FixationCross();
tones_idx = [];
for idx_stim = 1:length(subj_data.stims.audio)
  cur_idx_list = ones(1, cfg.runs.tones.n_trials_per_sound) .* idx_stim;
  
  tones_idx = [tones_idx, cur_idx_list];
end %for

tones_idx = Shuffle(tones_idx);

cur_delay = cfg.runs.tones.initial_delay;

trials = {};

for idx_tones = 1:length(tones_idx)
  cur_tone_idx = tones_idx(idx_tones);
  cur_stim = subj_data.stims.audio{cur_tone_idx};
  cur_trigger = subj_data.stims.trigger{cur_tone_idx};
  
  ptb.prepare_audio(cur_stim, cur_delay, idx_tones > 1);
  ptb.prepare_trigger(cur_trigger, cur_delay, idx_tones > 1);
  
  iti = cfg.runs.tones.iti_mean;
  jitter = cfg.runs.tones.iti_jitter;
  
  this_iti = RandLim(1, iti - jitter, iti + jitter);
  
  this_trial.tone = cur_stim;
  this_trial.delay = cur_delay;
  
  cur_delay = cur_delay + this_iti;
  
  trials{end+1} = this_trial;
end %for

ptb.schedule_audio();
ptb.schedule_trigger();


%% do it...
ptb.draw(o_ptb.stimuli.visual.Text('Gleich geht es los...'));
ptb.flip();

KbWait();

ptb.play_on_flip();
ptb.draw(fixcross);

ptb.flip();

WaitSecs(cur_delay + 1);

%% save....
subj_data.tones.done = true;
subj_data.tones.trials = trials;

save(fullfile(cfg.data_path, subject_id), 'subj_data');

sca

end
