
Data = load('~/PermTest/data/ADRC/TwoSample/ADRC_100_50_50.mat'); 
numPermutations = 20000; 
N = size(Data,1); % N: number of subjects
V = size(Data,2); % V : number of voxels per subject
nGroup1 = 50;
nGroup2 = N - nGroup1;

timing_filename = strcat('timingsNaive_',num2str(N),'_',num2str(numPermutations),'.mat');
output_filename = strcat('outputsNaive_',num2str(N),'_',num2str(numPermutations),'.mat');

NaivePTPermTime = tic;
[indexMatrix] = GetIndexMatrix(numPermutations, N, nGroup1);
MaxT = TwoSampleNaivePT(Data, indexMatrix, nGroup1);
NaivePTPermTime = toc(NaivePTPermTime);

save(timing_filename,'NaivePTPermTime');
save(output_filename,'MaxT');

