%#ok<*GVMIS>



global key;

InitKeyboard();

% brick = 0;
% distance = 0;
% color = 0;

distanceThreshold = 15;
% if distance is less than this value, then we decide to move left or right
% in the autoControl function. leave it at 15 unless experimenting.

distanceOffset = 30; % this value should be heavily tested and verified it works.
% if there isnt a wall distanceThreshold + distanceOffset cm away, 
% we know that that turn is also navigable. the offset is here to 
% resolve the case where it detects a wall but its less than our
% threshold which needs the car to be very close to the wall.
% essentially im extending the threshold.

manualControlPointReached = false;

% 0 == unknown color
% 1 == black
% 2 == blue
% 3 == green
% 4 == yellow
% 5 == red
% 6 == white
% 7 == brown

firstColorDetected = 3; % green
% this is the starting color

manualControlPoint = 4; % yellow. 
% should be changed for what is given by the prof. 
% this is the color where we switch to manual control

targetDropOffColor = 2; % blue
% should be changed for what is given by the prof. 
% this is the color we have to reach after turning off manual control

passengerPickedUp = false;
% this is a flag to check if we passed pick up point and picked up
% passenger. useful for if we reach the drop off point without picking up
% passenger.

while true
    pause(0.05);

    switch key
        case 'q'
            brick.MoveMotor('AB', 0);
            brick.MoveMotor('C', 0);
            CloseKeyboard();
            break;

        case 'i'
            manualControlPointReached = true;
            disp('Drop off point set true manually.');

        case 'o'
            manualControlPointReached = false;
            disp('Drop off point set false manually.');
    end

    % fprintf('Drop off point : %d\n', dropOffPointReached);

    brick.SetColorMode(1, 2);

    distance = brick.UltrasonicDist(2);
    % fprintf('Distance : %.f\n', distance);

    color = brick.ColorCode(1);
    % fprintf('Color : %.f\n', color);


    if (manualControlPointReached == true)
        % manual keyboard control
        [manualControlPointReached, passengerPickedUp] = MazeRunnerFunctions.manualControl(brick, key);
        continue;

    else
        % auto control
        manualControlPointReached = MazeRunnerFunctions.autoControl(brick, distance, color, firstColorDetected, manualControlPoint, targetDropOffColor, distanceThreshold, distanceOffset);
        continue;
    end


end