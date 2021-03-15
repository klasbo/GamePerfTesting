function [ v ] = limit( range, limits )
    v = min(max(range, limits(1)), limits(2));
end