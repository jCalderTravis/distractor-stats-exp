function [gabor, width] = makeGabor(sigma, lamda, theta, phi, backgroundColour)
% Generates a Gabor patch.


% INPUT
% sigma     Standard deviation of the Gaussian envolope, in PIXELS.
% lamda     Wavelength of the sinusoid, in PIXELS.
% theta     Orientation of the parallel stripes, clockwise from vertical. In
%           RADIANS.
% phi       Phase offset
% backgroundColour
%           This greyscale value will be added to all all elements before Gabor
%           is output.

% OUTPUT
% gabor     A three dimentional array. In the third dimention there are
%           three planes specifying respectively, RGB.
% width     Width of the square in which the Gabor is contained, in PIXELS.


if ~all(backgroundColour == 0.5) && ~all(backgroundColour == 127.5)
    
    warning(['Some of the range of the sinusoid function is truncated if you ', ...
        'do not use a background colour of 0.5.'])
    
    
end


% Create meshgrid to cover 10 standard deviations accross
xVals = -5*sigma : 5*sigma;
yVals = fliplr(xVals);

[x, y] = meshgrid(xVals, yVals);


% Rotate coordinates
xRotated = (x.*cos(theta)) - (y.*sin(theta));


% Create the sinusoidal pattern
sinusoid = cos((((2*pi)*xRotated)./lamda) + phi);


% Map onto the range [-1/2, 1/2];
sinusoid = 0.5 * sinusoid;


% Create the Gaussian envolope
envolope = exp(-(x.^2 + y.^2)/(2*(sigma^2)));


envolope = envolope / max(max(envolope));


% Apply envolope
gabor = envolope .* sinusoid;


% Change into 3D RGB image array
gabor = repmat(gabor, [1, 1, 3]);


% Change backgroundColour into 3D RGB image array
backgroundImage(1, 1, :) = backgroundColour;
backgroundImage = repmat(backgroundImage, [size(gabor, 1), size(gabor, 2) 1]);


% Change the scale from [0 1] to [0 255]
gabor = gabor * 255;


% Add background colour image to the Gabor image
gabor = gabor + backgroundImage;


% Defensive programming
if any([size(gabor, 1), size(gabor, 2)] ~= (sigma * 10) + 1)
    
    error('Bug')
    
    
end


width = size(gabor, 1);

