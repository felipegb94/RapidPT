numCoresAvail = feature('numCores');
pool = parpool(numCoresAvail)
pool.IdleTimeout = 1000;

% Addpath RapidPT Repository Path (current working dir in this case)
RapidPTLibraryPath = '../';
addpath(RapidPTLibraryPath);


% Load input data and input labels
dataPathVals = {'/nobackup/vamsi/PermTest/ExperimentsData/TwoSample/50_25_25.mat',...
    '/nobackup/vamsi/PermTest/ExperimentsData/TwoSample/100_50_50.mat',...
    '/nobackup/vamsi/PermTest/ExperimentsData/TwoSample/200_100_100.mat',...
    '/nobackup/vamsi/PermTest/ExperimentsData/TwoSample/400_200_200.mat'};

for i=1:4

dataPathVal = dataPathVals{i}

load(dataPathVal);

% N subjects, V voxels (or statistics)
[N,V] = size(Data);
nG1 = floor(N/2);
description = strcat(num2str(N),'_',num2str(nG1),'_',num2str(nG1))
saveOutPath = strcat('../../outputs_parallel/',description,'/rapidpt/');
saveTimePath = strcat('../../timings_parallel/',description,'/rapidpt/');

subVal = 0.0035;
trainNum = N;

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
numPermutationsVal = {5000}; % Number of Permutations.
maxRankVal = {N}; % Rank for estimating the low rank subspace
maxCyclesVal = {3}; % Number of cycles for training.
iterVal = {30}; % Number of iterations for matrix completion.
% Set write to 1 if you want the matrices used to recover the permutation matrix.
% Setting this to 1 will make outputs a very large variable, but may be
% useful in certain cases.
writingVal = {0};




params.nPerm = numPermutationsVal{1};


        
params.subV = subVal;
trainNumVal = {trainNum};
params.trainNum = trainNum;       

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

delete(pool);
         
                
            
            
            
            
            
            
            
