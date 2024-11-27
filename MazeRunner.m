%#ok<*GVMIS> % suppresses global variable warnings

global key;

% this is the handle for the Figure n window that opens up when we run
% InitKeyboard(). (n being the number of figure).
textbox = InitKeyboardCustom();

brick.SetColorMode(1, 2);


% if distance is less than this value, then we decide to move left or right
% in the autoControl function. leave it at 15 unless experimenting.
distanceThreshold = 20;


% if there isnt a wall distanceThreshold + distanceOffset cm away, 
% we know that that turn is also navigable. the offset is here to 
% resolve the case where it detects a wall but its less than our
% threshold which needs the car to be very close to the wall.
% essentially im extending the threshold.
distanceOffset = 15;

bManualControlPointReached = false;


% this is the starting color
firstColorDetected = 3; % green

% should be changed for what is given by the prof. 
% this is the color where we switch to manual control
manualControlPoint = 4; % yellow. 

% should be changed for what is given by the prof. 
% this is the color we have to reach after turning off manual control
targetDropOffColor = 2; % blue

% this is a flag to check if we passed pick up point and picked up
% passenger. useful for if we reach the drop off point without picking up
% passenger.
passengerPickedUp = false;

% 0 == unknown color
% 1 == black
% 2 == blue
% 3 == green
% 4 == yellow
% 5 == red
% 6 == white
% 7 == brown

while true
    % pause(0.01);
    pause(0.05);
    GoForward(brick);
    
    switch key
        case 'q'
            brick.MoveMotor('ABC', 0);
            CloseKeyboard();
            break;
    end

    distance = brick.UltrasonicDist(2);
    % fprintf('Distance : %.2f\n', distance);

    touch = brick.TouchPressed(3);
    % fprintf('Touched wall : %d\n', touch);

    color = brick.ColorCode(1);
    % fprintf('Color : %.f\n', color);


    if (bManualControlPointReached)

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
                    brick.MoveMotor('C', 50);
                    disp('opening grabber');

                case 's' % close grabber
                    brick.MoveMotor('C', -50);
                    disp('closing grabber');


                case 'leftarrow'
                    brick.MoveMotor('A', 5);
                    brick.MoveMotor('B', -5);
                    
                    disp('move left');

                case 'rightarrow'
                    brick.MoveMotor('A', -5);
                    brick.MoveMotor('B', 5);
                    
                    disp('move right');

                case 'uparrow'
                    brick.MoveMotor('A', -10);
                    brick.MoveMotor('B', -10);
                    
                    disp('move up');

                case 'downarrow'
                    brick.MoveMotor('A', 10);
                    brick.MoveMotor('B', 10);
                    
                    disp('move down');

                case 0
                    brick.MoveMotor('ABC', 0);
            end

    else % auto control
        if (color == targetDropOffColor && passengerPickedUp == true)
            disp('!!! AT DROPOFF POINT WITH PASSENGER !!!    Setting passenger down and exiting program...');
            pause(1);
            brick.MoveMotor('ABC', 0);

            AtDropOffPointWork(brick);

            disp('Exiting...')
            return;
        end

        StopForColorsAndBeep(brick, color, firstColorDetected);

        % if at manual control point, set variable to true and return function
        if (color == manualControlPoint)
            bManualControlPointReached = ManualControlPointReached(brick);

            % beeps five times (or maybe 6 not sure)
            for i = 1 : 5
                fprintf('beep %d', i + 1);
                brick.beep(5, 200);
                pause(0.6);
            end
           
            continue;
        end
        
        if touch == true
            % if touched a wall, go back a little bit and stop
            GoBack(brick);
            pause(1);
            brick.MoveMotor('AB', 0);
        
            % check if we can turn right first. if distance is less than
            % threshold, then we turn left.
        
            if (distance >= distanceThreshold + distanceOffset)
                % turn right
                TurnRight(brick);
                pause(2);
                GoForward(brick);
                
            else
                % turn left
                turnLeft(brick);
                pause(2);
                GoForward(brick);
            end
            continue;
        end
        
        % default turning right behavior.
        % turns right when there is no wall there.
        if (distance >= distanceThreshold + distanceOffset)
            RightTurnCanBeTaken(brick);
            continue;
        end
        
        % if not in tolerance
        FixDistanceToWall(distance, distanceThreshold)
    end


