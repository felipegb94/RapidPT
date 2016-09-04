addpath('functions')
clear;


% RapidPT parameters
permutations = 20000;
numPerms = size(permutations,2);
N = [50,100,200,400];
numDatasets = size(N,2);
subV = 0.005;

DatasetTimings.snpmPermTimes = zeros(1,numDatasets);
DatasetTimings.rapidptTrainTimes = zeros(1,numDatasets);
DatasetTimings.rapidptRecTimes = zeros(1,numDatasets);
DatasetTimings.rapidptTimes = zeros(1,numDatasets);
DatasetTimings.nPerm = permutations;
DatasetTimings.subV = subV;
DatasetTimings.trainNums = N / 2;

for i = 1:numDatasets
    trainNum = N(i) / 2;
    dataset = strcat(num2str(N(i)),'_',num2str(N(i)/2),'_',num2str(N(i)/2));
    prefix = strcat('../../timings_parallel/',dataset,'/');  
    rapidptPathPrefix = strcat(prefix,'rapidpt/timings_');
    snpmTime = 0;
    snpmTimePerPerm = 0;
%     if N(i) <= 100
%         snpmPath = strcat(prefix,'snpm/timings_',dataset,'_160000.mat');
%         % Get SnPM output data
%         load(snpmPath);
%         snpmTime = snpmPermTime;
%         snpmTimePerPerm = snpmPermTime / 160000;
%         snpmTime = permutations * snpmTimePerPerm;
%     else
        snpmPath = strcat(prefix,'snpm/timings_',dataset,'_320000.mat');
        % Get SnPM output data
        load(snpmPath);
        snpmTime = snpmPermTime;
        snpmTimePerPerm = snpmPermTime / 320000;
        snpmTime = permutations * snpmTimePerPerm;
%     end

    % Get RapidPT output data
    description_postfix = strcat(num2str(subV),'_',num2str(trainNum));
    description = strcat('160000_',description_postfix);
    load(strcat(rapidptPathPrefix,description,'.mat'));
    rapidptTime = timings;
    rapidpt_tRecovery = rapidptTime.tRecovery;
    rapidpt_tRecoveryPerPerm = rapidpt_tRecovery/160000;
    rapidpt_tTraining = rapidptTime.tTraining;
    rapidpt_tTotal = (rapidpt_tRecoveryPerPerm * permutations) + rapidpt_tTraining; 

    % Store data
    DatasetTimings.snpmPermTimes(i) = snpmTime;
    DatasetTimings.rapidptTrainTimes(i) = rapidpt_tTraining;
    DatasetTimings.rapidptRecTimes(i) = rapidpt_tRecoveryPerPerm * permutations;
    DatasetTimings.rapidptTimes(i) = rapidpt_tTotal;

end

prefix = strcat('../../timings_parallel/');
description = strcat(num2str(subV),'_',num2str(permutations));
filename = strcat('DatasetTimings_',description,'.mat');
save(strcat(prefix,filename),'DatasetTimings');





