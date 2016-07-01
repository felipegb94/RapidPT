
clear;

% Parameters
permutations = [2000,5000,10000,20000,40000,80000,160000];
numPerms = size(permutations,2);
N = 50;
dataset = strcat(num2str(N),'_',num2str(N/2),'_',num2str(N/2));
prefix = strcat('../timings_parallel/',dataset,'/');

% Get SnPM output data
snpmPath = strcat(prefix,'snpm/timings_',dataset,'_320000.mat');
load(snpmPath);
snpmTime = snpmPermTime;
snpmTimePerPerm = snpmPermTime / 320000;

% RapidPT parameters
rapidptPathPrefix = strcat(prefix,'rapidpt/timings_');
subVs = {'0.001','0.0035','0.005','0.007'};%,'0.01','0.05'};
numSubVs = size(subVs,2);
trainNums = {num2str(floor(N/2)),num2str(floor(3*N/4)),num2str(N),num2str(2*N)};
numTrainNums = size(trainNums,2);

speedups = zeros(numTrainNums,numSubVs,numPerms);

for i=1:numSubVs
    subV = subVs{i};
    for j = 1:numTrainNums
        trainNum = trainNums{j};
        description = strcat('160000_',subV,'_',trainNum);
        load(strcat(rapidptPathPrefix,description,'.mat'));
        rapidptTime = timings;
        tRecovery = rapidptTime.tRecovery;
        tRecoveryPerPerm = tRecovery/160000;
        tTraining = rapidptTime.tTraining;
        for k = 1:numPerms
            perm = permutations(k);
            rapidpt_tTotal = (tRecoveryPerPerm * perm) + tTraining; 
            snpm_tTotal = snpmTimePerPerm * perm;
            speedup = snpm_tTotal / rapidpt_tTotal;

            speedups(j,i,k) = speedup;
        end
    end
end
SpeedupsResults.Speedups = speedups;
SpeedupsResults.permutations = permutations;
SpeedupsResults.subVs = subVs;
SpeedupsResults.trainNums = trainNums;

save(strcat(prefix,'Speedups_',dataset,'.mat'), 'SpeedupsResults');










