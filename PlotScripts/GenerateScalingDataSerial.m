addpath('functions')
clear;


% RapidPT parameters
permutations = [2000,5000,10000,20000,40000,80000,160000];
numPerms = size(permutations,2);
N = 50;
subV = 0.0035;
trainNum = N;
dataset = strcat(num2str(N),'_',num2str(N/2),'_',num2str(N/2));
prefix = strcat('../../timings_parallel/',dataset,'/');

rapidptPathPrefix = strcat(prefix,'rapidpt/timings_');
snpmPath = strcat(prefix,'snpm/timingsSerial_',dataset,'_20000.mat');

% Get SnPM output data
load(snpmPath);
snpmTime = snpmPermTime;
snpmTimePerPerm = snpmPermTime / 20000;
snpmTimes = permutations * snpmTimePerPerm;

% Get naivept output data
naiveptPath = strcat(prefix,'completept/timingsNaive_',dataset,'_40000.mat');
load(naiveptPath);
naiveptTime = naiveptPermTime;
naiveptTimePerPerm = naiveptPermTime / 40000;
naiveptTimes = permutations * naiveptTimePerPerm;


ScalingResults.snpmTimes = snpmTimes;
ScalingResults.naiveptTimes = naiveptTimes;
ScalingResults.dataset = dataset;
ScalingResults.trainNum = trainNum;
ScalingResults.permutations = permutations;
ScalingResults.subV = subV;

rapidptTimes = zeros(1,numPerms);

description_postfix = strcat(num2str(subV),'_',num2str(trainNum));
description = strcat('20000_',description_postfix);
load(strcat(rapidptPathPrefix,description,'_serial.mat'));
rapidptTime = timings;
tRecovery = rapidptTime.tRecovery;
tRecoveryPerPerm = tRecovery/20000;
tTraining = rapidptTime.tTraining;

for k = 1:numPerms
    perm = permutations(k);
    rapidpt_tTotal = (tRecoveryPerPerm * perm) + tTraining; 
    rapidptTimes(k) = rapidpt_tTotal;
end

ScalingResults.rapidptTimes = rapidptTimes;
save(strcat(prefix,'ScalingSerial_',dataset,'_',description_postfix,'.mat'), 'ScalingResults');




