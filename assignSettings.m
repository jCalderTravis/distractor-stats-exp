function ExpInfo = assignSettings(ExpInfo, session)
% Assign all the Data.Settings which are universal to all trials, and specifics of
% the set up.

%% Basics

ExpInfo.Session = session;


% Some settings depend on whether we are on the experimental machine or not
ExpInfo.ExpMachine = false;
ExpInfo.RunTraining = false;


% Seed the random numbr generator
rng('shuffle');
ExpInfo.RandGenerator = rng;


% Set up the computer
Priority(1);
HideCursor();
ListenChar(2);
KbName('UnifyKeyNames');


%% Psychtoolbox Data.Settings

if ExpInfo.ExpMachine
    
    windowPtr = 0;
    
    
else
    
    windowPtr = 0;
    
    
end


[ExpInfo.Win, ExpInfo.WinArea] = Screen('OpenWindow', windowPtr); 


ExpInfo.ScreenCenter = [ ExpInfo.WinArea(3)/2 ; ExpInfo.WinArea(4)/2 ]; 


% Test that the refresh rate is as expected
ExpInfo.RefreshRate = Screen('NominalFrameRate', ExpInfo.Win);


if ExpInfo.ExpMachine && ...
    (ExpInfo.RefreshRate ~= 60 || ...
    ~isequal(ExpInfo.WinArea, [0 0 1920 1080]) )
    
    sca
    error('Error: Unexpected refresh rate or screen size.')
    
    
end


% Set the colours to use
ExpInfo.Colour.Base = [0.5 0.5 0.5]*255;


% Fill screen with background colour
Screen('FillRect', ExpInfo.Win, ExpInfo.Colour.Base);


% Set text sizes
ExpInfo.Text.Size2 = 20;


% Set font
Screen('TextFont', ExpInfo.Win, 'Helvetica')


%% Eyelink

if ExpInfo.ExpMachine
    
    Eyelink('Initialize');
    
    
    [worked]=EyelinkInit();
    
    
    if worked
        
        ExpInfo.El = EyelinkInitDefaults(ExpInfo.Win);
        
        
        ExpInfo.El.backgroundcolour = ExpInfo.Colour.Base;
        ExpInfo.El.foregroundcolour = 0;
        
        
        % Set to collect gaze data
        Eyelink('Command', 'file_sample_data=LEFT, RIGHT, GAZE, AREA');
        Eyelink('Command', 'screen_pixel_coords = 0 0 1920 1080');
        
        
        Eyelink('Heuristic filter', 'OFF')
        
        
    else
        
        sca
        error('Failed to initialise eye tracker.')
        
        
    end
    

end


%% Experiment structure

ExpInfo.NumBlocks = 8;
ExpInfo.TrialsPerBlock = 64;

ExpInfo.TrainBlocks = 4;
ExpInfo.TrialsPerTrainBlock = 40;


% Do less training if this is not the first session
if session ~= 1
    
    ExpInfo.TrainBlocks = 2;
    
    
end


ExpInfo.SetSizeConds = [2, 3, 4, 6];
ExpInfo.DistributionConds = {'uniform', 'conc'};


% Check that The number of trials in each block is divisible by the number of
% set sizes, and that the number of blocks is divisible by the number of
% distributions.
if mod(ExpInfo.TrialsPerBlock, length(ExpInfo.SetSizeConds)) ~= 0 || ...
        mod(ExpInfo.NumBlocks, length(ExpInfo.DistributionConds)) ~= 0
    
    sca
    error('Unbalanced design.')
    
    
end


% Randomise first block type, and set block order
if length(ExpInfo.DistributionConds) ~= 2; error('Two block types assumed.'); end

if rand(1) < 0.5
    
    ExpInfo.BlockOrder = [1 1 2 2 2 2 1 1];
    ExpInfo.TrainBlockOrder = [1 2 1 2];
    
    
else
    
    ExpInfo.BlockOrder = [2 2 1 1 1 1 2 2];
    ExpInfo.TrainBlockOrder = [2 1 2 1];
    
    
end


%% Timing

ExpInfo.FixTime = 0.5; % Duration of the fixation cross
ExpInfo.StimDuration = 0.100; 


