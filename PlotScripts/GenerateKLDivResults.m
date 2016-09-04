addpath('functions')
clear;

% Parameters
permutations = [2000,5000,10000,20000,40000,80000,160000];
numPerms = size(permutations,2);
N = 50;
dataset = strcat(num2str(N),'_',num2str(N/2),'_',num2str(N/2));
prefix = strcat('../../outputs_parallel/',dataset,'/');

% Get SnPM output data
snpmPath = strcat(prefix,'snpm/outputs_',dataset,'_320000.mat');
load(snpmPath);
MaxTsnpm = snpmOutputs.MaxT(:,1);

% Get naivept output data
naiveptPath = strcat(prefix,'completept/outputsNaive_',dataset,'_40000.mat');
load(naiveptPath);
MaxTnaivept = naiveptOutputs.MaxT(:,1);

% RapidPT parameters
rapidptPathPrefix = strcat(prefix,'rapidpt/outputs_');
subVs = {'0.001','0.0035','0.005','0.007','0.01','0.05'};
numSubVs = size(subVs,2);
trainNums = {num2str(floor(N/2)),num2str(floor(3*N/4)),num2str(N),num2str(2*N)};
numTrainNums = size(trainNums,2);

kldivs_rapidpt_snpm = zeros(numTrainNums,numSubVs,numPerms);
kldivs_rapidpt_naivept = zeros(numTrainNums,numSubVs,numPerms);
kldivs_naivept_snpm = zeros(1,numPerms);


for i=1:numSubVs
    subV = subVs{i};
    for j = 1:numTrainNums
        trainNum = trainNums{j};
        description = strcat('160000_',subV,'_',trainNum);
        load(strcat(rapidptPathPrefix,description,'.mat'));
        MaxTrapidpt = outputs.MaxT;
        for k = 1:numPerms
            perm = permutations(k);
            kldiv_rapidpt_snpm = CompareHistograms(MaxTrapidpt(1:perm),MaxTsnpm(1:perm));
            kldivs_rapidpt_snpm(j,i,k) = kldiv_rapidpt_snpm ;
            if perm <= 40000
                kldiv_rapidpt_naivept = CompareHistograms(MaxTrapidpt(1:perm),MaxTnaivept(1:perm));
                kldivs_rapidpt_naivept(j,i,k) = kldiv_rapidpt_naivept;
            else
                kldivs_rapidpt_naivept(j,i,k) = 100;
            end
        end
    end
end

for k = 1:numPerms
            perm = permutations(k);
            if perm <= 40000
                kldiv_naivept_snpm = CompareHistograms(MaxTnaivept(1:perm),MaxTsnpm(1:perm));
                kldivs_naivept_snpm(k) = kldiv_naivept_snpm ;
            else
                kldivs_naivept_snpm(k) = 100;
            end    
end



KlDivsResults.kldivs_rapidpt_snpm = kldivs_rapidpt_snpm;
KlDivsResults.kldivs_rapidpt_naivept = kldivs_rapidpt_naivept;
KlDivsResults.kldivs_naivept_snpm = kldivs_naivept_snpm;
KlDivsResults.permutations = permutations;
KlDivsResults.subVs = subVs;
KlDivsResults.trainNums = trainNums;

save(strcat(prefix,'KLDivs_',dataset,'.mat'), 'KlDivsResults');










