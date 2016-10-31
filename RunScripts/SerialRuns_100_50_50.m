compThreads = maxNumCompThreads(1);
pool = parpool(1)
pool.IdleTimeout = 1000;

% Addpath RapidPT Repository Path (current working dir in this case)
RapidPTLibraryPath = '../';
addpath(RapidPTLibraryPath);


% Load input data and input labels
dataPathVal = '/nobackup/vamsi/PermTest/ExperimentsData/TwoSample/100_50_50.mat';
% dataPathVal = '../../100_50_50.mat'
load(dataPathVal);

% N subjects, V voxels (or statistics)
[N,V] = size(Data);
subVals = [0.001, 0.0035, 0.005, 0.007, 0.01, 0.05];
numSubVals = size(subVals,2);
trainNumVals = [N/2, 3*N/4, N, 2*N];
numTrainNumVals = size(trainNumVals,2);

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
numPermutationsVal = {160000}; % Number of Permutations.
maxRankVal = {N}; % Rank for estimating the low rank subspace
maxCyclesVal = {3}; % Number of cycles for training.
iterVal = {30}; % Number of iterations for matrix completion.
% Set write to 1 if you want the matrices used to recover the permutation matrix.
% Setting this to 1 will make outputs a very large variable, but may be
% useful in certain cases.
writingVal = {0};


params.nPerm = numPermutationsVal{1};
saveOutPath = '../../outputs_parallel/100_50_50/rapidpt/';
saveTimePath = '../../timings_parallel/100_50_50/rapidpt/';


        
for i = 1:numSubVals
    subVal = {subVals(i)};
    params.subV = subVals(i);
    for j=1:numTrainNumVals
        trainNumVal = {trainNumVals(j)};
        params.trainNum = trainNumVals(j);       
        description = strcat(num2str(params.nPerm),'_',num2str(params.subV),'_',num2str(params.trainNum));
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
        save(strcat(saveOutPath,'params_',description,'_serial.mat'),'params');
        save(strcat(saveOutPath,'outputs_',description,'_serial.mat'),'outputs');
        save(strcat(saveTimePath,'timings_',description,'_serial.mat'),'timings');
        
    end
end


         
                
            
            
            
            
            
            
            
