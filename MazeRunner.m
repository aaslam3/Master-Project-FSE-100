%#ok<*GVMIS>  suppresses global variable warnings

global key;

% this is the handle for the Figure n window that opens up when we run
% InitKeyboard(). (n being the number of figure).
textbox = InitKeyboardCustom();
pause(0.05);
% this delay is here to allow the textbox to initialize

color = 0;

brick.SetColorMode(1, 2);

% if distance is less than this value, then we decide to move left or right
% in the autoControl function. leave it at 15 unless experimenting.
distanceThreshold = 20;


% if there isnt a wall distanceThreshold + distanceOffset cm away, 
% we know that that turn is also navigable. the offset is here to 
% resolve the case where it detects a wall but its less than our
% threshold which needs the car to be very close to the wall.
% essentially im extending the threshold.
distanceOffset = 25;

% this is the starting color
firstColorDetected = 3;

% should be changed for what is given by the prof. 
% this is the color where we switch to manual control
manualControlPoint = 2;

% should be changed for what is given by the prof. 
% this is the color we have to reach after turning off manual control
targetDropOffColor = 4;

% this is a flag to check if we passed picked up the passenger. useful for 
% if we reach the drop off point without picking up passenger.
passengerPickedUp = false;

bManualControlPointReached = false;

% 0 == unknown color
% 1 == black
% 2 == blue
% 3 == green
% 4 == yellow
% 5 == red
% 6 == white
% 7 == brown

while true
    pause(0.05);

    switch key
        case 'q'
            Stop(brick);
            CloseKeyboard();
            break;
    end

    distance = brick.UltrasonicDist(2);
    % fprintf('Distance : %.2f\n', distance);

    touch = brick.TouchPressed(4);
    % fprintf('Touched wall : %d\n', touch);

    color = brick.ColorCode(1);
    fprintf('Color : %.f\n', color);


    if (bManualControlPointReached)
        % manual control start

        disp('In Manual control');
        bManualControlPointReached = true;
        passengerPickedUp = false;

        UpdateTextBox(textbox, key);

        switch key

            case 'p' % resume auto mode
                bManualControlPointReached = false;
                passengerPickedUp = true;
                disp('Drop off point reached false');

            case 'w' % open grabber
                brick.MoveMotor('C', 40);
                disp('opening grabber');

            case 's' % close grabber
                brick.MoveMotor('C', -40);
                disp('closing grabber');


            case 'leftarrow'
                brick.MoveMotor('A', 20);
                brick.MoveMotor('B', -20);

                disp('move left');

            case 'rightarrow'
                brick.MoveMotor('A', -20);
                brick.MoveMotor('B', 20);

                disp('move right');

            case 'uparrow'
                brick.MoveMotor('A', -20);
                brick.MoveMotor('B', -25);
                disp('move up');

            case 'downarrow'
                brick.MoveMotor('A', 20);
                brick.MoveMotor('B', 25);
                brick.beep(1, 700); 
                % to simulate a vehicle backing up which creates a beeping 
                % noise. just for cosmetic effect
                pause(1)
                disp('move down');

            case 0
                Stop(brick);
        end
        
        % manual control end
    else 
        % auto control start
        GoForward(brick);

        if (color == targetDropOffColor && passengerPickedUp == true)
            disp('!!! AT DROPOFF POINT WITH PASSENGER !!!    Setting passenger down and exiting program...');
            pause(1);
            Stop(brick);

            AtDropOffPointWork(brick);

            disp('Exiting...')
            return;
        end

        StopForColorsAndBeep(brick, color, firstColorDetected);

        if (color == 2 && manualControlPoint ~= 2)
            disp('Blue detected. Turning around...')
            TurnLeft(brick);
            pause(1);

            TurnLeft(brick);
            pause(1);

            GoForward(brick);
            pause(1);
        end

        % if color detected is red
        % if (color == 5)
            % CheckLeftAndRight(brick, distance, distanceThreshold, distanceOffset);
        % end

        % if at manual control point, set variable to true and return function
        if (color == manualControlPoint)
            bManualControlPointReached = true;
            disp('Drop off point reached. Moving to manual control');
            Stop(brick);

            % beeps five times (or maybe 6 not sure)
            for i = 1 : 5
                fprintf('beep %d', i + 1);
                brick.beep(1, 200);
                pause(0.6);
            end

            continue;
        end

        if touch == true
            % if touched a wall, go back a little bit and stop
            GoBack(brick);
            pause(0.3);
            Stop(brick);

            % check if we can turn right first. if distance is less than
            % threshold, then we turn left.
            CheckLeftAndRight(brick, distance, distanceThreshold, distanceOffset);
            continue;
        end

        % default turning right behavior.
        % turns right when there is no wall there.
        if (distance >= distanceThreshold + distanceOffset)
            disp('left open detected');
            pause(0.5); 
            % this pause lets the car go a little bit forward before 
            % turning to make sure it doesnt get stuck at the wall
        
            disp('turning left');
            TurnLeft(brick);
            GoForward(brick);
            pause(2);

            continue;
        end
    
        % Fixes distance to wall only if not in tolerance
        FixDistanceToWall(brick, distance, distanceThreshold);
   
        % auto control end
    end

    
