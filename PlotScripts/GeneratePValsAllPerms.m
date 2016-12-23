addpath('functions')
clear;

tThresholds = 4:0.05:7;
numTThresh = size(tThresholds,2);

% Parameters
permutations = [5000, 10000, 20000, 40000];
numPerms = size(permutations,2);
N = 400;
subV = 0.0035;
trainNum = N;
dataset = strcat(num2str(N),'_',num2str(N/2),'_',num2str(N/2));
prefix = strcat('../../outputs_parallel/',dataset,'/');
rapidptPath = strcat(prefix,'rapidpt/');
description = strcat('160000_',num2str(subV),'_',num2str(trainNum));
rapidptFilename = strcat('outputs_',description,'.mat');
load(strcat(rapidptPath,rapidptFilename));

% Get SnPM output data
snpmPath = strcat(prefix,'snpm/outputs_',dataset,'_320000.mat');
load(snpmPath);

% Get NaivePT output data
naiveptPath = strcat(prefix,'completept/outputsNaive_',dataset,'_40000.mat');
load(naiveptPath);


pValResults.tThresh = tThresholds;
pValResults.snpmPVal = zeros(numPerms,numTThresh);
pValResults.rapidptPVal = zeros(numPerms,numTThresh);
pValResults.naiveptPVal = zeros(numPerms,numTThresh);
pValResults.nPerm = permutations;
pValResults.subV = subV;
pValResults.trainNum = trainNum;

for i = 1:numPerms
    perm = permutations(i)
    rapidptMaxT = outputs.MaxT(1:perm);
    snpmMaxT = snpmOutputs.MaxT(1:perm,1);
    naiveptMaxT = naiveptOutputs.MaxT(1:perm);

    for j = 1:numTThresh
        tThresh = tThresholds(j);
        pValResults.snpmPVal(j) = 100 * size(find(snpmMaxT > tThresh),1)/perm;
        pValResults.rapidptPVal(j) = 100 * size(find(rapidptMaxT > tThresh),2)/perm;
        pValResults.naiveptPVal(j) = 100 * size(find(naiveptMaxT > tThresh),1)/perm;
    end
end
% 
save(strcat(prefix,'PValAllPerms_',dataset,'_',num2str(subV),'_',num2str(trainNum),'.mat'), 'pValResults');
