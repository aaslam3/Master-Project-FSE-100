% brick = ConnectBrick('Senchariot');
global key;

InitKeyboard();
while 1
    pause(0.1);
    switch key
        case 'q'
            brick.MoveMotor('ABD', 0);
    end

    % Read distance from ultrasonic sensor
    distance = brick.UltrasonicDist(1); % Assuming port 2 is where the ultrasonlic sensor is connected
    display(distance); % Display distance

    % Check if the car is too close to a wall (threshold set to 20 cm)
    if distance < 20
        disp('Wall detected! Turning right...');

        brick.MoveMotor('AB', 0); % Stop the car
        pause(0.5); % Pause briefly before turning

        brick.MoveMotor('B', 300); % Turn right by moving only the right motor (adjust duration as needed)
        pause(0.5); % Adjust time to control how much it turns
    else
        % Move forward if no wall is detected
        brick.MoveMotor('AB', 300); % Move forward
    end
end
