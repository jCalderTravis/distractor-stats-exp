function [relevantKeyPress, BlockData] = checkForResp(BlockData, trialNum)


% Flag
relevantKeyPress = false;


[keyDown, responseTime, keyCode] = KbCheck;


% Is the 'f' pressed indicating no target?
if keyDown && keyCode(70)
    
    BlockData.Resp(trialNum) = 0;
    relevantKeyPress = true;
    
    
% Is the 'j' pressed indicating a target?
elseif keyDown && keyCode(74)
    
    BlockData.Resp(trialNum) = 1;
    relevantKeyPress = true;

    
end


% If any relevant key is pressed store RTs
if keyDown && relevantKeyPress
    
BlockData.RtAbs(trialNum) = responseTime;
BlockData.RT(trialNum) = ...
    BlockData.RtAbs(trialNum) ...
    - BlockData.FixFlipTime(trialNum) - BlockData.StimFlipTime(trialNum);

BlockData.Acc(trialNum) = BlockData.Resp(trialNum) == BlockData.Target(trialNum);


end
