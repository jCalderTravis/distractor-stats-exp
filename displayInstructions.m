function displayInstructions(ExpInfo, instructionSet)
% Loads images containing the participant instructions and displays them.

% INPUTS
% instructionSet        Specifies which set of instructions to display.


% Specify the first and final slide in each set
set1 = {1, 14};
set2 = {15, 15};
set3 = {16, 16};
set4 = {17, 17};
set5 = {18, 18};
set6 = {19, 19};
set7 = {20, 20};
setSpecificaiton = {set1, set2, set3, set4, set5, set6, set7};


% Display the slides in turn
instructFinished = false;
firstSlide = setSpecificaiton{instructionSet}{1};
finalSlide = setSpecificaiton{instructionSet}{2};


iSlide = firstSlide;


while ~instructFinished
    
    % Load the images
    instructIm = imread([pwd '/Instructions/Slide' num2str(iSlide) '.png']);
    
    
    % Display the images
    instrctTexture = Screen('MakeTexture', ExpInfo.Win, instructIm);
    Screen('FillRect', ExpInfo.Win, [254, 254, 254]);
    Screen('DrawTexture', ExpInfo.Win, instrctTexture, [], ExpInfo.WinArea);
    Screen('Flip', ExpInfo.Win)
    
    
    % Do we want to overlay a video of stimulus examples?
    if any(iSlide == [6, 8, 19, 20])
        
        if any(iSlide == [6 19])
            
            blockType = 1;
            
            
        elseif any(iSlide == [8 20])
            
            blockType = 2;
            
            
        end
        
        
        presentExamples(ExpInfo, blockType, instructIm)
        
        
    end
    
    
    response = waitForInput('lr');
    
    
    if strcmp(response, 'l')
        
        iSlide = iSlide - 1;
        iSlide(iSlide < firstSlide) = firstSlide;
        
        
    elseif strcmp(response, 'r')
        
        if iSlide == finalSlide
            
            instructFinished = true;
            
            
        end
        
        
        iSlide = iSlide + 1;
        
        
    end
    
    
end


% Clear screen, but for visual continuity don't clear screen after
% instructionSet 2, 4, and 5 as more intructions will be immediately 
% presented
if all(instructionSet ~= [2, 4, 5])
    
    Screen('FillRect', ExpInfo.Win, ExpInfo.Colour.Base);
    Screen('Flip', ExpInfo.Win);
    
    
end

