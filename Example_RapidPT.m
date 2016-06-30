% Addpath RapidPT Repository Path (current working dir in this case)
RapidPTLibraryPath = '.';
addpath(RapidPTLibraryPath);

% Load input data and input labels
dataPathVal = '../50_25_25.mat';
load(dataPathVal);

% N subjects, V voxels (or statistics)
[N,V] = size(Data);

% Set keys for input struct
testingTypeKey = 'testingType';
dataPathKey = 'dataPath';
dataKey = 'data';
nGroup1Key = 'nGroup1';
subKey = 'sub';
numPermutationsKey = 'T';
maxRankKey = 'maxRank';
trainNumKey = 'trainNum';
maxCyclesKey = 'maxCycles';
iterKey = 'iter';
writingKey = 'writing';

% Set the corresponding values to the keys.
testingTypeVal = {'TwoSample'};
nGroup1Val = N / 2; % Size of group 1, VERY IMPORTANT 
subVal = {0.005};  % Sampling Rate
numPermutationsVal = {5000}; % Number of Permutations.
maxRankVal = {N}; % Rank for estimating the low rank subspace
trainNumVal = {ceil(N/2)}; % Number of permutations for training.
maxCyclesVal = {3}; % Number of cycles for training.
iterVal = {30}; % Number of iterations for matrix completion.
% Set write to 1 if you want the matrices used to recover the permutation matrix.
% Setting this to 1 will make outputs a very large variable, but may be
% useful in certain cases.
writingVal = {0};


params.nPerm = numPermutationsVal{1};
params.subV = subVal{1};
params.trainNum = trainNumVal{1};
description = strcat(num2str(params.nPerm),'_',num2str(params.subV),'_',num2str(params.trainNum));
saveOutPath = '../outputs_parallel/';
saveTimePath = '../timings_parallel/';

inputs = struct(testingTypeKey, testingTypeVal,...
                dataKey, Data,...
                nGroup1Key, nGroup1Val,...
                subKey, subVal,...
                numPermutationsKey, numPermutationsVal,...
                maxRankKey, maxRankVal,...
                trainNumKey, trainNumVal,...
                maxCyclesKey, maxCyclesVal,...
                iterKey, iterVal,...
                writingKey, writingVal);
        
[outputs, timings] = RapidPT(inputs, RapidPTLibraryPath);

% THESE TWO LINES HAVE TO BE CHANGED!! 
save(strcat(saveOutPath,'params_',description,'.mat'),'params');
save(strcat(saveOutPath,'outputs_',description,'.mat'),'outputs');
save(strcat(saveTimePath,'timings_',description,'.mat'),'timings');
         
                
            
            
            
            
            
            
            