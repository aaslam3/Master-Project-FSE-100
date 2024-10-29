global key;
InitKeyboard();

while 1
    pause(0.5);

    distance = brick.UltrasonicDist(2);
    disp(distance);

    color = brick.ColorCode(1);
    disp(color);

    switch key
        case 0
            brick.MoveMotor('AB', 0);

            


        case 'q'
            brick.MoveMotor('AB', 0);
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
end
