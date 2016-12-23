
clear;

% Parameters
permutations = [2000,5000,10000,20000,40000,80000,160000];
numPerms = size(permutations,2);
N = 50;
dataset = strcat(num2str(N),'_',num2str(N/2),'_',num2str(N/2));
prefix = strcat('../../timings_parallel/',dataset,'/');

% Get SnPM output data
snpmPath = strcat(prefix,'snpm/timingsSerial_',dataset,'_20000.mat');
load(snpmPath);
snpmTime = snpmPermTime;
snpmTimePerPerm = snpmPermTime / 20000;

% Get naivept output data
naiveptPath = strcat(prefix,'completept/timingsNaive_',dataset,'_40000.mat');
load(naiveptPath);
naiveptTime = naiveptPermTime;
naiveptTimePerPerm = naiveptPermTime / 40000;

% RapidPT parameters
rapidptPathPrefix = strcat(prefix,'rapidpt/timings_');
subVs = {'0.001','0.0035','0.005','0.007','0.01','0.05'};
subVsPercentage = {'0.1','0.35','0.5','0.7','1','5'};
numSubVs = size(subVs,2);
trainNums = {num2str(floor(N/2)),num2str(floor(3*N/4)),num2str(N),num2str(2*N)};
numTrainNums = size(trainNums,2);

speedups_snpm = zeros(numTrainNums,numSubVs,numPerms);
speedups_naivept = zeros(numTrainNums,numSubVs,numPerms);

timings_training = zeros(numTrainNums,numSubVs,numPerms);
timings_recovery = zeros(numTrainNums,numSubVs,numPerms);


for i=1:numSubVs
    subV = subVs{i};
    for j = 1:numTrainNums
        trainNum = trainNums{j};
        description = strcat('20000_',subV,'_',trainNum);
        load(strcat(rapidptPathPrefix,description,'_serial.mat'));
        rapidptTime = timings;
        tRecovery = rapidptTime.tRecovery;
        tRecoveryPerPerm = tRecovery/160000;
        tTraining = rapidptTime.tTraining;
        for k = 1:numPerms
            perm = permutations(k);
            rapidpt_tTotal = (tRecoveryPerPerm * perm) + tTraining; 
            snpm_tTotal = snpmTimePerPerm * perm;
            naivept_tTotal = naiveptTimePerPerm * perm;            
            speedup_snpm = snpm_tTotal / rapidpt_tTotal;
            speedup_naivept = naivept_tTotal / rapidpt_tTotal;
            
            speedups_snpm(j,i,k) = speedup_snpm;
            speedups_naivept(j,i,k) = speedup_naivept;
            timings_training(j,i,k) = tTraining;
            timings_recovery(j,i,k) = tRecoveryPerPerm * perm;
        end
    end
end
SpeedupsResults.permutations = permutations;
SpeedupsResults.subVs = subVs;
SpeedupsResults.subVsPercentage = subVsPercentage;
SpeedupsResults.trainNums = trainNums;
SpeedupsResults.Speedups_snpm = speedups_snpm;
SpeedupsResults.Speedups_naivept = speedups_naivept;

save(strcat(prefix,'SpeedupsSerial_',dataset,'.mat'), 'SpeedupsResults');










