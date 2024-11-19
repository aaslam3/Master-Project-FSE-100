% This is an enum that contains values for all the turns possible.
% This makes things easier than using strings and safer because if we
% misspell something, we'll know as soon as we run. if we use strings, we
% wont know until we figure out we mispelled which could take DAYS.

classdef WaysToTurn
    enumeration
        Any, 
        Left, 
        Right, 
        None
    end
end