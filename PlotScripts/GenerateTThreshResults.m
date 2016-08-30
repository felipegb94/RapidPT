addpath('functions')
clear;

pVals = [20 5 1 0.5 0.1];
numPVals = size(pVals,2);

% Parameters
permutations = 10000;
numPerms = size(permutations,2);
N = 50;
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

% Get naivept output data
naiveptPath = strcat(prefix,'completept/outputsNaive_',dataset,'_40000.mat');
load(naiveptPath);
naiveptMaxT = naiveptOutputs.MaxT(1:permutations);



tThreshResults.pVals = pVals;
tThreshResults.snpmTThresh = zeros(1,numPVals);
tThreshResults.rapidptTThresh = zeros(1,numPVals);
tThreshResults.nPerm = permutations;
tThreshResults.subV = subV;
tThreshResults.trainNum = trainNum;


for i = 1:numPVals
    pVal = pVals(i);
    tThreshResults.snpmTThresh(i) = prctile(snpmMaxT, 100 - pVal);
    tThreshResults.rapidptTThresh(i) = prctile(rapidptMaxT, 100 - pVal);
    tThreshResults.naiveptTThresh(i) = prctile(naiveptMaxT, 100 - pVal);
end

save(strcat(prefix,'TThresh_',dataset,'_',num2str(permutations),'_',num2str(subV),'_',num2str(trainNum),'.mat'), 'tThreshResults');
