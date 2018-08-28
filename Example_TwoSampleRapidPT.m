% Addpath RapidPT Repository Path (current working dir in this case)
RapidPTLibraryPath = '.';
addpath(RapidPTLibraryPath);


rng(1);
% Load input data and input labels
<<<<<<< HEAD
dataPath = '../ADNI_50_25_25.mat'; 
=======
% dataPath = '../50_25_25.mat'; 
dataPath = '../snpm_test_data_14.mat'; 
>>>>>>> 16edce1fdf6861fb203b84f5a0122ccf63e58ad6
load(dataPath);
Data = X;
% N subjects, V voxels (or statistics)
[N,V] = size(Data);
<<<<<<< HEAD
numPermutations = 1000;
nGroup1 = 25; % You should what is the size of one of your groups prior.
=======
numPermutations = 3000;
nGroup1 = 7; % You should what is the size of one of your groups prior.
>>>>>>> 16edce1fdf6861fb203b84f5a0122ccf63e58ad6
% Set write to 1 if you want the matrices used to recover the permutation matrix.
% Setting this to 1 will make outputs a very large variable, but may be
% useful in certain cases.
write = 0;

[outputs, timings] = TwoSampleRapidPT(Data, numPermutations, nGroup1, write, RapidPTLibraryPath);

