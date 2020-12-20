function BlockData = runTrial(ExpInfo, BlockData, phase, blockType, trialNum)


%% Randomise the display

% Randomise the locations in the display that are active, and shuffle these
% locations (the target will be the first one if it is present)
activeLocations = ...
    randperm(length(ExpInfo.GaborSquare), BlockData.SetSize(trialNum));


% Randomise target presence/absense, and pick locations of target and
% distractors from the shuffled array activeLocations
if rand(1) > 0.5

    BlockData.Target(trialNum) = 1;
    BlockData.TargetLoc(trialNum) = activeLocations(1);
    BlockData.Orientation(trialNum, BlockData.TargetLoc(trialNum)) = ...
        ExpInfo.MeanAngle;

    
    % Set the distractor orientations
    BlockData.Orientation(trialNum, activeLocations(2 : end)) = ...
        circ_vmrnd_fixed(ExpInfo.MeanAngle, ExpInfo.DistractorKappa(blockType), ...
        [1 BlockData.SetSize(trialNum)-1]);
    
    
else 
    
    BlockData.Target(trialNum) = 0;
    
    
    % Set the distractor orientations
    BlockData.Orientation(trialNum, activeLocations) = ...
        circ_vmrnd_fixed(ExpInfo.MeanAngle, ExpInfo.DistractorKappa(blockType), ...
        [1 BlockData.SetSize(trialNum)]);
    
    
end


%% Set up

if ExpInfo.ExpMachine && strcmp(phase, 'test')
    
    Eyelink('StartRecording')
    WaitSecs(0.1) % To ensure miss no data
    
    
    Eyelink('Message', ['Trial ' num2str(trialNum)])
    
    
end


% Measure trial duration for debugging 
trialStart = tic;


% Wait for all buttons to be released
while KbCheck ~= 0; end


%% Present fixation cross

scCenter = ExpInfo.ScreenCenter;
fixationScale = ExpInfo.FixationScale;


if ExpInfo.ExpMachine && strcmp(phase, 'test')
    
    Eyelink('Message', 'PreFixation')


end


Screen('DrawLines', ExpInfo.Win, ...
    [scCenter(1) scCenter(1) (fixationScale)+scCenter(1) (-fixationScale)+scCenter(1);
    (fixationScale)+scCenter(2) (-fixationScale)+scCenter(2) scCenter(2) scCenter(2)],...
    fixationScale*(6/15), [255 255 255]);


[BlockData.FixFlipTime(trialNum), ~, ...
    BlockData.FixFlipEnd(trialNum), ~, ~] = Screen('Flip', ExpInfo.Win);


% Additional timestamps and timing info
BlockData.FixTimeMes2(trialNum) = GetSecs;


if ExpInfo.ExpMachine && strcmp(phase, 'test')
    
    Eyelink('Message', 'PostFixation')


end


%% Present stimulus
% Work out when to make fixation clear and the stimulus appear
BlockData.StimulusOnset(trialNum) = ...
    BlockData.FixFlipTime(trialNum) + ExpInfo.FixTime - 0.005;


% Draw the stimulus
drawGabors(ExpInfo, ExpInfo.GaborSquare, BlockData.Orientation(trialNum, :))


% Prepare to monitor for a response
relevantKeyPress = false;


% Wait to flip 
[BlockData.StimFlipTime(trialNum), ~, ...
    BlockData.StimFlipEnd(trialNum), ~, ~] = ...
    Screen('Flip', ExpInfo.Win, BlockData.StimulusOnset(trialNum));
    

% All time measurements, apart from the fixation appear time, will be relative
% to the fixation appear time.
BlockData.StimFlipTime(trialNum) = ...
    BlockData.StimFlipTime(trialNum) - BlockData.FixFlipTime(trialNum);
BlockData.StimFlipEnd(trialNum) = ...
    BlockData.StimFlipEnd(trialNum) - BlockData.FixFlipTime(trialNum);


%% Present responses
% Work out when to clear the screen for the response
stimClearTime = BlockData.StimulusOnset(trialNum) + ExpInfo.StimDuration;


% Monitor for a response
while ~relevantKeyPress && (GetSecs < stimClearTime)
    
[relevantKeyPress, BlockData] = checkForResp(BlockData, trialNum);
    
    
end


% Clear screen 
[BlockData.StimClearFlipTime(trialNum), ~, ...
    BlockData.StimClearFlipEnd(trialNum), ~, ~] = ...
    Screen('Flip', ExpInfo.Win, stimClearTime);


BlockData.StimClearFlipTime(trialNum) = ...
    BlockData.StimClearFlipTime(trialNum) - BlockData.FixFlipTime(trialNum);
BlockData.StimClearFlipEnd(trialNum) = ...
    BlockData.StimClearFlipEnd(trialNum) - BlockData.FixFlipTime(trialNum);


if ExpInfo.ExpMachine && strcmp(phase, 'test')
    
    Eyelink('Message', 'StimEnd')


end


% Monitor for a response
while ~relevantKeyPress
    
[relevantKeyPress, BlockData] = checkForResp(BlockData, trialNum);
    
    
end



%% Finish up

if ExpInfo.ExpMachine && strcmp(phase, 'test')
    
    Eyelink('StopRecording')


end


% Display feedback via colour of fixation cross         
if BlockData.Acc(trialNum) == 1
    
    feedbackColour = [86, 180, 233];
    
    
elseif BlockData.Acc(trialNum) == 0
    
    feedbackColour = [230, 159, 0];
    
    
end


Screen('DrawLines', ExpInfo.Win, ...
    [scCenter(1) scCenter(1) (fixationScale)+scCenter(1) (-fixationScale)+scCenter(1);
    (fixationScale)+scCenter(2) (-fixationScale)+scCenter(2) scCenter(2) scCenter(2)],...
    fixationScale*(6/15), feedbackColour);


Screen('Flip', ExpInfo.Win);


WaitSecs(0.7)


% For debugging 
BlockData.TrialDuration(trialNum) = toc(trialStart);


% Tidy up
Screen('Close')

        
% Clear screen
Screen('FillRect', ExpInfo.Win, ExpInfo.Colour.Base);

Screen('Flip', ExpInfo.Win);





    
    






