function [pVals] = getPVals(tStat, NullDist)
%getPval 
%   tStat: Calculated test statistic
%               * 1xt , t is the number of test statistics to check
%   NullDist: Null distribution of the test statistic.
%               * vxp, v is the number of distributions
%                      p is the number of data points in distribution
%   pVal: vxt matrix with the pVals for the test statistics for each
%   distribution
  
    [v,p] = size(NullDist);
    [t] = size(tStat,2);
    %assert(v == size(tStat,1),'Error: Number of rows in tStat and NullDist should be the same');
    pVals = zeros(v,t);
    indeces = zeros(v,t);
    for i = 1:v
       currNull = NullDist(i,:);
       for j = 1:t
           pVals(i,j) = size(find(tStat(j) >= currNull),2)/p;
       end
    end
    pVals = 1 - pVals;
end

