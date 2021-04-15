function ptb = init_ptb(ptb_config)
%% init ptb...

ptb = o_ptb.PTB.get_instance(ptb_config);
ptb.setup_audio();
ptb.setup_trigger();


%% init trigger system

config_io;

ioObj = io64;
status = io64(ioObj);
address = hex2dec('d010');          
data_out=0;                  

io64(ioObj,address,data_out);  


end
