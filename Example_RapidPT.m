% Addpath RapidPT Repository Path (current working dir in this case)
RapidPTLibraryPath = '.';
addpath(RapidPTLibraryPath);

% Load input data and input labels
dataPathVal = '~/PermTest/data/ADRC/TwoSample/ADRC_50_25_25.mat'; 
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
nGroup1Val = 25; % Size of group 1, VERY IMPORTANT 
subVal = {0.005};  % Sampling Rate
numPermutationsVal = {10000}; % Number of Permutations.
maxRankVal = {N}; % Rank for estimating the low rank subspace
trainNumVal = {ceil(N/2)}; % Number of permutations for training.
maxCyclesVal = {3}; % Number of cycles for training.
iterVal = {30}; % Number of iterations for matrix completion.
% Set write to 1 if you want the matrices used to recover the permutation matrix.
% Setting this to 1 will make outputs a very large variable, but may be
% useful in certain cases.
writingVal = {0};

inputs = struct(testingTypeKey, testingTypeVal,...
                dataKey, Data,...
                nGroup1Key, nGroup1Val,...
                subKey, subVal,...
                TKey, TVal,...
                maxRankKey, maxRankVal,...
                trainNumKey, trainNumVal,...
                maxCyclesKey, maxCyclesVal,...
                iterKey, iterVal,...
                writingKey, writingVal);
            
[outputs, timings] = RapidPT(inputs, RapidPTLibraryPath);
               
% THESE TWO LINES HAVE TO BE CHANGED!! 
save(strcat('outputs/outputs_RapidPT_',num2str(numPermutations),'.mat'),'outputs');
save(strcat('timings/timings_RapidPT_',num2str(numPermutations),'.mat'),'timings');
         
            
            
            
            
            
            
            
            