%% Display

% Set size of fixation cross
ExpInfo.FixationScale = 6;


% Pick orientation statistics
ExpInfo.MeanAngle = pi/2;
ExpInfo.DistractorKappa = [0, 1.5]; % Concentration parameter, one for each 
% block type


% Determine Gabor center locations

% First specify the angles from verticle that want the Gabors
ExpInfo.Theta = [-(5/6)*pi, -(1/2)*pi, -(1/6)*pi, (1/6)*pi, (1/2)*pi, (5/6)*pi]';


% Specify the radius of the circle on which the Gabors will be located
ExpInfo.RGabor = 196;


% Compute the displacement from screen center of the Gabors
xDisp = ExpInfo.RGabor * sin(ExpInfo.Theta);
yDisp = ExpInfo.RGabor * cos(ExpInfo.Theta);


% Compute the locations on the screen in Psychtoolbox coords
x = round(xDisp) + ExpInfo.ScreenCenter(1);
y = -round(yDisp) + ExpInfo.ScreenCenter(2);


ExpInfo.GaborCenters = [x, y];


% Define the squares in which the Gabors will be placed
ExpInfo.GaborSD = 10;
ExpInfo.GaborSquareWidth = (10 * ExpInfo.GaborSD) +1; %In pixels


for iGabor = 1 : length(ExpInfo.Theta)
    
    center = ExpInfo.GaborCenters(iGabor, :);
    halfWidth = (1/2) * (ExpInfo.GaborSquareWidth -1);
    
    
    ExpInfo.GaborSquare{iGabor} = [(center(1) - halfWidth -1), ...
        (center(2) - halfWidth -1), ...
        (center(1) + halfWidth), ...
        (center(2) + halfWidth)];
    
    
end


% Also define the locations to present example stimuli during instructions.
% First specify as fractions of the screen relative to the center point and
% then scale.
exampleStimCenters = NaN(31, 2);

% The first one will be the target. Set on its own
exampleStimCenters(1, :) = [-39/49 , 6/28];

% The specify the distractor locations
exampleStimCenters(2 : 11 , 2) = 0;
exampleStimCenters(12 : 21 , 2) = 6/28;
exampleStimCenters(22 : 31 , 2) = 12/28;

exampleStimCenters(2 : 31 , 1) = repmat([-12:6:42]/49, 1, 3);


% Now scale and center
exampleStimCenters(:, 1) = exampleStimCenters(:, 1)*((1/2) * ...
    (ExpInfo.WinArea(3) - ExpInfo.WinArea(1)));


exampleStimCenters(:, 2) = exampleStimCenters(:, 2)*((1/2) * ...
    (ExpInfo.WinArea(4) - ExpInfo.WinArea(2)));


exampleStimCenters(:, 1) = exampleStimCenters(:, 1) + ExpInfo.ScreenCenter(1);
exampleStimCenters(:, 2) = exampleStimCenters(:, 2) + ExpInfo.ScreenCenter(2);


for iGabor = 1 : size(exampleStimCenters, 1)
    
    center = exampleStimCenters(iGabor, :);
    halfWidth = (1/2) * (ExpInfo.GaborSquareWidth -1);
    
    
    ExpInfo.ExampleGaborSquare{iGabor} = [(center(1) - halfWidth -1), ...
        (center(2) - halfWidth -1), ...
        (center(1) + halfWidth), ...
        (center(2) + halfWidth)];
    
    
end


% Check there is no overlap of boxes
gaborMaps = zeros(ExpInfo.WinArea(3), ExpInfo.WinArea(4));


for iGabor = 1 : length(ExpInfo.Theta)
    
    xLocationOfSquare = ...
        ExpInfo.GaborSquare{iGabor}(1) : ExpInfo.GaborSquare{iGabor}(3);
    
    yLocationOfSquare = ...
        ExpInfo.GaborSquare{iGabor}(2) : ExpInfo.GaborSquare{iGabor}(4);

    
    gaborMaps(xLocationOfSquare, yLocationOfSquare) = ...
        gaborMaps(xLocationOfSquare, yLocationOfSquare) + 1;
    
     
end


if any(any(gaborMaps > 1)); error('Bug'); end 



