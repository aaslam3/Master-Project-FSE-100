global key;    %#ok<*GVMIS>         <---- Suppresses warnings about global variables
global brick;
global distance;
global color; 

disconnectBrickOnExit = false;

try
   brick = ConnectBrick('Senchariot');
catch exception
   disp('Brick already connected. ');
   disp(exception.message);
end

try 
    brick.SetColorMode(1, 2);
catch exception
    disp('Brick already in color mode 2.')
    disp(exception.message);
end


InitKeyboard();
redCount = 0;

while 1
    pause(0.05);

    if (brick == null)
        continue;
    end

    UpdateAndPrintValues(brick);

    % 0 == unknown color
    % 1 == black
    % 2 == blue
    % 3 == green
    % 4 == yellow
    % 5 == red
    % 6 == white
    % 7 == brown
    switch color
        case 2
            disp('Detected blue');
            playTwoTones(brick);

        case 3
            disp('Detected green');
            brick.playThreeTones();

        case 5
            disp('Detected red.');
            redCount = redCount+1;
            pause(1);
    end


    switch key
        case 'q' % When quit key is pressed
            if (disconnectBrickOnExit == true)
                DisconnectBrick(brick);
                CloseKeyboard();
                disp('Disconnecting brick..')
            end

            brick.StopAllMotors('Coast')
            disp('Quitting...');

            break;

        case 0 % When no key is pressed

            if distance < 20
                disp('  Wall Detected!  ')

                if redCount == 3
                    % TurnRight(brick);
                    Turn90Right(brick);
                    disp('Reached last red line. Turning Right');
                else
                    % TurnLeft(brick);
                    Turn90Left(brick);
                    disp('Turning Left');
                end

            else
                disp('No wall detected. Moving Forward')
                brick.MoveMotor('AB', -500);
            end
    end
end

% Updates global values and prints them too
function UpdateAndPrintValues(brick)
    if (brick == null)
        disp('Brick is null');
        return;
    end

    distance = brick.UltrasonicDist(2);
    disp('Distance (in cm): ' + distance);

    color = brick.ColorCode(1);
    disp('Color: ' + color);
end

% Turns car 90 degrees to the left with the relative angle
function Turn90Left(brick)
    if (brick == null)
        disp('Brick is null');
        return;
    end

    brick.MoveMotorAngleRel('A', 50, -90, 'Brake');
    brick.MoveMotorAngleRel('B', 50, 90, 'Brake');
    
    brick.WaitForMotor('A');    
    brick.WaitForMotor('B');
end

% Turns car 90 degrees to the right with the relative angle
function Turn90Right(brick)
    if (brick == null)
        disp('Brick is null');
        return;
    end

    brick.MoveMotorAngleRel('A', 50, 90, 'Brake');
    brick.MoveMotorAngleRel('B', 50, -90, 'Brake');
    
    brick.WaitForMotor('A');    
    brick.WaitForMotor('B');
end

% Old turn left function. do not use
function TurnLeft(brick)
    if (brick == null)
        disp('Brick is null');
        return;
    end

    brick.MoveMotor('B', 18);
    brick.MoveMotor('A', -18);
    pause(0.5);
    brick.StopAllMotors('Coast');
end

% NEED TO CHECK IF THESE FUNCTIONS ACTUALLY MAKE THE CAR TURN THE CORRECT WAY

% Old turn right function. do not use
function TurnRight(brick)
    if (brick == null)
        disp('Brick is null');
        return;
    end

    brick.MoveMotor('B', -18);
    brick.MoveMotor('A', 18);
    pause(0.5);
    brick.StopAllMotors('Coast');
end

% Ripped from the Brick.m file in the EV3 Toolbox and removed two lines.
% Should theoretically play two tones
function playTwoTones(brick) 
    % Brick.playTwoTones Play two tones on the brick
    %
    % Brick.playTwoTones() plays two tones consequentively on
    % the brick with one upload command.
    %
    % Example::
    %           b.playThreeTones();
    
    cmd = Command();
    cmd.addHeaderDirect(42,0,0);
    cmd.opSOUND_TONE(5,440,500);
    cmd.opSOUND_READY();
    cmd.opSOUND_TONE(10,880,500);
    cmd.opSOUND_READY();
    cmd.addLength();
    % print message
    fprintf('Sending two tone message ...\n');
    brick.send(cmd);    
end

brick.StopAllMotors('Coast'); % Tries to stop the motors but execution never reaches here.
