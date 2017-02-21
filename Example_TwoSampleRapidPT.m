% Addpath RapidPT Repository Path (current working dir in this case)
RapidPTLibraryPath = '.';
addpath(RapidPTLibraryPath);

% Load input data and input labels
dataPath = '../50_25_25.mat'; 
% dataPath = '../snpm_test_data_14.mat'; 
load(dataPath);

% N subjects, V voxels (or statistics)
[N,V] = size(Data);
numPermutations = 3000;
nGroup1 = 7; % You should what is the size of one of your groups prior.
% Set write to 1 if you want the matrices used to recover the permutation matrix.
% Setting this to 1 will make outputs a very large variable, but may be
% useful for some analysis
write = 0;

[outputs, timings] = TwoSampleRapidPT(Data, numPermutations, nGroup1, write, RapidPTLibraryPath);

% save(strcat('../outputs_',num2str(numPermutations),'.mat'),'outputs');
% save(strcat('../timings_',num2str(numPermutations),'.mat'),'timings');
