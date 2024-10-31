

global key;
InitKeyboard();
redLineCount = 0;
blueCount = 0;
greenCount = 0;

while 1
    pause(0.05);
    
    distance = brick.UltrasonicDist(2);
    fprintf('Distance : %f\n', distance);

    color = brick.ColorCode(1);
    fprintf('Color : %f\n', color);

    switch key
        case 0
            brick.MoveMotor('AB', -100);

            if color == 5
                 redLineCount = redLineCount + 1;
                 %brick.playTone(100, 440, 700);
            end

            if color == 5
                 brick.MoveMotor('AB', 0);
                 pause(1);
            end

            if color == 2 % blue
                brick.MoveMotor('AB', 0);
                blueCount = blueCount + 1;
                pause(1);
            end

            if color == 2 % blue
                brick.playTone(100, 440, 700);
                pause(1);
            end

            if color == 2 % blue
                brick.playTone(100, 440, 700);
                pause(1);
            end

            if color == 3 % green
                brick.MoveMotor('AB', 0);
                greenCount = greenCount + 1;
                pause(1);
            end

            if color == 3 % green
                brick.playTone(100, 440, 700);
                pause(1);
            end

            if color == 3 % green
                brick.playTone(100, 440, 700);
                pause(1);
            end


            if distance < 15
                if redLineCount > 3
                    brick.MoveMotor('A', -50);
                    brick.MoveMotor('B', 50);
                    pause(0.5);

                else
                    brick.MoveMotor('A', 50);
                    brick.MoveMotor('B', -50);
                    pause(0.5);
                end

            end

        case 'q'
            brick.MoveMotor('AB', 0);
            CloseKeyboard();
            break;
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

    fprintf('Red color counter : %f\n', redLineCount);
    fprintf('Blue color counter : %f\n', blueCount);
    fprintf('Green color counter : %f\n', greenCount);
    
end