end % while loop end

% Keeps the car a certain distance away from the right wall to make sure it
% doesnt keep dragging along the wall.
function FixDistanceToWall(brick, distance, distanceThreshold)
    
    isInToleranceTemp = CalculateIfInTolerance(distance, distanceThreshold);
    
    % doesnt run the rest of the function if the car is already perfect
    if (isInToleranceTemp == true)
        return;
    end
    
    disp('is not in tolerance');
    
    [low, high] = CalculateTolerance(distanceThreshold);
    
    fprintf('low: %.2f\n', low);
    fprintf('high: %.2f\n', high);
    
    idealDistance = (low + high) / 2;
    deviation = distance - idealDistance;
    
    motorSpeedScaleFactor = 0.1;  % the sensitivity
    scaledDeviation = deviation * motorSpeedScaleFactor;
    
    baseMotorSpeed = -5;
    adjustedMotorSpeed = baseMotorSpeed + scaledDeviation;

    maxMotorSpeed = 0;
    minMotorSpeed = -10;
    adjustedMotorSpeed = max(min(adjustedMotorSpeed, maxMotorSpeed), minMotorSpeed);
    
    % to make sure the speed doesnt go positive and make the car go
    % back

    if adjustedMotorSpeed > 0
        disp('Adjusted Motor Speed is greater than 0. Resetting to -5');
        adjustedMotorSpeed = -5;
        % should never come here.
    end

    fprintf('Ideal Distance        : %.2f\n', idealDistance);
    fprintf('Deviation             : %.2f\n', deviation);
    fprintf('Scaled Deviation      : %.2f\n', scaledDeviation);
    fprintf('Adjusted Motor Speed  : %.2f\n', adjustedMotorSpeed);

    if (distance <= low)
        % if too close to wall, turn slightly left.
        disp('too close to wall');
        brick.MoveMotor('B', adjustedMotorSpeed);
    
    elseif (distance >= high)
        % if too far from wall, turn slightly right.
        disp('too far from wall');
        brick.MoveMotor('A', adjustedMotorSpeed);
    
    end
    
    pause(0.2);
    GoForward(brick);
    pause(0.4);

end

% Calculates how far and how close the car can be from the right wall.
function [low, high] = CalculateTolerance(distanceThreshold)
    low = distanceThreshold * 0.6;
    high = distanceThreshold * 1.4;
end

% Returns true if distance is in tolerance.  low <= distance <= high
function IsInToleranceRet = CalculateIfInTolerance(distance, distanceThreshold)
    [low, high] = CalculateTolerance(distanceThreshold);

    IsInToleranceRet = low <= distance && distance <= high;
end

function TurnLeft(brick)
    disp('turning left');
    brick.MoveMotor('A', 25);
    brick.MoveMotor('B', -25);
    pause(1.2);
    Stop(brick);
end

function TurnRight(brick)
    disp('turning right');
    brick.MoveMotor('A', -25);
    brick.MoveMotor('B', 25);
    pause(1.2);
    Stop(brick);
end

