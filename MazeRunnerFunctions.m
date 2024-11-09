classdef MazeRunnerFunctions
    methods(Static)
        function makeSound(brick)
            brick.playTone(100, 440, 700);
        end


        function dropOffPointReachedReturn = manualControl(brick)
            disp('In Manual control');

            switch key
                case 'p' % resume auto mode
                    dropOffPointReachedReturn = false;
                    disp('Drop off point reached false');

                case 'w' % open grabber
                    brick.MoveMotor('C', 50);

                case 's' % close grabber
                    brick.MoveMotor('C', -50);


                case 'leftarrow'
                    brick.MoveMotor('A', 100);
                    brick.MoveMotor('B', -100);

                case 'rightarrow'
                    brick.MoveMotor('A', -100);
                    brick.MoveMotor('B', 100);

                case 'uparrow'
                    brick.MoveMotor('A', -100);
                    brick.MoveMotor('B', -100);

                case 'downarrow'
                    brick.MoveMotor('A', 100);
                    brick.MoveMotor('B', 100);
            end
        end

        function [dropOffPointReachedReturn, blueCountRet, greenCountRet, redLineCountRet] = autoControl(brick, distance, blueCount, greenCount, redLineCount)
            brick.MoveMotor('AB', -100);
            disp('In Auto control');

            switch color % should be changed for whatever color we resume manual control
                case 2 % blue
                    dropOffPointReachedReturn = true;
                    disp('Drop off point reached. Moving to manual control');
                    brick.MoveMotor('AB', 0);
                    return;

                case 3 % green
                    dropOffPointReachedReturn = true;
                    disp('Drop off point reached. Moving to manual control');

                    brick.MoveMotor('AB', 0);
                    greenCountRet = greenCount + 1;
                    pause(1);


                    makeSound(brick);
                    pause(1);
                    makeSound(brick);
                    pause(1);
                    makeSound(brick);
                    pause(1);

                case 5 % red
                    dropOffPointReachedReturn = true;
                    disp('Drop off point reached. Moving to manual control');

                    redLineCountRet = redLineCount + 1;
                    makeSound(brick);

                    brick.MoveMotor('AB', 0); % stop for one second
                    pause(1);
                    brick.MoveMotor('AB', -100); % keep moving
                    pause(1);
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

        end
    end
end