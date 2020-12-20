function eyeTrackerTest(ptpntNum, session)
% Run the eye tracker for three "trials" of nothing, to see if it is
% working


%% Eyelink setup
Eyelink('Initialize'); 


[worked]=EyelinkInit();


% Pschtoolbox stuff
[ExpInfo.Win, ExpInfo.WinArea] = Screen('OpenWindow', 0); 


% Fill screen with background colour
ExpInfo.Colour.Base = [0.5 0.5 0.5]*255;
Screen('FillRect', ExpInfo.Win, ExpInfo.Colour.Base);
Screen('Flip', ExpInfo.Win);


if worked
    
    El = EyelinkInitDefaults(ExpInfo.Win);

    
    El.backgroundcolour = 127.5;
    El.foregroundcolour = 0;
    
    
    % Set to collect gaze data
    Eyelink('Command', 'file_sample_data=LEFT, RIGHT, GAZE, AREA');
    Eyelink('Command', 'screen_pixel_coords = 0 0 1920 1080');
    
    
    Eyelink('Heuristic filter', 'OFF')
    
    
else
    
    sca
    error('Failed to initialise eye tracker.')
    

end


% Set up the file to record data into
ElFilename = ['eyeP' num2str(ptpntNum) 'S' num2str(session)]; 


edfFileStatus = Eyelink('OpenFile', ElFilename);


if edfFileStatus ~= 0
    
    sca
    error('Cannot open .edf file.')


end


% Calibration
ExpInfo.EyeCal = EyelinkDoTrackerSetup(El);


% Loop through trials
for iTrial = 1 : 5
    
    Eyelink('StartRecording')
    WaitSecs(0.1) % To ensure miss no data
    
    
    Eyelink('Message', ['Trial ' num2str(iTrial)])
    
    
    % Fill screen with bright colour
    ExpInfo.Colour.Base = [0 0 1]*255;
    Screen('FillRect', ExpInfo.Win, ExpInfo.Colour.Base);
    Screen('Flip', ExpInfo.Win);
    
    
    Eyelink('Message', 'StimStart');
    
    
    WaitSecs(3)
    
    
    % Fill screen with background colour
    ExpInfo.Colour.Base = [0.5 0.5 0.5]*255;
    Screen('FillRect', ExpInfo.Win, ExpInfo.Colour.Base);
    Screen('Flip', ExpInfo.Win);
    
    
    Eyelink('Message', 'StimEnd')
    
    
    WaitSecs(1)
    
    
    Eyelink('StopRecording');  
    

end


sca


% Close down eyelink
Eyelink('CloseFile');
Eyelink('ReceiveFile');



