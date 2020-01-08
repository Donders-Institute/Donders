%% Sumary of Eyelink functions to be used in Matlab with Psychotoolbox.
% This receipt has been cooked by Jose Garcia-Uceda
% email: j.garcia@donders.ru.nl 
% Last version June 2019
% Note: to add commands read the *.ini files. You can find them at the
%       eyeLink PC. Usual commands can be found at DEFAULTS.INI

%% Initialization  
function [EyelinkConnected,File_name,error] = ini_eyeLink()
        %% Initialization
        Eyelink('Initialize');
        pause(1.5);

        EyelinkConnected = Eyelink('IsConnected');
        File_name = 'TestEC'; %NOTE: filename should have MAX 8 characters!

        %Open EDF file. Display error if file cannot be opened.
        error = Eyelink('OpenFile', File_name);
        if error~=0
            disp(['Cannot create EDF file:' File_name]);
            cleanup; 
            return;
        end
end

%% start recording
function [error, EyeUsed] = record_eyeLink()
        %% Start recording
        Eyelink('StartRecording');
        Error = Eyelink('CheckRecording');
        EyeUsed = Eyelink('eyeavailable'); %receive info about which eye is tracked.
        pause(1.5);
end

%% stop recording
function stop_eyeLink()
        %% Stop recording and close file and connection
        Eyelink('StopRecording');
        pause(1.5);
end

%% shutdown  
function Shutdown_eyeLink()
        Eyelink('Shutdown');
        pause(1.5);
end

%% give screen information about graphics to eyelink
function giveScreenInfo_eyeLink()
    pause(1.5);
    Window = Screen('OpenWindow',max(Screen('Screens')));

    el=EyelinkInitDefaults(Window);

    if ~EyelinkInit(1, 1) % initialize eyelink
        fprintf('Eyelink Init aborted.\n');
        cleanup;  % cleanup function
        return;
    end
    pause(1.5);
end

%% name and open a file to record our data
function openFileToRecord_eyelink(subjectID)
    pause(1.5);
    edfFileName = [subjectID,datestr(clock,'MM')];
    edff = Eyelink('Openfile', edfFileName);
    if edff~=0
        printf('Cannot create EDF file ''%s'' ', edfFile);
        Eyelink( 'Shutdown');
        return;
    end

    Eyelink('command', 'add_file_preamble_text ''dynamic stim eyetracking''');
    pause(1.5);
end

%% set the parameters to be saved in our file
function setFileContentToBeSaveInOurFile_eyelink()
    Eyelink('command', 'file_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,MESSAGE,BUTTON'); % what events (columns) are recorded in EDF
    Eyelink('command', 'file_sample_data  = LEFT,RIGHT,GAZE,HREF,AREA,GAZERES,STATUS');         % what samples (columns) are recorded in EDF
end

%% close file
function closeFile_eyeLink()
        pause(1.5);  
        Eyelink('CloseFile');
end

%% set data parameters available in real time
function setRealTimeParametersToReceive_eyelink()

    % set data available in real time
    Eyelink('command', 'link_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,MESSAGE,BUTTON'); % events available for real time
    Eyelink('command', 'link_sample_data  = LEFT,RIGHT,GAZE,GAZERES,AREA,STATUS');              % samples available for real time
    %Eyelink('command', 'button_function 5 "accept_target_fixation"');                          % allow to use eyelink gamepad to accept fixations/targets

end

%% set screen dimensions in pixels 
function  screenDimensionInPixels_eyeLink()
    [width, height]=Screen('WindowSize',Window); % returns in pixels
    Eyelink('command','screen_pixel_coords = %ld %ld %ld %ld', 0, 0, width-1, height-1); % sets physical.ini to screen pixels
    Eyelink('message', 'DISPLAY_COORDS %ld %ld %ld %ld', 0, 0, width-1, height-1);
end

%% calibration type: HV5 
function  callibrationType_HV5_eyeLink()
    Eyelink('command', 'calibration_type = HV5'); % 9 point calibration, set in calibr.ini
end

%% calibration type: HV9 
function  callibrationType_HV9_eyeLink()
    Eyelink('command', 'calibration_type = HV9'); % 9 point calibration, set in calibr.ini
end







