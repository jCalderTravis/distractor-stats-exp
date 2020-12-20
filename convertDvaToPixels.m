function pixels = convertDvaToPixels(DVA)
% Converts degrees of visual angle to numeber of pixels for a screen at
% 60cm with 37.5 pixels per cm

% Convert to radians
radOfVa = (DVA / 360) * 2 * pi;


pixels = tan(radOfVa/2) * 2 * 60 * 37.5;