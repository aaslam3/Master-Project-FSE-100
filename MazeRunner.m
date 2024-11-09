%#ok<*GVMIS>

% 0 == unknown color
% 1 == black
% 2 == blue
% 3 == green
% 4 == yellow
% 5 == red
% 6 == white
% 7 == brown

global key;

InitKeyboard();

% brick = 0;
% distance = 0;
% color = 0;
redLineCount = 0;
blueCount = 0;
greenCount = 0;
dropOffPointReached = false;

while true
    switch key
        case 'q'
            brick.MoveMotor('AB', 0);
            brick.MoveMotor('C', 0);
            CloseKeyboard();
            break;

        case 'i'
            dropOffPointReached = true;
            disp('Drop off point set true manually.');

        case 'o'
            dropOffPointReached = false;
            disp('Drop off point set false manually.');
    end

    pause(0.05);

    % fprintf('\nRed color counter : %f\n', redLineCount);
    % fprintf('Blue color counter : %f\n', blueCount);
    % fprintf('Green color counter : %f\n', greenCount);
    fprintf('Drop off point : %d\n', dropOffPointReached);

    brick.SetColorMode(1, 2);

    distance = brick.UltrasonicDist(2);
    fprintf('Distance : %.f\n', distance);

    color = brick.ColorCode(1);
    fprintf('Color : %.f\n', color);


    if (dropOffPointReached == true)
        dropOffPointReached = MazeRunnerFunctions.manualControl(brick);

    else
        [dropOffPointReached, blueCount, greenCount, redLineCount] = MazeRunnerFunctions.autoControl(brick, distance, blueCount, greenCount, redLineCount);
    end


end
