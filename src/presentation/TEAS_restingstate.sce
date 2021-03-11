#header: define general parameters

scenario = "Control"; 

/*weiss nicht ob das notwendig ist - führt zu unterbrüchen beim fixkreuz!
#damit es zu keinen zeitlichen verzögerungen kommt: halbe Sekunde Wartezeit
default_trial_start_delay = 500; */



no_logfile = false;
response_matching = simple_matching;
response_port_output = true; #false würde bedeuten, die responses würden nicht ins eeg geschrieben

#Schrift         
default_font_size = 20; 
default_font = "Arial";
default_background_color = 0, 0, 0;    #schwarz


/*sendet Signale an EEG-Computer, aber dazu muss ich erst ports festlegen!! essentiell!! If you want Presentation to write codes 
to an output port that depend on the event, define this parameter to be true. (See Port Output.) The value of port_code will be 
written to the output port at the occurance of all stimuli for which port_code is defined. When responses occur, the codes given 
in either button_codes or target_button_codes will be used. */
write_codes = true; 

/*evtl zerstört das die abstimmung der lautstärke mit marks software...
#Soundlautstärke If attenuation = 0, there is no attenuation and the sound will be played as it is given in the wavefile. If attenuation = 1, the sound will be attenuated by 100 Db which effectively results in silence. */
default_attenuation = 0.35; 


begin;

# SDL part: list all stimuli

wavefile { filename = "open.wav"; } open;
wavefile { filename = "close.wav"; } close;
wavefile { filename = "gammatone.wav"; } gamma;


picture {text { caption = "+"; 						font_size = 30;};  x = 0; y = 0;} fixkreuz;
picture {text { caption = "+"; font_color=0,0,0;font_size = 30; }; x = 0; y = 0;} nichts; 


trial{
	trial_duration = 60000;
	stimulus_event {
		sound {wavefile open;};
		time=0;
		port_code=50;};
	stimulus_event {
		picture fixkreuz;
		time = 0;};
	} eyes_open;
	
trial {
	trial_duration = 60000;
	stimulus_event {
		sound {wavefile close;};
		time=0;
		port_code=70;};
			stimulus_event {
		picture nichts;
		time = 0;};
	} eyes_closed;
	
	
	
	
	
	
	trial{
	trial_duration = 60000;
	stimulus_event {
		sound {wavefile gamma;};
		time=0;
		port_code=80;};
	picture {text {caption=
"Ende des Ruhe-EEG";} ;x = 0; y = 0;};
		time=0;
		port_code=80;
	} final;	
	
	
	



begin_pcl;

#PCL part: method calls

eyes_open.present();
eyes_closed.present(); # 1. Minute
eyes_open.present();
eyes_closed.present(); # 2. Minute
eyes_open.present();
eyes_closed.present(); # 3. Minute
eyes_open.present();
eyes_closed.present(); # 4. Minute
eyes_open.present();
eyes_closed.present(); # 5. Minute
final.present();

