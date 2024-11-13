shouldLoopExecute = true;

switch firstColorDetected
    case 2 % blue
        disp('FIRST COLOR DETECTED: BLUE');

    case 3 % green
        disp('FIRST COLOR DETECTED: GREEN');

    case 4 % yellow
        disp('FIRST COLOR DETECTED: YELLOW');

    case 5 % red
        disp('FIRST COLOR DETECTED: RED');

    otherwise
        disp('FIRST COLOR DETECTED: ERROR. DETECTED INVALID COLOR');
        shouldLoopExecute = false;
        % stops the loop from looping and ends program

        brick.MoveMotor('ABC', 0);
end

if distance < 15
    if redLineCount > 3 % turn right
        disp('Auto moving right');
        brick.MoveMotor('A', -50);
        brick.MoveMotor('B', 50);
        pause(0.4);

    else % turn left
        disp('Auto moving left');
        brick.MoveMotor('A', 50);
        brick.MoveMotor('B', -50);
        pause(0.4);
    end
end


% Unused function. might need to use it depending on the prof.
function DoColorStuff(brick, firstColorDetected, manualControlPoint, color)
    switch firstColorDetected
        case 2 % blue
    
            switch manualControlPoint
                case 3 % green
                    % if we start from blue and have to reach green
                    % for manual control. then we switch back to
                    % auto control and go to yellow.
                    if (color == 4)
    
                    end
    
                case 4 % yellow
                    % if we start from blue and have to reach yellow
                    % for manual control. then we switch back to
                    % auto control and go to green.
                    if (color == 3)
    
                    end
    
                otherwise
                    % default case
            end
    
    
        case 3 % green
    
            switch manualControlPoint
                case 2 % blue
                    % if we start from green and have to reach blue
                    % for manual control. then we switch back to
                    % auto control and go to yellow.
                    if (color == 4)
    
                    end
    
                case 4 % yellow
                    % if we start from green and have to reach yellow
                    % for manual control. then we switch back to
                    % auto control and go to blue.
                    if (color == 2)
    
                    end
    
                otherwise
                    % default case
            end
    
    
        case 4 % yellow
            % dropOffPointReachedReturn = dropPointReached(brick);
    
            switch manualControlPoint
                case 2 % blue
                    % if we start from yellow and have to reach blue
                    % for manual control. then we switch back to
                    % auto control and go to green.
                    if (color == 3)
    
                    end
    
                case 3 % green
                    % if we start from yellow and have to reach green
                    % for manual control. then we switch back to
                    % auto control and go to blue.
                    if (color == 2)
    
                    end
    
                otherwise
                    % default case
            end
    end
end