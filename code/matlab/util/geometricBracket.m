function bkts = geometricBracket(base, ratio, spread, rounding)
    % base:     Base value from which resultant values are bracketed
    % ratio:    [divisions, x-ade], the ratio of a higher value ofer a lower one
    %           eg: [5, 2] - 5 increments to double the value (5 per octave)
    %           (going up 'divisions' increments will 'x-ade' the value)
    % spread:   an integer-vector of bracketing around the base value
    %           eg [-2 -1 0 1 2] for a 5-bkt around the base valuemouse
    
    bkts = base * ratio(2).^(spread/ratio(1));
    if nargin < 4 || rounding
        bkts = round(bkts, 0);
    end
    
end