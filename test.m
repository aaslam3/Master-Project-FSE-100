
global key;
distance = 0;
color = 0;


while true
    disp('0. Quit');
    disp('1. Distance');
    disp('2. Color');

    userChoice = input('Enter a number: ');

    switch userChoice
        case 0
            break;

        case 1
            disp('Distance test chosen.');

            while true
                % distance = brick.UltrasonicDist(2);
                fprintf('Distance: %.f\n', distance);

                pause(0.1);
            end

        case 2
            disp('Color test chosen.');

            while true
                % color = brick.ColorCode(1);
                fprintf('Color : %.f\n', color);
                set(textbox, 'String', key);

                pause(0.1);
            end

        otherwise

    end

    disp('Reprompting user...');
    % because the user entered a wrong number

    pause(0.1);
end
