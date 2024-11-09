function [dropOffPointReached, blueCountRet] = blueColorFunctionality(brick, color, blueCount)
    switch color
        case 2
            dropOffPointReached = true;
            disp('Drop off point reached. Moving to manual control');
    
            brick.MoveMotor('AB', 0);
            blueCountRet = blueCount + 1;
            pause(1);
    
    
            makeSound(brick);
            pause(1);
    
    
            makeSound(brick);
    
            pause(1);
            brick.MoveMotor('A', 100); % turn around 180 degrees
            brick.MoveMotor('B', -100);
    
            pause(1);
            brick.MoveMotor('AB', 0); % and stop
    end
end

function [dropOffPointReached, redLineCountRet] = redColorFunctionality(brick, color, redLineCount)
    switch color
        case 5
            dropOffPointReached = true;
            disp('Drop off point reached. Moving to manual control');

            redLineCountRet = redLineCount + 1;
            makeSound(brick);


            brick.MoveMotor('AB', 0); % stop for one second
            pause(1);


            brick.MoveMotor('AB', -100); % keep moving
            pause(1);
    end
end

function [dropOffPointReached, greenCountRet] = greenColorFunctionality(brick, color, greenCount)
    switch color
        case 3
            dropOffPointReached = true;
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
    end
end
