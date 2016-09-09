addpath('functions');
addpath('../../SnPM-devel/');
addpath('../../nifti/');


clear;

pVals = [0.5,1,2,3,4,5,6,7,8,9,10];
pVals_str = {'0.5','1','2','3','4','5','6','7','8','9','10'};
numPVals = size(pVals,2);

% Parameters
permutations = [2000,5000,10000,20000,40000,80000,160000];
permutations_str = {'2000','5000','10000','20000','40000','80000','160000'};
numPermVals = size(permutations,2);
N = 400;
subV = 0.005;
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

% % Get naivept output data
% naiveptPath = strcat(prefix,'completept/outputsNaive_',dataset,'_40000.mat');
% load(naiveptPath);
% if(permutations > 40000)
%     naiveptMaxT = naiveptOutputs.MaxT(1:40000,1);
% else
%     naiveptMaxT = naiveptOutputs.MaxT(1:permutations,1);
% end

RRPValPermResults.pVals = pVals;
RRPValPermResults.pVals_str = pVals_str;
RRPValPermResults.permutations = permutations;
RRPValPermResults.permutations_str = permutations_str;
RRPValPermResults.resamplingRisk = zeros(numPVals,numPermVals);

tstat = snpmOutputs.SnPMt;

for i = 1:numPVals
    pVal = pVals(i);
    for j = 1:numPermVals
       
       perm = permutations(j);
       snpmMaxT = snpmOutputs.MaxT(1:perm,1);
       rapidptMaxT = outputs.MaxT(1:perm);
       [resamplingRisk, ~, ~, ~, ~, ~] = GetResamplingRisk(snpmMaxT,rapidptMaxT,pVal,tstat);
       RRPValPermResults.resamplingRisk(i,j) =  resamplingRisk;
    end
end

disp(RRPValPermResults);
save(strcat(prefix,'RRPValPerm_',dataset,'_',num2str(subV),'_',num2str(trainNum),'.mat'), 'RRPValPermResults');











