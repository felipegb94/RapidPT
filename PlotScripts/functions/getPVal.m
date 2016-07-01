function [ pVal ] = getPVal(Distribution, alpha)
%getPVal Summary of this function goes here
%   Detailed explanation goes here

    pVal = prctile(Distribution, 100 - alpha);

end

