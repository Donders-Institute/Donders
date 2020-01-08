####### INITIATION #######

scenario = "Template";
pcl_file = "TemplateMAIN.pcl";
no_logfile = true; # do not use Neurobs default logfile
active_buttons = 3;
button_codes = 1,2,3;

default_background_color =  153,153,153;
default_font = "Consolas";
default_font_size = 20;
default_text_color = 235, 235, 235; 
default_text_align = align_left;

begin;

######## PICTURES ########
picture { } p_Default;			# empty screen

picture {
   background_color = 153,153,153;
} et_calibration;

picture {
			box { height = 1; width = 30; color = 255,255,255; } b_Horz;
			x = 0; y = 0;
			box { height = 30; width = 1; color = 255,255,255; } b_Vert;
			x = 0; y = 0;
} p_Fixation;

picture { text { caption = " "; max_text_width =900; max_text_height = 500;  } t_Info1; x = 0; y = 0;
          text { caption = " "; max_text_width =900; max_text_height = 500;  } t_Info2; x = 0; y = -80;
          text { caption = "Press [ENTER] to confirm or [Esc] to abort. "; } t_Info3; x = 0; y = -150;
} p_Info;

picture { text { caption = " "; } t_Xcoord; x = 0; y = 0;
          text { caption = " "; } t_Ycoord; x = 0; y = -40;
          text { caption = " "; } t_Area; x = 0; y = -150;
			 text { caption = "Move your eyes (or the mouse, in case of simulation) around to see current coordinates and area.
			Press ENTER to end the experiment.";  max_text_width =900; max_text_height = 500;  } t_CheckGazeInfoText; x = 0; y = -350;
} p_GazeCoordinates;

picture { text { caption = "End of this experiment, thanks for participating!"; font_size = 16; } t_End1; x = 0; y = 0;
} p_End;

picture { text { caption = "Break. Press a button to continue."; font_size = 16; } t_Pause1; x = 0; y = 0;
} p_Pause;


picture { text { caption = " "; max_text_width =900; max_text_height = 500;  } t_Text1; x = 0; y = 0;
			
} p_Text;

#picture { 
#	bitmap { filename = "elephant.jpg"; preload = true; } b_BitmapLeft; x = -400; y = 0;
#	bitmap { filename = "wallaby.jpg"; preload = true; } b_BitmapRight; x = 400; y = 0;
#} p_Stimulus;

picture { 
	bitmap { preload = false; } b_BitmapLeft; x = -400; y = 0;
	bitmap { preload = false; } b_BitmapRight; x = 400; y = 0;
} p_Stimulus;
		
######## STIMULI #########

/*
sound { 	wavefile { filename = "sound.wav"; preload = true;}; 
} s_Beep;

array {	bitmap { filename = "zon.jpg"; preload = true; };
			bitmap { filename = "flower.jpg"; preload = true; };
} a_Dots;

picture { bitmap {filename = "tussenschermpje.jpg"; preload = true; }tussenschermpje; 
			 x = 0; y = 0;
} p_Greyscreen; 
*/	