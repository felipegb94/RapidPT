function [ timingsSnPM, timingsRapidPT, timingsRapidPTTraining, timingsRapidPTRecovery ] = GetTimings_SecondSet(datasets, N, permutations, trainSamples )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

snpmPostfix = '.mat';

prefix = '~/PermTest/timings/';
        

numDataSets = size(datasets,2);
numPermRuns = size(permutations,2);

timingsRapidPT = zeros(numDataSets, numPermRuns);
timingsSnPM = zeros(numDataSets, numPermRuns);
timingsRapidPTTraining = zeros(numDataSets, numPermRuns);
timingsRapidPTRecovery = zeros(numDataSets, numPermRuns);

for i = 1:numDataSets
     fprintf('Dataset = %s\n', datasets{i});
     snpmPrefix = strcat(prefix,datasets{i},'/snpm/timings_',num2str(N(i)),'_');
     rapidptPrefix = strcat(prefix,datasets{i},'/rapidpt/timings_');
     rapidptPostfix = strcat('_0.005_',num2str(trainSamples(i)),'.mat');
     
     
     for j = 1:numPermRuns
        rapidptString = strcat(rapidptPrefix,num2str(permutations(j)),rapidptPostfix);
        snpmString = strcat(snpmPrefix,num2str(permutations(j)),snpmPostfix);
        
        snpmPermTime = 0;
        try
            load(snpmString);
        catch me
            fprintf('SnPM file not found...\n')
        end
        timingsSnPM(i,j) = snpmPermTime;
        load(rapidptString);
        timingsRapidPT(i,j) = timings.tTotal;
        timingsRapidPTTraining(i,j) = timings.tTraining;
        timingsRapidPTRecovery(i,j) = timings.tRecovery;

     end
end


end