function GoForward(brick)
    brick.MoveMotor('A', -50);
    brick.MoveMotor('B', -55);
end

function GoBack(brick)
    brick.MoveMotor('A',  50);
    brick.MoveMotor('B',  55);
end

function Stop(brick)
    brick.MoveMotor('ABC', 0);
end

function MakeSound(brick)
    brick.playTone(30, 440, 700);
end

% Checks if we are under a color. If we are, then we stop and beep accordingly.
function StopForColorsAndBeep(brick, color, firstColorDetected)

    % To not beep for the starting color. 
    if (firstColorDetected == color)
        return
    end
    
    switch color
        case 2
            BlueFunctionality(brick);
    
        case 3
            GreenFunctionality(brick);
    
        case 5
            RedFunctionality(brick);
    
        otherwise
            return;
    end
end

% Stops and beeps once for red as outlined in the assignment.
function RedFunctionality(brick)
    disp('red color functionality stop');
    Stop(brick) % stop for one second
    
    disp('red color beep');
    MakeSound(brick); % make one beep
    pause(1);
    
    disp('red color functionality move forward');
    GoForward(brick); % keep moving
    pause(1);
end

% Stops and beeps two times for blue as outlined in the assignment.
function BlueFunctionality(brick)
    disp('blue color functionality stop');
    Stop(brick); % stop for one second
    pause(1);
    
    % make two beeps
    disp('blue color beep 1');
    MakeSound(brick);
    pause(1);
    
    disp('blue color beep 2');
    MakeSound(brick);
    pause(1);
    
    % idk if we need to have another line here to make the car go
    % forward. will need to test this.
end

% Stops and beeps three times for green as outlined in the assignment.
function GreenFunctionality(brick)
    disp('green color functionality stop');
    Stop(brick);
    pause(1);
    
    % make three beeps
    disp('green color beep 1');
    MakeSound(brick);
    pause(1);
    
    disp('green color beep 2');
    MakeSound(brick);
    pause(1);
    
    disp('green color beep 3');
    MakeSound(brick);
    pause(1);
    
    % idk if we need to have another line here to make the car go
    % forward. will need to test this.
end

% A custom implementation of the InitKeyboard function from the EV3
% Toolbox. It makes it easier to see what the controls are for the car.
function textbox = InitKeyboardCustom
    global key
    global h
    key = 0;

    text = GetTextboxText();

    h = figure;
    set(h, 'KeyPressFcn', @(h_obj, evt) updateKey(evt.Key));
    set(h, 'KeyReleaseFcn', @(h_obj, evt) clearKey());
    textbox = annotation(h, 'textbox',[0,0,1,1]);

    set(textbox,'String', text, 'FontSize', 14);
end

function text = GetTextboxText()
    text(1) = {'Q - Quit program (hold for atleast 20 seconds if not working)'};

    text(3) = {'P - Resume auto mode'};

    text(5) = {'W - Open grabber'};
    text(6) = {'S - Close grabber'};

    text(8) = {'Up Arrow - Move Forward'};
    text(9) = {'Right Arrow - Turn Right'};
    text(10) = {'Left Arrow - Turn Left'};
    text(11) = {'Down Arrow - Move Backward'};
end

function UpdateTextBox(textbox, key)
    text = GetTextboxText();
    text(13) = {"Key pressed: "};
    text(14) = {key};
    set(textbox, 'String', text); % shows us what key we are pressing.
end

% Turns the car around, opens the grabber and beeps to signify that the
% trip is complete.
function AtDropOffPointWork(brick)
    TurnRight(brick);
    TurnRight(brick);
    pause(1);

    brick.MoveMotor('C', 40);
    pause(2);
    brick.MoveMotor('C', 0);

    brick.beep(1, 200);
    disp('Done.');
end

% Checks if we can turn right. If we cant, we turn left.
function CheckLeftAndRight(brick, distance, distanceThreshold, distanceOffset)
    if (distance >= distanceThreshold + distanceOffset)
        % turn left
        TurnLeft(brick);
        pause(1);
        GoForward(brick);
        pause(3);
    
    else

        % turn right
        TurnRight(brick);
        pause(1);
        GoForward(brick);
        pause(3);
    end
end
