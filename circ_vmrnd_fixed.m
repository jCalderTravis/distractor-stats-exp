function samples = circ_vmrnd_fixed(mu, kappa, shape)
% Returns values on the interval [0 2*pi] rather than [-pi pi], if necessary.
% Reshape the output, if necessary.

samples = circ_vmrnd(mu, kappa, shape);


if kappa < 1e-6
    
    samples = samples - pi;
    
    
    samples = reshape(samples, shape);
    
    
end


% Defensive programming
if any(any(samples > pi)) || any(any(samples < -pi))
    
    error('Von Misses function is returning unexpected values')
    
    
end
