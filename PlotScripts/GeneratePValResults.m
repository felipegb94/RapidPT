addpath('functions')
clear;

tThresholds = 4:0.1:7;
numTThresh = size(tThresholds,2);

% Parameters
permutations = 10000;
numPerms = size(permutations,2);
N = 400;
subV = 0.0035;
trainNum = N/2;
dataset = strcat(num2str(N),'_',num2str(N/2),'_',num2str(N/2));
prefix = strcat('../../outputs_parallel/',dataset,'/');
rapidptPath = strcat(prefix,'rapidpt/');
description = strcat('160000_',num2str(subV),'_',num2str(trainNum));
rapidptFilename = strcat('outputs_',description,'.mat');
load(strcat(rapidptPath,rapidptFilename));
rapidptMaxT = outputs.MaxT(1:permutations);

% Get SnPM output data
snpmPath = strcat(prefix,'snpm/outputs_',dataset,'_320000.mat');
load(snpmPath);
snpmMaxT = snpmOutputs.MaxT(1:permutations,1);

% Get NaivePT output data
naiveptPath = strcat(prefix,'completept/outputsNaive_',dataset,'_40000.mat');
load(naiveptPath);
naiveptMaxT = naiveptOutputs.MaxT(1:permutations);


pValResults.tThresh = tThresholds;
pValResults.snpmPVal = zeros(1,numTThresh);
pValResults.rapidptPVal = zeros(1,numTThresh);
pValResults.naiveptPVal = zeros(1,numTThresh);
pValResults.nPerm = permutations;
pValResults.subV = subV;
pValResults.trainNum = trainNum;


for i = 1:numTThresh
    tThresh = tThresholds(i);
    pValResults.snpmPVal(i) = 100 * size(find(snpmMaxT > tThresh),1)/permutations;
    pValResults.rapidptPVal(i) = 100 * size(find(rapidptMaxT > tThresh),2)/permutations;
    pValResults.naiveptPVal(i) = 100 * size(find(naiveptMaxT > tThresh),1)/permutations;
end
% 
save(strcat(prefix,'PVal_',dataset,'_',num2str(permutations),'_',num2str(subV),'_',num2str(trainNum),'.mat'), 'pValResults');
