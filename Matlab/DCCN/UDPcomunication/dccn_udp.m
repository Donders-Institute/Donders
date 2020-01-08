% Template to be controlled from outside of Matlab
% This Recipie has been coocked by Jose Garcia-Uceda Calvo
function myDCCNFcn() 

        clear; close all;

        o=1; t= 0; arr(1,1)=1;

        mssg   = '#none#';
        status = '@#Iniciated#@'; 

        figure(1)
        cnt = 1;

        port_receive = 9990;
        port_send    = 8880;
        
        command = 'nothing';
        
        while (o == 1) %%&& strcmp(status,'@#Iniciated#@')

              % receiving  
              try  
                  % IMPORTANT : here we have to play with the port!
                  % sometimes is occupied by another application
                  % so we should try with another one.
                  mssg = judp('receive',port_receive,1024,1000);
                  command = char(mssg')
              catch

              end

              % sending
              try
                    judp('send',port_send,'localhost',int8('pong'));       
                    %judp('send',port_send,'localhost',int8('Connection terminated...chao!'));
              catch

              end
              
              try
                    commands_eye(command);
              catch                 
                    disp('ERROR: EyeLink not connected')
              end
              
              
        end

end

function commands_eye(command)
         
        % Initialization 
        if strcmp(command,'initialization') 
           ini_eye
        end
        
        % record
        if strcmp(command,'record')
           record_eye
        end
        
        % stop
        if strcmp(command,'stop')
           stop_eye
        end

end

function [EyelinkConnected,File_name,error] = ini_eye()
        %% Initialization
        Eyelink('Initialize');
        %pause(3);

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

function [error, EyeUsed] = record_eye()
        %% Start recording
        Eyelink('StartRecording');

        Error = Eyelink('CheckRecording');
        EyeUsed = Eyelink('eyeavailable'); %receive info about which eye is tracked.
        pause(3);
end

function stop_eye()
        %% Stop recording and close file and connection
        Eyelink('StopRecording');
        pause(3);
        Eyelink('CloseFile');
        Eyelink('Shutdown');
end

function settings_eye()

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
        
        
        % sourcehttps://psadil.gitlab.io/psadil/post/eyetracking-init/
        
        %Reduce FOV
        Eyelink('command','calibration_area_proportion = 0.5 0.5');
        Eyelink('command','validation_area_proportion = 0.48 0.48');

        % open file to record data to
        i = Eyelink('Openfile', constants.eyelink_data_fname);
        if i ~= 0
            fprintf('\n Cannot create EDF file \n');
            exit_flag = 'ESC';
            return;
        end

        Eyelink('command', 'add_file_preamble_text ''Recorded by NAME OF EXPERIMENT''');

        % Setting the proper recording resolution, proper calibration type,
        % as well as the data file content;
        Eyelink('command','screen_pixel_coords = %ld %ld %ld %ld', 0, 0, window.winRect(3)-1, window.winRect(4)-1);
        Eyelink('message', 'DISPLAY_COORDS %ld %ld %ld %ld', 0, 0, window.winRect(3)-1, window.winRect(4)-1);
        % set calibration type.
        Eyelink('command', 'calibration_type = HV5');

        % set EDF file contents using the file_sample_data and
        % file-event_filter commands
        % set link data thtough link_sample_data and link_event_filter
        Eyelink('command', 'file_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,MESSAGE,BUTTON,INPUT');
        Eyelink('command', 'link_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,MESSAGE,BUTTON,INPUT');

        % check the software version
        % add "HTARGET" to record possible target data for EyeLink Remote
        Eyelink('command', 'file_sample_data  = LEFT,RIGHT,GAZE,HREF,GAZERES,AREA,HTARGET,STATUS,INPUT');
        Eyelink('command', 'link_sample_data  = LEFT,RIGHT,GAZE,HREF,GAZERES,AREA,HTARGET,STATUS,INPUT');

        % make sure we're still connected.
        if Eyelink('IsConnected')~=1 && input.dummymode == 0
            exit_flag = 'ESC';
            return;
        end

        % possible changes from EyelinkPictureCustomCalibration

        % set sample rate in camera setup screen
        Eyelink('command', 'sample_rate = %d', 1000);
        
        % Must be offline to draw to EyeLink screen
        Eyelink('Command', 'set_idle_mode');

        % clear tracker display
        Eyelink('Command', 'clear_screen 0');

        Eyelink('StartRecording');

        % always wait a moment for recording to have definitely started
        WaitSecs(0.1);
        
        Eyelink('message', 'SYNCTIME');
               
        % the Eyelink('ReceiveFile') function does not wait for the file
        % transfer to complete so you must have the entire try loop
        % surrounding the function to ensure complete transfer of the EDF.
        try
            fprintf('Receiving data file ''%s''\n',  constants.eyelink_data_fname );
            status = eyetrackerFcn('ReceiveFile');
            if status > 0
                fprintf('ReceiveFile status %d\n', status);
            end
            if 2==exist(edfFile, 'file')
                fprintf('Data file ''%s'' can be found in ''%s''\n',  constants.eyelink_data_fname, pwd );
            end
        catch
            fprintf('Problem receiving data file ''%s''\n',  constants.eyelink_data_fname );
        end

        

end

function eyelinkFcn = makeEyelinkFcn(handlerName)

valid_types = {'none','T60'};
assert(ismember(handlerName, valid_types),...
    ['"handlerType" argument must be one of the following: ' strjoin(valid_types,', ')])

switch handlerName
    case 'T60'
        eyelinkFcn = @T60;
    case 'none'
        eyelinkFcn = @do_nothing;
end

% more code to follow

end


%source: https://github.com/psadil/VTF




function eyelinkFcn = makeEyelinkFcn(handlerName)

valid_types = {'none','T60'};
assert(ismember(handlerName, valid_types),...
    ['"handlerType" argument must be one of the following: ' strjoin(valid_types,', ')])

switch handlerName
    case 'T60'
        eyelinkFcn = @T60;
    case 'none'
        eyelinkFcn = @do_nothing;
end

    function status = T60(varargin)
        status = [];
        switch varargin{1}
            case 'EyelinkDoDriftCorrection'
                % Do a drift correction at the beginning of each trial
                % Performing drift correction (checking) is optional for
                % EyeLink 1000 eye trackers.
                EyelinkDoDriftCorrection(varargin{2},[],[],0);

            case 'Command'
                Eyelink('Command', varargin{2})

            case 'ImageTransfer'
                %transfer image to host
                transferimginfo = imfinfo(varargin{2});
                [width, height] = Screen('WindowSize', 0);

                % image file should be 24bit or 32bit b5itmap
                % parameters of ImageTransfer:
                % imagePath, xPosition, yPosition, width, height, trackerXPosition, trackerYPosition, xferoptions
                transferStatus =  Eyelink('ImageTransfer',transferimginfo.Filename,...
                    0, 0, transferimginfo.Width, transferimginfo.Height, ...
                    width/2-transferimginfo.Width/2 ,height/2-transferimginfo.Height/2, 1);
                if transferStatus ~= 0
                    fprintf('*****Image transfer Failed*****-------\n');
                end

            case 'StartRecording'
                Eyelink('StartRecording');

            case 'Message'
                if nargin == 2
                    Eyelink('Message', varargin{2});
                elseif nargin == 3
                    Eyelink('Message', varargin{2}, varargin{3});
                elseif nargin == 4
                    Eyelink('Message', varargin{2}, varargin{3}, varargin{4});
                end
            case 'StopRecording'
                Eyelink('StopRecording');
            case 'CloseFile'
                Eyelink('CloseFile');
            case 'ReceiveFile'
                Eyelink('ReceiveFile');
            case 'EyeAvailable'
                status = Eyelink('EyeAvailable');
        end

    end

    function do_nothing(varargin)
        % do nothing with arguments
    end

end



function [el, exit_flag] = setupEyeTracker( tracker, window, constants )
% SET UP TRACKER CONFIGURATION


%%
exit_flag = 'OK';

switch tracker
    
    case 'T60'
        % Provide Eyelink with details about the graphics environment
        % and perform some initializations. The information is returned
        % in a structure that also contains useful defaults
        % and control codes (e.g. tracker state bit and Eyelink key values).
        el = EyelinkInitDefaults(window.pointer);
        
        % overrride default gray background of eyelink, otherwise runs end
        % up gray! also, probably best to calibrate with same colors of
        % background / stimuli as participant will encounter
        el.backgroundcolour = window.background;
        el.foregroundcolour = window.white;
        el.msgfontcolour = window.white;
        el.imgtitlecolour = window.white;
        el.calibrationtargetcolour=[window.white window.white window.white];
        EyelinkUpdateDefaults(el);
        
        if ~EyelinkInit(0, 1)
            fprintf('\n Eyelink Init aborted \n');
            exit_flag = 'ESC';
            return;
        end
        
        %Reduce FOV
        Eyelink('command','calibration_area_proportion = 0.5 0.5');
        Eyelink('command','validation_area_proportion = 0.48 0.48');
        
        % open file to record data to
        i = Eyelink('Openfile', constants.eyelink_data_fname);
        if i ~= 0
            fprintf('\n Cannot create EDF file \n');
            exit_flag = 'ESC';
            return;
        end
        
        Eyelink('command', 'add_file_preamble_text ''Recorded by VTF''');
        
        % Setting the proper recording resolution, proper calibration type,
        % as well as the data file content;
        Eyelink('command','screen_pixel_coords = %ld %ld %ld %ld', 0, 0, window.winRect(3)-1, window.winRect(4)-1);
        Eyelink('message', 'DISPLAY_COORDS %ld %ld %ld %ld', 0, 0, window.winRect(3)-1, window.winRect(4)-1);
        % set calibration type.
        Eyelink('command', 'calibration_type = HV5');
        
        % set EDF file contents using the file_sample_data and
        % file-event_filter commands
        % set link data thtough link_sample_data and link_event_filter
        Eyelink('command', 'file_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,MESSAGE,BUTTON,INPUT');
        Eyelink('command', 'link_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,MESSAGE,BUTTON,INPUT');
        
        % check the software version
        % add "HTARGET" to record possible target data for EyeLink Remote
        Eyelink('command', 'file_sample_data  = LEFT,RIGHT,GAZE,HREF,GAZERES,AREA,HTARGET,STATUS,INPUT');
        Eyelink('command', 'link_sample_data  = LEFT,RIGHT,GAZE,HREF,GAZERES,AREA,HTARGET,STATUS,INPUT');
        
        % make sure we're still connected.
        if Eyelink('IsConnected')~=1 && input.dummymode == 0
            exit_flag = 'ESC';
            return;
        end
        
        %% possible changes from EyelinkPictureCustomCalibration
        
        % set sample rate in camera setup screen
        Eyelink('command', 'sample_rate = %d', 1000);
        
        
        %%
        EyelinkDoTrackerSetup(el);
        
        
    case 'none'
        el = [];
end

end




