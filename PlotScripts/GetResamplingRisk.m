function [ resamplingRisk ] = GetResamplingRisk(sigVoxelIndeces1, sigVoxelIndeces2)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

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

