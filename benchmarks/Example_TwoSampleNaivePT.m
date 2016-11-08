load('/nobackup/vamsi/PermTest/ExperimentsData/TwoSample/50_25_25.mat'); 
%load('../../50_25_25.mat');
numPermutations = 100; 
N = size(Data,1); % N: number of subjects
V = size(Data,2); % V : number of voxels per subject
nGroup1 = N / 2;
nGroup2 = N - nGroup1;
dataset = strcat(num2str(N),'_',num2str(nGroup1),'_',num2str(nGroup2));

outputs_path = strcat('~/private/PermTest/outputs_parallel/',dataset,'/completept/');
timings_path = strcat('~/private/PermTest/timings_parallel/',dataset,'/completept/');

outputs_filename = strcat('outputsNaive_',dataset,'_',num2str(numPermutations),'.mat');
timings_filename = strcat('timingsNaive_',dataset,'_',num2str(numPermutations),'.mat');

naiveptPermTime = tic;
[indexMatrix] = GetIndexMatrix(numPermutations, N, nGroup1);
MaxT = TwoSampleNaivePT(Data, indexMatrix, nGroup1);
naiveptPermTime = toc(naiveptPermTime);

naiveptOutputs.MaxT = MaxT;
naiveptOutputs.Dataset = dataset;

save(strcat(outputs_path,outputs_filename),'naiveptOutputs');
save(strcat(timings_path,timings_filename),'naiveptPermTime');

