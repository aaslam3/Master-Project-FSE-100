

classdef MazeRunnerFunctions
    methods(Static)

        function goForward(brick)
            brick.MoveMotor('A', -50);
            brick.MoveMotor('B', -56);
        end

        function goBack(brick)
            brick.MoveMotor('A', 50);
            brick.MoveMotor('B', 56);
        end

        function updateTextBox(textbox, key)
            text = MazeRunnerFunctions.getText();
            text(14) = {"Key pressed: "};
            text(15) = {key};
            set(textbox, 'String', text); % shows us what key we are pressing.
        end

        function text = getText()
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

        function makeSound(brick)
            
            brick.playTone(100, 440, 700);
        end

        function turnRight(brick)
            disp('turning right');
            brick.MoveMotor('A', -25);
            brick.MoveMotor('B', 25);
            pause(1.3);
            brick.MoveMotor('AB', 0);
        end

        function turnLeft(brick)
            disp('turning left');
            brick.MoveMotor('B', -29);
            pause(2.5);
            brick.MoveMotor('AB', 0);
        end

        function turnAround(brick)
            
            brick.MoveMotor('AB', 0);

            pause(1);
            disp('turning around');
            MazeRunnerFunctions.turnLeft(brick);
            pause(3);
            MazeRunnerFunctions.turnLeft(brick);

            brick.MoveMotor('AB', 0); % and stop
            pause(1);
        end

        function StopForColorsAndBeep(brick, color, firstColorDetected)
            
            if (firstColorDetected == color)
                return
            end

            switch color
                case 2
                    MazeRunnerFunctions.BlueFunctionality(brick);

                case 3
                    MazeRunnerFunctions.GreenFunctionality(brick);

                case 5
                    MazeRunnerFunctions.RedFunctionality(brick);

                otherwise
                    return;
            end
        end

        function [manualControlPointReached, passengerPickedUpReturn] = manualControl(brick, textbox, key, fineControl)
            
            disp('In Manual control');
            manualControlPointReached = true;
            passengerPickedUpReturn = false;
            
            MazeRunnerFunctions.updateTextBox(textbox, key);

            switch key
                case 'y'
                    fineControl = ~fineControl;
                    fprintf('Fine control: %d', fineControl);
                    pause(2);
                    % toggles between true and false. it might take a few tries for
                    % us to actually keep it at what we want since our loop is so
                    % fast, it might trigger this multiple times. the pause might
                    % help with this. will have to try.

                case 'p' % resume auto mode
                    manualControlPointReached = false;
                    passengerPickedUpReturn = true;
                    disp('Drop off point reached false');

                case 'w' % open grabber
                    brick.MoveMotor('C', 50);
                    disp('opening grabber');

                case 's' % close grabber
                    brick.MoveMotor('C', -50);
                    disp('closing grabber');


                case 'leftarrow'
                    if (fineControl)
                        brick.MoveMotor('A', 15);
                        brick.MoveMotor('B', -15);
                    else
                        brick.MoveMotor('A', 30);
                        brick.MoveMotor('B', -30);
                    end
                    
                    disp('move left');

                case 'rightarrow'
                    if (fineControl)
                        brick.MoveMotor('A', -15);
                        brick.MoveMotor('B', 15);
                    else
                        brick.MoveMotor('A', -30);
                        brick.MoveMotor('B', 30);
                    end
                    
                    disp('move right');

                case 'uparrow'
                    if (fineControl)
                        brick.MoveMotor('A', -10);
                        brick.MoveMotor('B', -10);
                    else
                        brick.MoveMotor('A', -50);
                        brick.MoveMotor('B', -55);
                    end
                    
                    disp('move up');

                case 'downarrow'
                    if (fineControl)
                        brick.MoveMotor('A', 10);
                        brick.MoveMotor('B', 10);
                    else
                        brick.MoveMotor('A', 50);
                        brick.MoveMotor('B', 55);
                    end
                    
                    disp('move down');

                case 0
                    brick.MoveMotor('ABC', 0);
            end
        end

        % 0 == unknown color
        % 1 == black
        % 2 == blue
        % 3 == green
        % 4 == yellow
        % 5 == red
        % 6 == white
        % 7 == brown

        % when distance is less than 15, the car looks left and right to
        % see which way is open.

        function [manualControlPointReachedReturn] = autoControl(brick, distance, color, firstColorDetected, manualControlPoint, targetDropOffColor, distanceThreshold, distanceOffset, passengerPickedUp)
            
            if (color == targetDropOffColor && passengerPickedUp == true)
                disp('!!! AT DROPOFF POINT WITH PASSENGER !!!    Press q to quit program.');
                pause(0.2);
                return;
            end


            MazeRunnerFunctions.goForward(brick);
            % disp('In Auto control');


            % these are here to satisfy errors. do not change
            manualControlPointReachedReturn = false;
            whichWayToTurn = WaysToTurn.None;


            MazeRunnerFunctions.StopForColorsAndBeep(brick, color, firstColorDetected);

            if (color == 5)
                disp('red color detected. stopping car ');
                MazeRunnerFunctions.goForward(brick);
                pause(2);                 
                brick.MoveMotor('AB', 0);
                % after stopping at a red line, it should stop here, pause 
                % for a second and then check left and right and turn 
                % wherever.

                disp('checking left and right');
                whichWayToTurn = MazeRunnerFunctions.CheckLeftAndRight(brick, distanceThreshold, distanceOffset);
                pause(1);

                fprintf('turn available: %s\n', whichWayToTurn);
                MazeRunnerFunctions.TurningFunctionality(brick, whichWayToTurn);

                return;
            end


            if (color == manualControlPoint)
                % if at manual control point, set variable to true and return function
                manualControlPointReachedReturn = MazeRunnerFunctions.manualControlPointReached(brick);
                return;
            end

            % 0 == unknown color
            % 1 == black
            % 2 == blue
            % 3 == green
            % 4 == yellow
            % 5 == red
            % 6 == white
            % 7 == brown

            % if color and target drop off point is blue
            if (color == targetDropOffColor && targetDropOffColor == 2 && passengerPickedUp == false)

                disp('At dropoff point (blue) but no passenger. ');
                brick.beep(5, 500);

                brick.MoveMotor('AB', 0);
                pause(1);

                MazeRunnerFunctions.goBack(brick);
                pause(1); % this delay value needs to be tweaked

                brick.MoveMotor('AB', 0);
                MazeRunnerFunctions.turnRight(brick);
                pause(1); 

                MazeRunnerFunctions.goForward(brick);
                pause(2);  % this delay value needs to be tweaked

                if (manualControlPoint == 3) % if customer pickup point is green

                    disp('going left as the customer is on the left');
                    brick.MoveMotor('AB', 0);
                    MazeRunnerFunctions.turnLeft(brick);
                    pause(1);

                    MazeRunnerFunctions.goForward(brick);

                elseif (manualControlPoint == 4) % if customer pickup point is yellow

                    disp('going left as the customer is on the right');
                    brick.MoveMotor('AB', 0);
                    MazeRunnerFunctions.turnRight(brick);
                    pause(1);

                    MazeRunnerFunctions.goForward(brick);

                else
                    % a situation where neither green nor yellow is the
                    % customer pickup point. which would leave blue as the
                    % customer pickup point. this should never happen.
                    brick.MoveMotor('AB', 0);
                    for i = 1:50
                        disp('ENTERED IN A SITUATION WHICH SHOULD NEVER HAPPEN');
                        disp('CHECK YOUR STARTING VARIABLES');
                    end
                    
                end
            end

            
            % if we detect a wall in front of us, we turn both ways to see
            % where to go next.
            if (distance < distanceThreshold)
                disp('Wall detected. running left and right code.');
                whichWayToTurn = MazeRunnerFunctions.CheckLeftAndRight(brick, distanceThreshold, distanceOffset);

                MazeRunnerFunctions.TurningFunctionality(brick, whichWayToTurn);
            end
        end



        function TurningFunctionality(brick, whichWayToTurn)
            
            switch whichWayToTurn
                    case WaysToTurn.Any
                        fprintf(['\n\nBoth ways available. \n' ...
                            'Turning left just cuz i feel like it. \n' ...
                            'you cant tell me what to do\n\n']);
                        
                        pause(1);

                        % if we can turn any way, turn left. we need it to
                        % be left because it helps us is many cases.
                        MazeRunnerFunctions.turnLeft(brick);
                        MazeRunnerFunctions.goForward(brick);



                    case WaysToTurn.Left
                        disp('Left turn available. Turning Left.');
                        MazeRunnerFunctions.turnLeft(brick);
                        MazeRunnerFunctions.goForward(brick); % start moving forward


                    case WaysToTurn.Right
                        disp('Right turn available. Turning Right.');
                        MazeRunnerFunctions.turnRight(brick);
                        MazeRunnerFunctions.goForward(brick); % start moving forward


                    case WaysToTurn.None
                        % do yall wanna do a 180 deg turn here? idk
                        % the only place this will happen is at blue but it
                        % will most likely be the drop off point.
                        disp('Dead end detected. Turning back.');
                        % MazeRunnerFunctions.turnLeft(brick);
                        
                        MazeRunnerFunctions.turnAround(brick);
                        MazeRunnerFunctions.goForward(brick); % start moving forward

            end
        end



        % when distance is less than 15, the car looks left and right to
        % see which way is open.
        function [ whichWayToTurn ] = CheckLeftAndRight(brick, distanceThreshold, distanceOffset)
            
            leftTurnAvailable = false;
            rightTurnAvailable = false; % ik i need help naming variables, leave me alone
            tempDistance = 0;


            % turn brick left first to see if there is a wall there.
            disp('Turning Left. CheckLeftAndRight')
            MazeRunnerFunctions.turnLeft(brick);
            pause(3);

            
            tempDistance = brick.UltrasonicDist(2);
            fprintf('Left Distance : %.f\n', tempDistance);

            if (tempDistance > (distanceThreshold + distanceOffset))
                disp('left turn available. CheckLeftAndRight');
                leftTurnAvailable = true;
            end


            % turn brick around to see if there is a wall there.
            MazeRunnerFunctions.turnRight(brick);
            pause(1);
            MazeRunnerFunctions.turnRight(brick);
            pause(3);


            tempDistance = brick.UltrasonicDist(2);

            fprintf('Right Distance : %.f\n', tempDistance);

            if (tempDistance > (distanceThreshold + distanceOffset))
                disp('right turn available. CheckLeftAndRight');
                rightTurnAvailable = true;
            end



            if (rightTurnAvailable == true && leftTurnAvailable == true)
                % if both turns are navigable
                whichWayToTurn = WaysToTurn.Any;

            elseif (rightTurnAvailable == true && leftTurnAvailable == false)
                % if right is navigable but not left
                whichWayToTurn = WaysToTurn.Right;

            elseif (rightTurnAvailable == false && leftTurnAvailable == true)
                % if left is navigable but not right
                whichWayToTurn = WaysToTurn.Left;

            elseif (rightTurnAvailable == false && leftTurnAvailable == false)
                % if neither are navigable
                whichWayToTurn = WaysToTurn.None;

            end

            % turn left again to go back to where we were facing before
            % this function started.
            disp('resetting car to orignal position. CheckLeftAndRight');
            MazeRunnerFunctions.turnLeft(brick);
            pause(0.5);
        end


        function [manualControlPointReached] = manualControlPointReached(brick)
            manualControlPointReached = true;
            disp('Drop off point reached. Moving to manual control');
            brick.MoveMotor('AB', 0);
        end


        function RedFunctionality(brick)
            disp('red color functionality stop');
            brick.MoveMotor('AB', 0); % stop for one second

            disp('red color beep');
            MazeRunnerFunctions.makeSound(brick); % make one beep
            pause(1);

            disp('red color functionality move forward');
            MazeRunnerFunctions.goForward(brick); % keep moving
            pause(1);
        end

        function BlueFunctionality(brick)
            disp('blue color functionality stop');
            brick.MoveMotor('AB', 0); % stop for one second
            pause(1);

            % make two beeps
            disp('blue color beep 1');
            MazeRunnerFunctions.makeSound(brick);
            pause(1);

            disp('blue color beep 2');
            MazeRunnerFunctions.makeSound(brick);
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
            MazeRunnerFunctions.makeSound(brick);
            pause(1);

            disp('green color beep 2');
            MazeRunnerFunctions.makeSound(brick);
            pause(1);

            disp('green color beep 3');
            MazeRunnerFunctions.makeSound(brick);
            pause(1);

            % idk if we need to have another line here to make the car go
            % forward. will need to test this.
        end
    end
end