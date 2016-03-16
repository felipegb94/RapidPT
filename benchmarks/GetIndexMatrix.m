function [ indexMatrix ] = GetIndexMatrix(numPermutations, N, nGroup1)
%GetPermutationMatrices 
%   * indexMatrix: Each column contains the indeces that will be used to
%   make a permutation. Rows 1-nGroup1 are the indeces for group 1 and
%   rows nGroup1-size(labels,1) are the indeces for group 2. This matrix is
%   used when doing serial permutation testing where each permutation is
%   calculated one by one.

    rng shuffle;
    indexMatrix = zeros(numPermutations, N); 

    for t = 1:numPermutations
        currLabels = randperm(N);
        indexMatrix(t,:) = currLabels;
    end

end





