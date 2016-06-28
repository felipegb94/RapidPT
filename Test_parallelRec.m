

load('../50_25_25.mat');
load('../UHat.mat');

numPermutations = 1000;
sub = 0.005;
dataSquared = data.*data;
[N,V] = size(data);
nGroup1 = N/2;
subV = round(V * subV);
[indexMatrix, permutationMatrix1, permutationMatrix2] = TwoSampleGetPermutationMatrices(numPermutations, N, nGroup1);

[ outputs, timings ] = parallelRec(data, dataSquared, permutationMatrix1, permutationMatrix2, nGroup1, nGroup2, UHat, numPermutations)
