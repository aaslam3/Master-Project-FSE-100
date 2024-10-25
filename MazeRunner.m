% brick = ConnectBrick('Senchariot');
global key;
global brick;
InitKeyboard();
redCount = 3;

%brick.SetColorMode(1, 2)
color = brick.ColorCode(1);
disp(color);

while 1
    pause(0.05);
    color = brick.UltrasonicDist(2);
    display(distance);

    distance = brick.ColorCode(1);
    %disp(color);

    if color == 5
        redCount = redCount+1;
        %pause(0.2);
    end

    switch key
        case 'q'
            brick.MoveMotor('AB', 0);
            break;
        case 0
            if distance < 20
                if redCount == 3
                    brick.MoveMotor('B', -18);
                    brick.MoveMotor('A', 18);
                    pause(0.5);
                    brick.MoveMotor('AB', 0);
                else
                    brick.MoveMotor('B', 18);
                    brick.MoveMotor('A', -18);
                    pause(0.5);
                    brick.MoveMotor('AB', 0);
                end
                disp("loop 1")
            else
                disp("moving forward")
                brick.MoveMotor('AB', -500);
                %pause(0.5);
            end

    end


end
brick.MoveMotor('AB',0);
