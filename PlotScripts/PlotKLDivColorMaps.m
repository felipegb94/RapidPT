addpath('functions')
N = 50;
dataset = strcat(num2str(N),'_',num2str(N/2),'_',num2str(N/2));
prefix = strcat('../../outputs_parallel/',dataset,'/');

permutations = [2000,5000,10000,20000,40000,80000,160000];
numPerms = size(permutations,2);
subVs = [0.001,0.0035,0.005,0.007];%,0.01,0.05};
trainNums = [(floor(N/2)),(floor(3*N/4)),(N),(2*N)];

load(strcat(prefix,'KLDivs_',dataset,'.mat'));

kldivs = KlDivsResults.kldivs;

f = PlotKLDiv(subVs, trainNums, permutations(1), kldivs(:,:,1), [0 0.15], [0 0.007],[25 100])
