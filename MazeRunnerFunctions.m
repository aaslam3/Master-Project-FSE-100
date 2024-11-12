classdef MazeRunnerFunctions
    methods(Static)
        
        function makeSound(brick)
            brick.playTone(100, 440, 700);
        end


        function dropOffPointReachedReturn = manualControl(brick, key)
            disp('In Manual control');
            dropOffPointReachedReturn = true;

            switch key
                case 'p' % resume auto mode
                    dropOffPointReachedReturn = false;
                    disp('Drop off point reached false');

                case 'w' % open grabber
                    brick.MoveMotor('C', 50);
                    disp('opening grabber');

                case 's' % close grabber
                    brick.MoveMotor('C', -50);
                    disp('closing grabber');


                case 'leftarrow'
                    brick.MoveMotor('A', 100);
                    brick.MoveMotor('B', -100);
                    disp('move left');

                case 'rightarrow'
                    brick.MoveMotor('A', -100);
                    brick.MoveMotor('B', 100);
                    disp('move right');

                case 'uparrow'
                    brick.MoveMotor('A', -100);
                    brick.MoveMotor('B', -100);
                    disp('move up');

                case 'downarrow'
                    brick.MoveMotor('A', 100);
                    brick.MoveMotor('B', 100);
                    disp('move down');

                case 0
                    brick.MoveMotor('ABC', 0);
            end
        end

        function [dropOffPointReachedReturn, blueCountRet, greenCountRet, redLineCountRet] = autoControl(brick, distance, blueCount, greenCount, redLineCount, color)
            brick.MoveMotor('AB', -100);
            disp('In Auto control');

            dropOffPointReachedReturn = false;
            blueCountRet = 0;
            greenCountRet = 0;
            redLineCountRet = 0;

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


                    MazeRunnerFunctions.makeSound(brick);
                    pause(1);
                    MazeRunnerFunctions.makeSound(brick);
                    pause(1);
                    MazeRunnerFunctions.makeSound(brick);
                    pause(1);
                    

                case 5 % red
                    dropOffPointReachedReturn = true;
                    disp('Drop off point reached. Moving to manual control');

                    redLineCountRet = redLineCount + 1;
                    MazeRunnerFunctions.makeSound(brick);

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