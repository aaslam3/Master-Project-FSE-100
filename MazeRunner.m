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
redLineCount = 0;
blueCount = 0;
greenCount = 0;
reachedDropOffPoint = false;

while 1
    pause(0.05);
    brick.SetColorMode(1,2);
    
    distance = brick.UltrasonicDist(2);
    %fprintf('Distance : %f\n', distance);

    color = brick.ColorCode(1);
    %fprintf('Color : %f\n', color);

    switch key
        case 0
            brick.MoveMotor('AB', -100);
            disp(color);

            if color == 5 % red
                reachedDropOffPoint = true;
                disp('Manual control entered');
                 redLineCount = redLineCount + 1;
                 brick.playTone(100, 440, 700);
            end

            if color == 5 % red
                reachedDropOffPoint = true;
                disp('Manual control entered');
                 % brick.MoveMotor('AB', 0);
                 pause(1);
            end

            if color == 5 % red
                reachedDropOffPoint = true;
                disp('Manual control entered');
                 % brick.MoveMotor('AB', -100);
                 pause(1);
            end

            if color == 2 % blue
                reachedDropOffPoint = true;
                disp('Manual control entered');
                
                % brick.MoveMotor('AB', 0);
                blueCount = blueCount + 1;
                pause(1);
            end

            if color == 2 % blue
                reachedDropOffPoint = true;
                disp('Manual control entered');

                % brick.playTone(100, 440, 700);
                pause(1);
            end

            if color == 2 % blue
                reachedDropOffPoint = true;
                disp('Manual control entered');

                %brick.playTone(100, 440, 700);

                pause(1);
                % brick.MoveMotor('A', 100);
                % brick.MoveMotor('B', -100);

                pause(1);
                % brick.MoveMotor('AB', 0);
            end

            if color == 3 % green
                reachedDropOffPoint = true;
                disp('Manual control entered');
                % brick.MoveMotor('AB', 0);
                greenCount = greenCount + 1;
                pause(1);
            end

            if color == 3 % green
                reachedDropOffPoint = true;
                disp('Manual control entered');
                brick.playTone(100, 440, 700);
                pause(1);
            end

            if color == 3 % green
                reachedDropOffPoint = true;
                disp('Manual control entered');
                brick.playTone(100, 440, 700);
                pause(1);
            end

            if color == 3 % green
                reachedDropOffPoint = true;
                disp('Manual control entered');
                brick.playTone(100, 440, 700);
                pause(1);
            end

            switch color % should be changed for whatever color we resume manual control
                case 2 % blue
                case 3 % green
                case 4 % yellow
                case 5 % red
                    reachedDropOffPoint = true;
                    disp('Manual control entered');
            end

            if (reachedDropOffPoint == true) % switch to manual control
                switch key
                    case 's' % close grabber
                        brick.MoveMotor('C', -50);
            
                    case 'w' % open grabber
                        brick.MoveMotor('C', 50);

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

            if (reachedDropOffPoint == false)
                if distance < 15
                    disp('Auto moving');
                    if reachedDropOffPoint == true
                        continue;
                    end

                    if redLineCount > 3
                        brick.MoveMotor('A', -50);
                        brick.MoveMotor('B', 50);
                        pause(0.4);
    
                    else
                        brick.MoveMotor('A', 50);
                        brick.MoveMotor('B', -50);
                        pause(0.4);
                    end
                end
            end

            
        case 'q'
            brick.MoveMotor('AB', 0);
            CloseKeyboard();
            break;
              
    end

    % fprintf('Red color counter : %f\n', redLineCount);
    % fprintf('Blue color counter : %f\n', blueCount);
    % fprintf('Green color counter : %f\n', greenCount);
    
end
