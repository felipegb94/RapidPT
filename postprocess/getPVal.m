function [ pVal ] = getPVal(tStat, NullDist)
%getPval 
%   tStat: Calculated test statistic
%               * vx1 , v is the number of test statistics to check
%   NullDist: Null distribution of the test statistic.
%               * vxp, v is the number of distributions
%                      p is the number of data points in distribution
%   pVal: Associated pVal for the test statistic
  
    [v,p] = size(NullDist);
    assert(v == size(tStat,1),'Error: Number of rows in tStat and NullDist should be the same');
    pVal = zeros(v,1);
    for i = 1:v
       currNull = NullDist(i,:);
       pVal(i) = size(find(tStat(i) >= currNull),2)/p;
    end
    pVal = 1 - pVal;
end

