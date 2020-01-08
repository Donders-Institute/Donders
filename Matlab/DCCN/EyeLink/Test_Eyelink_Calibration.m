%%Screen
%[w,screenRect] = Screen(0,'OpenWindow',0,[]);
[w, ScreenRect] = Screen(0,'OpenWindow',0, [900 400 1700 1000 ]);
pause(.01);
%Screen(colors.BACKGROUND);
black=BlackIndex(w);
%HideCursor;

%% Initialization of the connection with Eyelink.

%%% New simple Dummy mode == 1 (yes) or 0
dummymode=0;

% exit program if this fails.
if ~EyelinkInit(dummymode)
    fprintf('Eyelink Init aborted.\n');
    cleanup;  % cleanup function
    return;
end

el = EyelinkInitDefaults(w);

el.backgroundcolour = [0,0,0]; %black background
%el.targetbeep=1;
el.window = w;

% EyelinkUpdateDefaults(el);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Opening file in eyelink

file_name = 'TestCal'; %NOTE: filename should have MAX 8 characters!
i = Eyelink('openfile',file_name);
if i~=0
    disp(['Cannot create EDF file: ' file_name]);
    %cleanup; % cleanup function called
    return;
end

%%%% SET UP TRACKER CONFIGURATIONS
%Eyelink('command', 'calibration_type = HV9');
%Eyelink('command', 'screen_distance = 1102 1138');
%Eyelink('command', 'screen_distance = 70');

%%%% set parser (conservative saccade thresholds)
%Eyelink('command', 'saccade_velocity_threshold = 35'); % based on previous experience, these are conservative to detect large saccades, see manual
%Eyelink('command', 'saccade_acceleration_threshold = 9500');% based on previous experience, these are conservative to detect large saccades, see manual
%Eyelink('command', 'saccade_motion_threshold = 0.15');% to try to ignore saccades smaller than this, a window

%%%% set EDF file contents
%%%% note that it is recommended to offline search for your own saccades based on velocity and then position
% the important ones are ..._event_filter and ..._sample_data

Eyelink('command', 'file_event_filter = LEFT,SACCADE,BLINK,MESSAGE'); % what you want in the file
% Sets which types of events will be written to EDF file. See tracker file
% DATA.INI for types.
% Arguments: <list>: list of event types
% LEFT, RIGHT events for one or both eyes
% FIXATION fixation start and end events
% FIXUPDATE fixation (pursuit) state updates
% SACCADE saccade start and end
% BLINK blink start an end
% MESSAGE messages (user notes in file)
% BUTTON button 1..8 press or release
% INPUT changes in input port lines

Eyelink('command', 'file_event_data = GAZE,AREA,VELOCITY');

Eyelink('command', 'file_sample_data = LEFT,GAZE,AREA'); % what you want to record

Eyelink('command', 'link_event_filter = LEFT,SACCADE,BLINK,MESSAGE'); % what you want in the file
% DATA.INI for types.
% Arguments: <list>: list of event types
% LEFT, RIGHT events for one or both eyes
% FIXATION fixation start and end events
% FIXUPDATE fixation (pursuit) state updates
% SACCADE saccade start and end
% BLINK blink start an end
% MESSAGE messages (user notes in file)
% BUTTON button 1..8 press or release

Eyelink('command', 'link_event_data = GAZE,AREA,VELOCITY');

Eyelink('command', 'link_sample_data  = LEFT,GAZE,AREA'); % what you want to record
% Arguments: <list>: list of data types
% GAZE screen xy (gaze) position
% GAZERES units-per-degree screen resolution
% HREF head-referenced gaze
% PUPIL raw eye camera pupil coordinates
% AREA pupil area
% STATUS warning and error flags
% BUTTON button state and change flags
% INPUT input port data lines

%% Flip sync
flipsync = 2;
%"dontsync" If set to zero (default), Flip will sync to the vertical
%retrace and will pause execution of your script until the Flip has happened. If
%set to 1, Flip will still synchronize stimulus onset to the vertical retrace,
%but will *not* wait for the flip to happen: Flip returns immediately and all
%returned timestamps are invalid. A value of 2 will cause Flip to show the
%stimulus *immediately* without waiting/syncing to the vertical retrace
%%% Note: value 2 does make the events on time (speeds up flip), and no
%%% noticeable problems. Timing delays, however, are not affected by the
%%% flip as mentioned above (e.g., WaitSecs). Delays may be in switching
%%% states


%% Calibrate the eye tracker
EyelinkDoTrackerSetup(el);

%%%% optional do a final check of calibration using driftcorrection
%  EyelinkDoDriftCorrection(el);

pause(.1)
el.targetbeep=0;

Screen(w,'FillRect',black);
Screen('Flip',w,[],[],flipsync);

%% Start recording
Eyelink('startrecording');
xpos = [,200];
ypos = [,300];
textcolor = [255,255,255];

eye_used = Eyelink('eyeavailable'); % get eye that's tracked
if eye_used == 0
    Screen('DrawText', window, 'No eye found. Recording will be aborted in 3 seconds', xpos,ypos,textcolor);
else
    Screen('DrawText', window, 'End of demo. Recording will be aborted in 3 seconds', xpos,ypos,textcolor);
end
Screen('Flip',window,[],[]);

pause(3);

%% If no eye found, stop recording and display
Eyelink('StopRecording');
Eyelink('CloseFile');
Eyelink('Shutdown');
Screen(w,'Close');
