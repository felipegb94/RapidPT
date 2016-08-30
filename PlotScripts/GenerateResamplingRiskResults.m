addpath('functions');
addpath('../../SnPM-devel/');
addpath('../../nifti/');


clear;

pVals = [60,40,20,10,5,1,0.1,0.01];
numPVals = size(pVals,2);
% Parameters
permutations = 10000;
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

ResamplingRiskResults.pVals = pVals;
ResamplingRiskResults.rapidptMaxT = rapidptMaxT;
ResamplingRiskResults.snpmMaxT = snpmMaxT;
ResamplingRiskResults.subV = subV;
ResamplingRiskResults.trainNum= trainNum;
ResamplingRiskResults.permutations= permutations;
ResamplingRiskResults.tstat= snpmOutputs.SnPMt;
ResamplingRiskResults.rapidptTThresh = zeros(1,numPVals);
ResamplingRiskResults.snpmTThresh = zeros(1,numPVals);
ResamplingRiskResults.snpmSignificantVoxelIndeces = cell(numPVals,1);
ResamplingRiskResults.rapidptSignificantVoxelIndeces = cell(numPVals,1);
ResamplingRiskResults.commonSignificantVoxelIndeces = cell(numPVals,1); 
ResamplingRiskResults.resamplingRisk = zeros(1,numPVals);

tstat = snpmOutputs.SnPMt;

for i = 1:numPVals
    pVal = pVals(i);
    snpmTThresh = prctile(snpmMaxT, 100 - pVal);
    rapidptTThresh = prctile(rapidptMaxT', 100 - pVal);
    ResamplingRiskResults.snpmTThresh(i) = snpmTThresh;
    ResamplingRiskResults.rapidptTThresh(i) = rapidptTThresh;

    snpmSignificantVoxelIndeces = find(tstat > snpmTThresh);
    rapidptSignificantVoxelIndeces = find(tstat > rapidptTThresh);
    commonSignificantVoxelIndeces = intersect(snpmSignificantVoxelIndeces,rapidptSignificantVoxelIndeces);
    snpmNumSigVoxels = size(snpmSignificantVoxelIndeces,2);
    rapidptNumSigVoxels = size(rapidptSignificantVoxelIndeces,2);
    commonNumSigVoxels = size(commonSignificantVoxelIndeces,2);

    resamplingRisk_snpmTerm = (snpmNumSigVoxels - commonNumSigVoxels)/snpmNumSigVoxels;
    resamplingRisk_rapidptTerm = (rapidptNumSigVoxels - commonNumSigVoxels)/rapidptNumSigVoxels;
    resamplingRisk = (resamplingRisk_snpmTerm + resamplingRisk_rapidptTerm)/2;
    if(isnan(resamplingRisk))
       resamplingRisk = 0; 
    end
    ResamplingRiskResults.snpmSignificantVoxelIndeces{i} = snpmSignificantVoxelIndeces;
    ResamplingRiskResults.rapidptSignificantVoxelIndeces{i} = rapidptSignificantVoxelIndeces;
    ResamplingRiskResults.commonSignificantVoxelIndeces{i} = commonSignificantVoxelIndeces; 
    ResamplingRiskResults.resamplingRisk(i) = resamplingRisk; 

end


save(strcat(prefix,'ResamplingRisk_',dataset,'_',num2str(permutations),'_',num2str(subV),'_',num2str(trainNum),'.mat'), 'ResamplingRiskResults');











