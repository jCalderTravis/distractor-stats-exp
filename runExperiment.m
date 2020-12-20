function runExperiment(ptpntCode, session)

% INPUT
% session       Session number


% Original experimental set up.
% 1920 x 1080, 37.5 pixels per screen, at 60cm


% For debugging...
% PsychDebugWindowConfiguration


% For screen shots...
% imData = Screen('GetImage', ExpInfo.Win);
% imwrite(imData, 'imData1.png')
% sca


ExpInfo.PtpntCode = num2str(ptpntCode);


% Collect basic participant info and save seperately
if session == 1

collectParticipantInfo(ExpInfo.PtpntCode)


end


% Assign settings
ExpInfo = assignSettings(ExpInfo, session);


% Save experiment details
save([pwd '/Data/ptpnt' ExpInfo.PtpntCode '_Session' num2str(session) ...
    '_expInfo'], 'ExpInfo');


% Load highscores from previous sessions
if session ~= 1
    
    loadedFiles = ...
        load([pwd '/Data/ptpnt' ExpInfo.PtpntCode '_previousHighscores']);
    
    
    oldHighscores = loadedFiles.oldHighscores;
    
    
elseif session < 11
    
    oldHighscores = NaN(10, 2);
    
    
else
    
    error('Highscore functionality does not work with more than 10 sessions')
    
    
end



%% Instructions

% Initial instructions
displayInstructions(ExpInfo, 1)


%% Experiment

% Only run training if requested
if ExpInfo.RunTraining
    
    schedule = {'train', 'test'};
    
    
else
    
    schedule = {'test'};
    
    
end


for iPhase = 1 : length(schedule)
    
    % Initialise
    highscore = {'None completed', 'None completed'};
    
    
    if strcmp(schedule{iPhase}, 'train')

        numBlocks = ExpInfo.TrainBlocks;
        numTrials = ExpInfo.TrialsPerTrainBlock;
        blockOrder =ExpInfo.TrainBlockOrder;
    
        
    elseif strcmp(schedule{iPhase}, 'test')
        
        numBlocks = ExpInfo.NumBlocks;
        numTrials = ExpInfo.TrialsPerBlock;
        blockOrder = ExpInfo.BlockOrder;
        
        
        displayInstructions(ExpInfo, 2)

        
    end

   
    for iBlock = 1 : numBlocks
        
        % Do we need to do refresher training, and set up the eye tracker?
        if strcmp(schedule{iPhase}, 'test') && (mod(iBlock, 2) == 1)
            
            displayInstructions(ExpInfo, ExpInfo.BlockOrder(iBlock) +3)

           
            displayInstructions(ExpInfo, ExpInfo.BlockOrder(iBlock) +5)
             

            % Set up the file to record eye data into
            if ExpInfo.ExpMachine
                
                ElFilename = ['iP' num2str(ExpInfo.PtpntCode) 'S' num2str(session), ...
                    'B', num2str(iBlock)];
                
                
                edfFileStatus = Eyelink('OpenFile', ElFilename);
                
                
                if edfFileStatus ~= 0
                    
                    sca
                    error('Cannot open .edf file.')
                    
                    
                end
                
                
                % Calibration
                ExpInfo.EyeCal = EyelinkDoTrackerSetup(ExpInfo.El);
            
            
            end
            
            
        end
        
        
        HideCursor();
        
        
        propCorrect = ...
            runBlock(ExpInfo, schedule{iPhase}, iBlock, ...
            blockOrder(iBlock), numTrials);
        
        
        if strcmp(schedule{iPhase}, 'test')
            
            % Should we require the participant to rest?
            if iBlock == numBlocks
                
                forceWait = false;
                
                
            else
                
                forceWait = true;
                
                
            end
            
            
            if strcmp(schedule{iPhase}, 'test')
                
                highscore = manageHighscores(ExpInfo, highscore, ...
                    blockOrder(iBlock), propCorrect, forceWait, oldHighscores);
                
                
            end
        
        
        end
        
        
        % Do we need to save the eyelink data? Every two blocks we save the
        % data and close the file.
        if ExpInfo.ExpMachine && ...
                ((strcmp(schedule{iPhase}, 'test') && (mod(iBlock, 2) == 0)) || ...
                iBlock == numBlocks)
            
            Eyelink('CloseFile');
            Eyelink('ReceiveFile');
            
            
        end
        
        
    end
    
    
end


%% Finish up

% Save final highscores
oldHighscores(session, 1) = str2double(highscore{1});
oldHighscores(session, 2) = str2double(highscore{2});

save([pwd '\Data\ptpnt' ExpInfo.PtpntCode '_previousHighscores'], 'oldHighscores');
    

% Display instructions
displayInstructions(ExpInfo, 3)


% Display final highscores
highscore = manageHighscores(ExpInfo, highscore, ...
                    blockOrder(iBlock), NaN, false, oldHighscores);


% Close down
Priority(0);
sca
ListenChar(1);