end % while loop end

function RightTurnCanBeTaken(brick)

    disp('right open detected');
    pause(1); 
    % this pause lets the car go a little bit forward before 
    % turning to make sure it doesnt get stuck at the wall

    disp('turning right');
    TurnRight(brick);

end

function FixDistanceToWall(distance, distanceThreshold)

    isInToleranceTemp = CalculateIfInTolerance(distance, distanceThreshold);

    if (isInToleranceTemp == false)
        disp('is not in tolerance');

        low = distanceThreshold * 0.8;
        high = distanceThreshold * 1.2;

        fprintf('low: %.2f\n', low);
        fprintf('high: %.2f\n', high);

        if (distance <= low)
            % if too close to wall, turn slightly left.
            disp('too close to wall');
            brick.MoveMotor('A', -5);

        elseif (distance >= high)
            % if too far from wall, turn slightly right.
            disp('too far from wall');
            brick.MoveMotor('B', -5);
            
        end

        pause(0.1);
        GoForward(brick);
    end

end

function IsInToleranceRet = CalculateIfInTolerance(distance, distanceThreshold)
    low = distanceThreshold * 0.9;
    high = distanceThreshold * 1.1;

    % if distance is in tolerance. true if it is: 
    % low <= distance <= high
    IsInToleranceRet = distance >= low && distance <= high;
end

function TurnRight(brick)
    disp('turning right');
    brick.MoveMotor('A', -25);
    brick.MoveMotor('B', 25);
    pause(1.2);
    brick.MoveMotor('AB', 0);
end

function GoForward(brick)
    brick.MoveMotor('A', -50);
    brick.MoveMotor('B', -54);
end

function GoBack(brick)
    brick.MoveMotor('A', 50);
    brick.MoveMotor('B', 54);
end

function MakeSound(brick)
    brick.playTone(100, 440, 700);
end

function [ManualControlPointReached] = ManualControlPointReached(brick)
    ManualControlPointReached = true;
    disp('Drop off point reached. Moving to manual control');
    brick.MoveMotor('AB', 0);
end

function RedFunctionality(brick)
    disp('red color functionality stop');
    brick.MoveMotor('AB', 0); % stop for one second
    
    disp('red color beep');
    MakeSound(brick); % make one beep
    pause(1);
    
    disp('red color functionality move forward');
    GoForward(brick); % keep moving
    pause(1);
end

function StopForColorsAndBeep(brick, color, firstColorDetected)          
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

function BlueFunctionality(brick)
    disp('blue color functionality stop');
    brick.MoveMotor('AB', 0); % stop for one second
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

function GreenFunctionality(brick)
    disp('green color functionality stop');
    brick.MoveMotor('AB', 0);
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

    text(3) = {'Y - Toggle fine control'};
    text(4) = {'P - Resume auto mode'};

    text(6) = {'W - Open grabber'};
    text(7) = {'S - Close grabber'};

    text(9) = {'Up Arrow - Move Forward'};
    text(10) = {'Right Arrow - Turn Right'};
    text(11) = {'Left Arrow - Turn Left'};
    text(12) = {'Down Arrow - Move Backward'};
end

function UpdateTextBox(textbox, key)
    text = GetTextboxText();
    text(14) = {"Key pressed: "};
    text(15) = {key};
    set(textbox, 'String', text); % shows us what key we are pressing.
end

function AtDropOffPointWork(brick)
    TurnRight(brick);
    TurnRight(brick);
    pause(1);

    brick.MoveMotor('C', 50);
    pause(2);
    brick.MoveMotor('C', 0);

    brick.beep(5, 200);
    disp('Done.');
end