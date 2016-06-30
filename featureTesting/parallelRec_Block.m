function [ outputs, timings ] = parallelRec_Block(data, dataSquared, permutationMatrix1, permutationMatrix2, nGroup1, nGroup2, UHat,muFit, numPermutations,subV,opts2)
    fprintf('\n Recovering the subspace coefficients and residuals for all permutations \n');
    [N,V] = size(data);
    tRecovery = tic;    
    
    MaxTStats = zeros(numPermutations,1);
    W = cell(numPermutations,1); 
    
    blockSize = 10;
    % Calculate small portion of the permutation matrix
    inds_curr = zeros(subV, blockSize);
    data_inds = zeros(N,subV,blockSize);
    dataSquared_inds = zeros(N,subV,blockSize);
    U_inds = zeros(subV,N,blockSize);
    
    for i = 0:blockSize:numPermutations-1
        for j = 1:blockSize
            inds = randperm(V,subV)';
            data_inds(:,:,j) = data(:, inds);
            dataSquared_inds(:,:,j) = dataSquared(:, inds);
            U_inds(:,:,j) = UHat(inds,:);
            inds_curr(:,j) = inds;
        end
        
        for j = 1:blockSize
            currPerm = i + j;
            TCurrent = TwoSamplePermTest(data_inds(:,:,j),...
                                         dataSquared_inds(:,:,j),...
                                         permutationMatrix1(currPerm,:),...
                                         permutationMatrix2(currPerm,:),...
                                         nGroup1,...
                                         nGroup2);  
            [s, w, jnk] = admm_srp(U_inds(:,:,j), TCurrent', opts2);
            W{currPerm,1} = w; 
            %sAll = zeros(V,1); 
            %sAll(inds) = s; 
            TRec = UHat*w + muFit;
            TRec(inds_curr(:,j)) = TRec(inds_curr(:,j)) + s;
            MaxTStats(currPerm) = max(TRec);
            fprintf('Completion done on trial %d/%d \n',currPerm,numPermutations);                                     
        end
%         inds = randperm(V,subV)'; 
%         [TCurrent] = TwoSamplePermTest(data(:,inds),...
%                                                   dataSquared(:,inds),...
%                                                   permutationMatrix1(i,:),...
%                                                   permutationMatrix2(i,:),...
%                                                   nGroup1,...
%                                                   nGroup2);
%         U_inds = UHat(inds,:);  
%         [s, w, jnk] = admm_srp(U_inds, TCurrent', opts2);
%         W{i,1} = w; 
%         %sAll = zeros(V,1); 
%         %sAll(inds) = s; 
%         TRec = UHat*w + muFit;
%         TRec(inds) = TRec(inds) + s;
%         MaxTStats(i) = max(TRec);
%         fprintf('Completion done on trial %d/%d \n',i,numPermutations);  
    end

    % Save timings
    timings.tRecovery = toc(tRecovery);
    outputs.MaxT = MaxTStats;
end

function [tStatMatrix ] = TwoSamplePermTest(data, dataSquared, permutationMatrix1, permutationMatrix2, nGroup1, nGroup2)
        
    g1Mean = (permutationMatrix1 * data)/nGroup1;
    g2Mean = (permutationMatrix2 * data)/nGroup2;
    g1Var = (permutationMatrix1 * dataSquared)/(nGroup1) - (g1Mean.*g1Mean);
    g2Var = (permutationMatrix2 * dataSquared)/(nGroup2) - (g2Mean.*g2Mean);
    tStatMatrix = (g1Mean - g2Mean) ./ (sqrt((g1Var./(nGroup1-1)) + (g2Var./(nGroup2-1))));

end

