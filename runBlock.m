function propCorrect = runBlock(ExpInfo, phase, blockNum, blockType, numTrials)


%% Set up

% Store basic info
BlockData.BlockNum = blockNum;
BlockData.BlockType= blockType;


% Initialise
BlockData.SetSize = NaN(numTrials, 1);
BlockData.Target = NaN(numTrials, 1);
BlockData.TargetLoc = NaN(numTrials, 1);
BlockData.Orientation = NaN(numTrials, 6);
BlockData.Resp = NaN(numTrials, 1);
BlockData.Acc = NaN(numTrials, 1);
BlockData.RtAbs = NaN(numTrials, 1); % Absolute RT
BlockData.RT = NaN(numTrials, 1);% RT relative to simulus onset
BlockData.FixFlipTime = NaN(numTrials, 1);
BlockData.FixFlipEnd = NaN(numTrials, 1);
BlockData.FixTimeMes2 = NaN(numTrials, 1);
BlockData.StimulusOnset = NaN(numTrials, 1);
BlockData.StimFlipTime = NaN(numTrials, 1);
BlockData.StimFlipEnd = NaN(numTrials, 1);
BlockData.StimClearFlipTime = NaN(numTrials, 1);
BlockData.StimClearFlipEnd = NaN(numTrials, 1);
BlockData.TrialDuration = NaN(numTrials, 1);


% Randomisation of set sizes to trials
trialsPerCondition = numTrials / length(ExpInfo.SetSizeConds);


if round(trialsPerCondition) ~= trialsPerCondition; error('Bug'); end


conditionOrder = repmat(ExpInfo.SetSizeConds, 1, trialsPerCondition);


conditionOrder = conditionOrder(randperm(length(conditionOrder)));


% Check the randomisation
for iCond = 1 : length(ExpInfo.SetSizeConds)
    
    numInCond = sum(conditionOrder == ExpInfo.SetSizeConds(iCond));
    
    
    if numInCond ~= trialsPerCondition; error('Bug'); end
    
    
end


BlockData.SetSize(1 : numTrials) = conditionOrder';



%% Initial instructions

% Skip instructions if this is a refresher block
if ~strcmp(phase, 'refresh')
    
    % Display progress
    if strcmp(phase, 'train')
        
        text = ['The next block is training block ' ...
            num2str(blockNum) ' of ' num2str(ExpInfo.TrainBlocks) '.' ...
            '\n\n\nPress any key to continue.'];
        
    elseif strcmp(phase, 'test')
        
        text = ['The next block is block ' ...
            num2str(blockNum) ' of ' num2str(ExpInfo.NumBlocks) '.' ...
            '\n\n\nPress any key to continue.'];
        
        
    end
    
    
    Screen('TextSize', ExpInfo.Win, ExpInfo.Text.Size2);
    
    DrawFormattedText(ExpInfo.Win, text, ...
        'center', 'center', [255 255 255], 1000, 0, 0, 1.3);
    
    Screen('Flip', ExpInfo.Win);
    
    
    waitForInput('all')
    
    
    % Give participant type of block, and instructions refresher
    if blockType == 1
        
        text4disp = ['Block type: ''any angle''.' ...
            '\n\nThe distractors are completely random, ', ...
            '\nand do not have a favourite angle.' ...
            '\n\n Press ''f'' or ''j'' to begin the block.'];
        
        
    elseif blockType == 2
        
        text4disp = ['Block type: ''concentrated angle''.', ...
            '\n\nThe distractors are likely to be similar to the target.'...
            '\n\n Press ''f'' or ''j'' to begin the block.'];
        
        
    end
    
    
    Screen('TextSize', ExpInfo.Win, ExpInfo.Text.Size2);
    
    DrawFormattedText(ExpInfo.Win, text4disp, 'center', 'center', ...
        [255 255 255], 1000, 0, 0, 1.3);
    
    Screen('Flip', ExpInfo.Win);
    
    
    waitForInput('fj')
    
    
end


%% Loop through trials

for iTrial = 1 : numTrials
    
    BlockData = runTrial(ExpInfo, BlockData, phase, blockType, iTrial);
    
    
end


% Save block data
if ~strcmp(phase, 'refresh')
    
    save([pwd '/Data/ptpnt' ExpInfo.PtpntCode '_' phase ...
        '_Session' num2str(ExpInfo.Session) 'Block' num2str(blockNum)], ...
        'BlockData');


end


% What is the overal proportion correct as a percentage?
propCorrect = sum(BlockData.Acc)/length(BlockData.Acc) * 100;




