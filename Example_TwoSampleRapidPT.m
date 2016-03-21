% Addpath RapidPT Repository Path (current working dir in this case)
RapidPTLibraryPath = '.';
addpath(RapidPTLibraryPath);

% Load input data and input labels
dataPath = '~/PermTest/data/ADRC/TwoSample/ADRC_50_25_25.mat'; 
load(dataPath);
% N subjects, V voxels (or statistics)
[N,V] = size(Data);
numPermutations = 5000;
nGroup1 = 25; % You should what is the size of one of your groups prior.
% Set write to 1 if you want the matrices used to recover the permutation matrix.
% Setting this to 1 will make outputs a very large variable, but may be
% useful in certain cases.
write = 0;

[outputs, timings] = TwoSampleRapidPT(Data, numPermutations, nGroup1, write, RapidPTLibraryPath);

save(strcat('outputs/outputs_TwoSampleRapidPT_',num2str(numPermutations),'.mat'),'outputs');
save(strcat('timings/timings_TwoSampleRapidPT_',num2str(numPermutations),'.mat'),'timings');
