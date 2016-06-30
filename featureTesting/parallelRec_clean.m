function [ outputs, timings ] = parallelRec_clean(data, dataSquared, permutationMatrix1, permutationMatrix2, nGroup1, nGroup2, UHat,muFit, numPermutations,subV,opts2)
    fprintf('\n Recovering the subspace coefficients and residuals for all permutations \n');
    [N,V] = size(data);
    

    tRecovery = tic;    
    
    MaxTStats = zeros(numPermutations,1);
    % Calculate small portion of the permutation matrix
    
    for i = 1:numPermutations
        inds = randperm(V,subV)'; 
        [TCurrent] = TwoSamplePermTest(data(:,inds),...
                                       dataSquared(:,inds),...
                                       permutationMatrix1(i,:),...
                                       permutationMatrix2(i,:),...
                                       nGroup1,...
                                       nGroup2);
        U_inds = UHat(inds,:);
        [s, w, ~] = admm_srp(U_inds, TCurrent', opts2);
        TRec = UHat*w;
        TRec(inds) = TRec(inds) + s;
        MaxTStats(i) = max(TRec) + muFit;
        fprintf('Completion done on trial %d/%d \n',i,numPermutations);  
    end

    % Save timings
    timings.tRecovery = toc(tRecovery);
    outputs.MaxT = MaxTStats;
end

function [tStatMatrix] = TwoSamplePermTest(data, dataSquared, permutationMatrix1, permutationMatrix2, nGroup1, nGroup2)
    
    g1Mean = (permutationMatrix1 * data)/nGroup1;
    g2Mean = (permutationMatrix2 * data)/nGroup2;
    g1Var = (permutationMatrix1 * dataSquared)/(nGroup1) - (g1Mean.*g1Mean);
    g2Var = (permutationMatrix2 * dataSquared)/(nGroup2) - (g2Mean.*g2Mean);
    tStatMatrix = (g1Mean - g2Mean) ./ (sqrt((g1Var./(nGroup1-1)) + (g2Var./(nGroup2-1))));

end

