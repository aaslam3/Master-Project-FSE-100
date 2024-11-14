

classdef MazeRunnerFunctions
    methods(Static)

        function makeSound(brick)
            
            brick.playTone(100, 440, 700);
        end

        function turnRight(brick)
            disp('turning right');
            brick.MoveMotor('A', -25);
            brick.MoveMotor('B', 25);
            pause(1.7);
            brick.MoveMotor('AB', 0);
        end

        function turnLeft(brick)
            disp('turning left');
            brick.MoveMotor('A', 25);
            brick.MoveMotor('B', -25);
            pause(1.7);
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

        function [manualControlPointReached, passengerPickedUpReturn] = manualControl(brick, key, fineControl)
            
            disp('In Manual control');
            manualControlPointReached = true;
            passengerPickedUpReturn = false;

            switch key
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
                        brick.MoveMotor('A', 5);
                        brick.MoveMotor('B', -5);
                    else
                        brick.MoveMotor('A', 50);
                        brick.MoveMotor('B', -50);
                    end
                    
                    disp('move left');

                case 'rightarrow'
                    if (fineControl)
                        brick.MoveMotor('A', -5);
                        brick.MoveMotor('B', 5);
                    else
                        brick.MoveMotor('A', -50);
                        brick.MoveMotor('B', 50);
                    end
                    
                    disp('move right');

                case 'uparrow'
                    if (fineControl)
                        brick.MoveMotor('A', -10);
                        brick.MoveMotor('B', -10);
                    else
                        brick.MoveMotor('A', -100);
                        brick.MoveMotor('B', -100);
                    end
                    
                    disp('move up');

                case 'downarrow'
                    if (fineControl)
                        brick.MoveMotor('A', 10);
                        brick.MoveMotor('B', 10);
                    else
                        brick.MoveMotor('A', 100);
                        brick.MoveMotor('B', 100);
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
                disp('!!! AT DROPOFF POINT WITH PASSENGER !!!    Press q to quit program or move car manually.');
                pause(0.2);
                return;
            end


            brick.MoveMotor('AB', -100);
            % disp('In Auto control');


            % these are here to satisfy errors. do not change
            manualControlPointReachedReturn = false;
            whichWayToTurn = WaysToTurn.None;


            MazeRunnerFunctions.StopForColorsAndBeep(brick, color, firstColorDetected);


            if (color == manualControlPoint)
                % if at manual control point, set variable to true and return function
                manualControlPointReachedReturn = MazeRunnerFunctions.manualControlPointReached(brick);
                return;
            end


            if (color == targetDropOffColor && passengerPickedUp == false)
                disp('At dropoff point but no passenger. turning around.');

                MazeRunnerFunctions.turnAround(brick);
                brick.MoveMotor('AB', -100);
                pause(0.5); % this value may need tweaking as the car can still be on the drop off color or go too far.

                % get an updated value for color
                whichWayToTurn = MazeRunnerFunctions.CheckLeftAndRight(brick, distanceThreshold, distanceOffset);

                MazeRunnerFunctions.TurningFunctionality(brick, whichWayToTurn);

                return;
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
                        % NOTE: % in practice should never come here. if 
                        % it is coming here, then something is likely 
                        % wrong. either it didnt detect the walls correctly 
                        % or we need to increase our distanceOffset more.
                        fprintf('\nBoth ways available. \nTurning left just cuz i feel like it. \nyou cant tell me what to do\n\n');
                        pause(1);

                        % if we can turn any way, turn left. we need it to
                        % be left because it helps us is many cases.
                        MazeRunnerFunctions.turnLeft(brick);
                        brick.MoveMotor('AB', -100); % start moving forward



                    case WaysToTurn.Left
                        disp('Left turn available. Turning Left.');
                        MazeRunnerFunctions.turnLeft(brick);
                        brick.MoveMotor('AB', -100); % start moving forward


                    case WaysToTurn.Right
                        disp('Right turn available. Turning Right.');
                        MazeRunnerFunctions.turnRight(brick);
                        brick.MoveMotor('AB', -100); % start moving forward


                    case WaysToTurn.None
                        % do yall wanna do a 180 deg turn here? idk
                        % the only place this will happen is at blue but it
                        % will most likely be the drop off point.
                        disp('Dead end detected. Turning back.');
                        % MazeRunnerFunctions.turnLeft(brick);
                        MazeRunnerFunctions.turnAround(brick);
                        brick.MoveMotor('AB', -100); % start moving forward

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
                whichWayToTurn = WaysToTurn.Any; % in practice, should never occur

            else if (rightTurnAvailable == true && leftTurnAvailable == false)
                % if right is navigable but not left
                whichWayToTurn = WaysToTurn.Right;

            else if (rightTurnAvailable == false && leftTurnAvailable == true)
                % if left is navigable but not right
                whichWayToTurn = WaysToTurn.Left;

            else if (rightTurnAvailable == false && leftTurnAvailable == false)
                % if neither are navigable
                whichWayToTurn = WaysToTurn.None;

            end
            end
            end
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
            brick.MoveMotor('AB', 0); % stop for one second

            MazeRunnerFunctions.makeSound(brick); % make one beep
            pause(1);

            brick.MoveMotor('AB', -100); % keep moving
            pause(1);
        end

        function BlueFunctionality(brick)
            brick.MoveMotor('AB', 0);
            pause(1);


            MazeRunnerFunctions.makeSound(brick);
            pause(1);
            MazeRunnerFunctions.makeSound(brick);
            pause(1);
        end

        function GreenFunctionality(brick)
            brick.MoveMotor('AB', 0);
            pause(1);


            MazeRunnerFunctions.makeSound(brick);
            pause(1);
            MazeRunnerFunctions.makeSound(brick);
            pause(1);
            MazeRunnerFunctions.makeSound(brick);
            pause(1);
        end
    end
end
