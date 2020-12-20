function drawGabors(ExpInfo, squareLocs, gaborOrientations)
% Draws a stimulus of Gabors ready for slipping

% INPUT
% squareLocs        The squares into which the Gabors will be drawn
% gaborOrientations Orienations of the Gabors to draw


% Check the input
if length(squareLocs) ~= size(gaborOrientations, 2) || ...
        size(gaborOrientations, 1) ~= 1
    
    sca
    error('Bug')
    
    
end


gaborTexture = cell(1, length(squareLocs));


for iPosition = 1 : length(squareLocs)
    
    % Check there is something to draw in this position
    if isnan(gaborOrientations(iPosition))
        
        continue
        
        
    end
  
    
    % We need to map orienation onto the range [-pi/2, pi/2] from [-pi, pi]
    % becuase the Gabor patches have no direction, and hense a pi/2
    % oriented patch is indistinguishable from a -pi/2 oriented patch
    mappedOrientation = (1/2) * gaborOrientations(iPosition);
    
    
    [gaborIm, width] = makeGabor(ExpInfo.GaborSD, 22, ...
        mappedOrientation, 0, ExpInfo.Colour.Base);
    

    gaborTexture{iPosition} = Screen('MakeTexture', ExpInfo.Win, gaborIm);
    
    
    Screen('drawtexture', ExpInfo.Win, gaborTexture{iPosition}, ...
        [0, 0, width, width], squareLocs{iPosition});
    
    
    % Check that the new Gabor texture is the same size as the square in which
    % we are going to draw it.
    if any(width ~= [ ...
        squareLocs{iPosition}(3) - squareLocs{iPosition}(1), ...
        squareLocs{iPosition}(4) - squareLocs{iPosition}(2)])
    
    
        error(['Target rect is not the same size as the rect in which the, ' ...
            'Gabor is contained.'])
        
        
    end
    
    
end
