function [ v, p ] = rescale( range, limits, inputRange )
% Linearly transform a range of numbers to fit a new range
%
% range: 
%   Row vector of numbers, or matrix where each row will be individually rescaled
% limits: 
%   Vector of [lower, upper] limits for the output
% inputRange (optinal, default=minmax(vec)): 
%   Custom vector of [lower, upper] bounds for the input
%
% v: 
%   The transformed vector
% p:
%   The [scaling, translation] coefficients used
%
% Examples:
%   rescale([1, 2, 3], [4,7])
%       >> 4.0  5.5  7.0
%   rescale([1, 2, 4], [4,1])
%       >> 4 3 1
%   rescale([1, 2, 3], [0,1], [1,5])
%       >> 0   0.25  0.5

    if nargin < 3  ||  isempty(inputRange)
        inputRange = minmax(range);
    end
    
    a = (limits(2)-limits(1))./(inputRange(:,2)-inputRange(:,1));
    b = inputRange(:,1).*a - limits(1);
    
    v = a.*range - b;
    p = [a, b];
    
end

