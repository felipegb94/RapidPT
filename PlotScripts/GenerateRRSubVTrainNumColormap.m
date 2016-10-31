addpath('functions')
clear;

% Parameters
permutations = [2000,5000,10000,20000,40000,80000,160000];
numPerms = size(permutations,2);
N = 400;
pVal = 1; 
dataset = strcat(num2str(N),'_',num2str(N/2),'_',num2str(N/2));
prefix = strcat('../../outputs_parallel/',dataset,'/');

% Get SnPM output data
snpmPath = strcat(prefix,'snpm/outputs_',dataset,'_320000.mat');
load(snpmPath);
snpmMaxT = snpmOutputs.MaxT(:,1);

% RapidPT parameters
rapidptPathPrefix = strcat(prefix,'rapidpt/outputs_');
subVs = {'0.0035','0.005','0.007','0.01','0.05'};
numSubVs = size(subVs,2);
trainNums = {num2str(floor(N/2)),num2str(floor(3*N/4)),num2str(N),num2str(2*N)};
numTrainNums = size(trainNums,2);

resamplingRisk = zeros(numTrainNums,numSubVs,numPerms);

tstat = snpmOutputs.SnPMt;

for i=1:numSubVs
    subV = subVs{i};
    for j = 1:numTrainNums
        trainNum = trainNums{j};
        description = strcat('160000_',subV,'_',trainNum);
        load(strcat(rapidptPathPrefix,description,'.mat'));
        rapidptMaxT = outputs.MaxT;
        for k = 1:numPerms
            perm = permutations(k);
            [rr, ~, ~, ~, ~, ~] = GetResamplingRisk_Full(snpmMaxT,rapidptMaxT,pVal,tstat);
            disp(rr)
            resamplingRisk(j,i,k) = rr;
        end
    end
end


RRSubVTrainNumResults.resamplingRisk = resamplingRisk;
RRSubVTrainNumResults.permutations = permutations;
RRSubVTrainNumResults.subVs = subVs;
RRSubVTrainNumResults.trainNums = trainNums;
RRSubVTrainNumResults.pVal = pVal;

save(strcat(prefix,'RRSubVTrainNumResults_',dataset,'_',num2str(pVal),'.mat'), 'RRSubVTrainNumResults');










