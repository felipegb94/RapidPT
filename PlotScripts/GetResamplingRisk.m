function [ resamplingRisk, tThresh1, tThresh2, sigVoxelIndeces1, sigVoxelIndeces2, commonSigVoxelIndeces ] = GetResamplingRisk(maxT1, maxT2, pVal, tstat)
%GetResamplingRisk Summary of this function goes here
%   maxT1: tx1 vector of a probability distribution 1
%   maxT2: 1xt vector of a probability distribution 1
%   pVal: p-value in percent, i.e p-value of 0.05 is 5%
%   tstat: 1xV vector of test statistic to threshold

    if(size(maxT1,1) == 1)
        maxT1 = maxT1';
    end
    if(size(maxT2,1) == 1)
        maxT2 = maxT2';
    end
    
    tThresh1 = prctile(maxT1, 100 - pVal);
    tThresh2 = prctile(maxT2, 100 - pVal);

    sigVoxelIndeces1 = find(tstat > tThresh1);
    sigVoxelIndeces2 = find(tstat > tThresh2);
    
    commonSigVoxelIndeces = intersect(sigVoxelIndeces1, sigVoxelIndeces2);
    
    numSigVoxels1 = size(sigVoxelIndeces1,2);
    numSigVoxels2 = size(sigVoxelIndeces2,2);
    numCommonSigVoxels = size(commonSigVoxelIndeces,2);
    
    resamplingRisk_term1 = 0;
    resamplingRisk_term2 = 0;
    if((numSigVoxels1 > 0))
        resamplingRisk_term1 = (numSigVoxels1 - numCommonSigVoxels)/numSigVoxels1;
    end
    if((numSigVoxels2 > 0))
        resamplingRisk_term2 = (numSigVoxels2 - numCommonSigVoxels)/numSigVoxels2;
    end
    
    resamplingRisk = 100 * (resamplingRisk_term1 + resamplingRisk_term2)/2;

    
end

