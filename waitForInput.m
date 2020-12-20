function response = waitForInput(inputType)
% Waits for a time when no keys are pressed, then waits for the next key
% press and its release

% INPUT
% inputType     'any': Wait for any key to be pressed.
%               'lr':  Wait specifically for the left and right arrow 'lr'. In 
%                       this case return 'l' or 'r'.
%               'fj'   Wait specifically for f and j. Does not return 'f'
%                       or 'j'.


% Wait for no keys to be pressed
while KbCheck; end


%Wait until a key is pressed
pressed = false;

while ~pressed

    [pressed, ~, keyCode] = KbCheck;

    
    % Check if it is a valid response
    if pressed && strcmp(inputType, 'lr')
        
        if ~any(any(find(keyCode) == [37, 39]))
            
            pressed = 0;
            
            
        elseif find(keyCode) == 37
            
            response = 'l';
        
        
        elseif find(keyCode) == 39
        
            response = 'r';
        
        
        end
        
        
    elseif pressed && strcmp(inputType, 'fj')
        
        if ~any(any(find(keyCode) == [70, 74]))
            
            pressed = 0;
            
            
        else
            
            response = 'nonSpecific';
            
            
        end
        
        
    elseif pressed && strcmp(inputType, 'all')
        
        response = 'nonSpecific';
        
        
    end
         

end


% Wait for all buttons to be released
while KbCheck; end
