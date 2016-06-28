function [ outputs, timings ] = parallelRec(data, dataSquared, permutationMatrix1, permutationMatrix2, nGroup1, nGroup2, UHat, numPermutations)
    fprintf('\n Recovering the subspace coefficients and residuals for all permutations \n');
    tRecovery = tic;    
    
    MaxTStats = zeros(numPermutations,1);
    W = cell(numPermutations,1); 
    % Calculate small portion of the permutation matrix
    for i = 1:numPermutations
        r = randperm(V); 
        inds = r(1:subV)';
        [dummyMaxT, TCurrent] = TwoSamplePermTest(data(:,inds),...
                                                  dataSquared(:,inds),...
                                                  permutationMatrix1(i,:),...
                                                  permutationMatrix2(i,:),...
                                                  nGroup1,...
                                                  nGroup2);
        U_inds = UHat(inds,:);  
        [s, w, jnk] = admm_srp(U_inds, TCurrent', opts2);
        W{i,1} = w; 
        sAll = zeros(V,1); 
        sAll(inds) = sAll(inds) + s; 
        TRec = UHat*w + sAll + muFit;
        MaxTStats(i) = max(TRec);
        fprintf('Completion done on trial %d/%d (block %d) \n',i,numPermutations,ceil(i/subBatch));  
    end

    % Save timings
    timings.tRecovery = toc(tRecovery);
    
    outputs.MaxNull = gen_hist(MaxTStats,maxnullBins); 
    outputs.MaxT = MaxTStats;
end

function [ MaxT, tStatMatrix ] = TwoSamplePermTest(data, dataSquared, permutationMatrix1, permutationMatrix2, nGroup1, nGroup2)
    
    numPermutations = size(permutationMatrix1, 1);
    MaxT = zeros(numPermutations,1);
    
    g1Mean = (permutationMatrix1 * data)/nGroup1;
    g2Mean = (permutationMatrix2 * data)/nGroup2;
    g1Var = (permutationMatrix1 * dataSquared)/(nGroup1) - (g1Mean.*g1Mean);
    g2Var = (permutationMatrix2 * dataSquared)/(nGroup2) - (g2Mean.*g2Mean);
    tStatMatrix = (g1Mean - g2Mean) ./ (sqrt((g1Var./(nGroup1-1)) + (g2Var./(nGroup2-1))));
    MaxT(:,1) = max(tStatMatrix,[],2);        

end
