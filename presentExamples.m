function presentExamples(ExpInfo, blockType, backgroundIm)
% Over the top of backgroundIm, presents examples of the stimulus and target.

% The Gabor on the far left will be an example of the target
exampleOrientations = NaN(1, length(ExpInfo.ExampleGaborSquare));
exampleOrientations(1) = ExpInfo.MeanAngle;


%% Display a series of examples

startTime = GetSecs;

for iFrame = 1 : 20
    
    % Pick the example distractor Gabor orientations
    exampleOrientations(2 : end) = circ_vmrnd_fixed(ExpInfo.MeanAngle, ...
        ExpInfo.DistractorKappa(blockType), [1 length(exampleOrientations)-1]);
    
    
    % Draw the background and the stimulus
    instrctTexture = Screen('MakeTexture', ExpInfo.Win, backgroundIm);
    Screen('DrawTexture', ExpInfo.Win, instrctTexture, [], ExpInfo.WinArea);
    
    
    drawGabors(ExpInfo, ExpInfo.ExampleGaborSquare, exampleOrientations)
    
    
    % Wait to flip
    Screen('Flip', ExpInfo.Win, startTime +  iFrame*(1/2));
    
    
    % Tidy up
    Screen('Close')
    

end


