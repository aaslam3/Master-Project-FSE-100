function turnRight(brick)
    disp('turning right');
    brick.MoveMotor('A', -28);
    pause(2.35);
    brick.MoveMotor('AB', 0);
end

turnRight(brick);




% disp('starting...');
% brick.MoveMotorAngleRel('A', -50, 450);
% disp('moving');
% brick.WaitForMotor('AB');
% disp('waiting...');
% brick.MoveMotor('A', 0);
% disp('stopped');




















% 
% 
% function turnRight(brick)
%     disp('turning right');
%     brick.MoveMotor('A', -26);
%     pause(2.4);
%     brick.MoveMotor('AB', 0);
% end
% 
% turnRight(brick);