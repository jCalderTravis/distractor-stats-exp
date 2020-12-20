function highscore = manageHighscores(ExpInfo, highscore, blockType, ...
    propCorrect, forceWait, oldHighscores)
% Manage and present the highscores to the participant. If propCorrect is
% NaN and forceWait false, it just displays historical high scores.


%% Manage
% Update highscore if necessary
if strcmp(highscore{blockType}, 'None completed') || ...
        propCorrect > str2double(highscore{blockType})
    
    % Update
    highscore{blockType} = num2str(propCorrect);
    
 
end


% Provide a congratulations if it is a new high score.
if propCorrect > str2double(highscore{blockType})
    
    highscoreText = '*** Congratulations you beat your high score! ***';
    
    
else
    
    highscoreText = '';
    
    
end


%% Report
% Report score and highscore to the participant, and wait 30 seconds
blockTypeNames = {'any angle', 'concentrated'};

timerStart = GetSecs;

if forceWait

    timeRemaining = 30;
    clearTime = timerStart + 31;
    
    
else
    
    timeRemaining = 0;
    clearTime = timerStart;
    
    
end


% Create text that provides old highscores
oldScoreText = '';

if ~isnan(oldHighscores(1, 1))
    
    oldScoreText = '\n\n\n\n Your previous highscores...';
    
    
end


for iSession = 1 : size(oldHighscores, 1)
    
    if ~isnan(oldHighscores(iSession, 1))
        
        oldScoreText = [oldScoreText, ...
            '\nSession ' num2str(iSession) '           ' ...
            'any angle: ' addPercent(num2str(oldHighscores(iSession, 1))), ...
            '       concentrated: ' ...
            addPercent(num2str(oldHighscores(iSession, 2)))];
        
        
    end
    
    
end


while timeRemaining > 0

    textForDisplay =  ['Thanks for completing this ' ...
        blockTypeNames{blockType} ' block.' ...
        '\n\nYou got ' num2str(propCorrect) '% correct.', ...
        '\n' highscoreText, ...
        '\n\nYour highscores are...', ...
        '\nany angle: ' addPercent(highscore{1}), ...
        '\nconcentrated: ' addPercent(highscore{2}), ...
        '\n\nYou may begin the next block in ' num2str(timeRemaining) ...
        ' seconds.', ...
        oldScoreText];

    
    Screen('TextSize', ExpInfo.Win, ExpInfo.Text.Size2);
    DrawFormattedText(ExpInfo.Win, textForDisplay, ...
        'center', 'center', [255 255 255], 1000, 0, 0, 1.3);
    Screen('Flip', ExpInfo.Win, timerStart + 31 -timeRemaining);
    
    
    timeRemaining = timeRemaining -1;
 
    
end


% Message depends on whether participant has been waiting
if forceWait

    nextBlockText = '\n\nClick to begin the next block.';
    
    
else
    
    nextBlockText = '';
    
    
end


% Display the score from the last block if there is one
if ~isnan(propCorrect)

    textForDisplay =  ['Thanks for completing this ' ...
        blockTypeNames{blockType} ' block.' ...
        '\n\nYou got ' num2str(propCorrect) '% correct.', ...
        '\n' highscoreText, ...
        '\n\nYour highscores are ...', ...
        '\nany angle: ' addPercent(highscore{1}), ...
        '\nconcentrated: ' addPercent(highscore{2}), ...
        nextBlockText, ...
        oldScoreText];
    
    
    Screen('TextSize', ExpInfo.Win, ExpInfo.Text.Size2);
    DrawFormattedText(ExpInfo.Win, textForDisplay, ...
        'center', 'center', [255 255 255], 1000, 0, 0, 1.3);
    Screen('Flip', ExpInfo.Win, clearTime);
    
    
    waitForInput('all')


end


% If propCorrect is NaN just display historical high scores
if isnan(propCorrect)
    
    textForDisplay =  [oldScoreText];
    
    
    Screen('TextSize', ExpInfo.Win, ExpInfo.Text.Size2);
    DrawFormattedText(ExpInfo.Win, textForDisplay, ...
        'center', 'center', [255 255 255], 1000, 0, 0, 1.3);
    Screen('Flip', ExpInfo.Win, clearTime);
    
    
    waitForInput('all')


end


end 


function displayScore = addPercent(highscoreValue)
% Adds a percentage sign to the end of a high score if the high score is
% the string of a number. Else, it does not add a percentage sign.

% Does the string represent a number?
if ~isnan(str2double(highscoreValue))
    
    displayScore = [highscoreValue '%'];
    
    
else
    
    displayScore = highscoreValue;
    
    
end


end



