function [ tThresh ] = getTThreshold( NullDist, alpha )
%getTThreshold 
%   NullDist: Null Distribution of some test statistic
%   alpha: Value between 0-1. This is the significance level.
%   tThresh: 
   
    tThresh = prctile(NullDist, 100 - (100*alpha));
end

