
addpath('include/grasta.1.2.0/')
load('../50_25_25.mat');
load('../UHat.mat');
load('../muFit.mat')
load('../opts2.mat')

numPermutations = 1000;
subV = 0.005;
dataSquared = Data.*Data;
[N,V] = size(Data);
nGroup1 = N/2;
nGroup2 = N - nGroup1;
subV = round(V * subV);
[indexMatrix, permutationMatrix1, permutationMatrix2] = TwoSampleGetPermutationMatrices(numPermutations, N, nGroup1);

[ outputs, timings ] = parallelRec_clean(Data, dataSquared, permutationMatrix1, permutationMatrix2, nGroup1, nGroup2, UHat, muFit, numPermutations,subV,opts2)
