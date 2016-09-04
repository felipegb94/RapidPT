addpath('functions');
addpath('../../SnPM-devel/');
addpath('../../nifti/');


clear;

pVals = [0.5,1,2,3,4,5,6,7,8,9,10];
numPVals = size(pVals,2);
% Parameters
permutations = 10000;
N = 400;
subV = 0.005;
trainNum = N;
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
if(permutations > 40000)
    naiveptMaxT = naiveptOutputs.MaxT(1:40000,1);
else
    naiveptMaxT = naiveptOutputs.MaxT(1:permutations,1);
end

ResamplingRiskResults.pVals = pVals;
ResamplingRiskResults.rapidptMaxT = rapidptMaxT;
ResamplingRiskResults.snpmMaxT = snpmMaxT;
ResamplingRiskResults.naiveptMaxT = naiveptMaxT;
ResamplingRiskResults.subV = subV;
ResamplingRiskResults.trainNum= trainNum;
ResamplingRiskResults.permutations= permutations;
ResamplingRiskResults.tstat= snpmOutputs.SnPMt;
ResamplingRiskResults.rapidptTThresh = zeros(1,numPVals);
ResamplingRiskResults.snpmTThresh = zeros(1,numPVals);
ResamplingRiskResults.naiveptTThresh = zeros(1,numPVals);
ResamplingRiskResults.snpmSignificantVoxelIndeces = cell(numPVals,1);
ResamplingRiskResults.rapidptSignificantVoxelIndeces = cell(numPVals,1);
ResamplingRiskResults.naiveptSignificantVoxelIndeces = cell(numPVals,1);
ResamplingRiskResults.snpmRapidptSignificantVoxelIndeces = cell(numPVals,1); 
ResamplingRiskResults.snpmNaiveptSignificantVoxelIndeces = cell(numPVals,1); 

ResamplingRiskResults.baseResamplingRisk = zeros(1,numPVals);
ResamplingRiskResults.resamplingRisk = zeros(1,numPVals);

% ResamplingRiskResults.resamplingRisk = zeros(1,numPVals);

tstat = snpmOutputs.SnPMt;

for i = 1:numPVals
    pVal = pVals(i);
    snpmTThresh = prctile(snpmMaxT, 100 - pVal);
    rapidptTThresh = prctile(rapidptMaxT', 100 - pVal);
    naiveptTThresh = prctile(naiveptMaxT', 100 - pVal);
    ResamplingRiskResults.snpmTThresh(i) = snpmTThresh;
    ResamplingRiskResults.rapidptTThresh(i) = rapidptTThresh;
    ResamplingRiskResults.naiveptTThresh(i) = naiveptTThresh;

    snpmSignificantVoxelIndeces = find(tstat > snpmTThresh);
    rapidptSignificantVoxelIndeces = find(tstat > rapidptTThresh);
    naiveptSignificantVoxelIndeces = find(tstat > naiveptTThresh);
    snpmRapidptSignificantVoxelIndeces = intersect(snpmSignificantVoxelIndeces,rapidptSignificantVoxelIndeces);
    snpmNaiveptSignificantVoxelIndeces = intersect(snpmSignificantVoxelIndeces,naiveptSignificantVoxelIndeces);    
    
    snpmNumSigVoxels = size(snpmSignificantVoxelIndeces,2);
    rapidptNumSigVoxels = size(rapidptSignificantVoxelIndeces,2);
    naiveptNumSigVoxels = size(naiveptSignificantVoxelIndeces,2);
 
    snpmRapidptNumSigVoxels = size(snpmRapidptSignificantVoxelIndeces,2);
    snpmNaiveptNumSigVoxels = size(snpmNaiveptSignificantVoxelIndeces,2);
    
    resamplingRisk_snpmTerm = (snpmNumSigVoxels - snpmRapidptNumSigVoxels)/snpmNumSigVoxels;
    resamplingRisk_rapidptTerm = (rapidptNumSigVoxels - snpmRapidptNumSigVoxels)/rapidptNumSigVoxels;
    resamplingRisk = (resamplingRisk_snpmTerm + resamplingRisk_rapidptTerm)/2;

    baseResamplingRisk_snpmTerm = (snpmNumSigVoxels - snpmNaiveptNumSigVoxels)/snpmNumSigVoxels;
    baseResamplingRisk_naiveptTerm = (naiveptNumSigVoxels - snpmNaiveptNumSigVoxels)/naiveptNumSigVoxels;
    baseResamplingRisk = (baseResamplingRisk_snpmTerm + baseResamplingRisk_naiveptTerm )/2;
    
    
    if(isnan(resamplingRisk))
       resamplingRisk = 1; 
    end

    if(isnan(baseResamplingRisk))
       baseResamplingRisk = 1; 
    end
    
    
    ResamplingRiskResults.snpmSignificantVoxelIndeces{i} = snpmSignificantVoxelIndeces;
    ResamplingRiskResults.rapidptSignificantVoxelIndeces{i} = rapidptSignificantVoxelIndeces;
    ResamplingRiskResults.naiveptSignificantVoxelIndeces{i} = naiveptSignificantVoxelIndeces;
        
    ResamplingRiskResults.snpmRapidptSignificantVoxelIndeces{i} = snpmRapidptSignificantVoxelIndeces; 
    ResamplingRiskResults.snpmNaiveptSignificantVoxelIndeces{i} = snpmNaiveptSignificantVoxelIndeces; 
    ResamplingRiskResults.resamplingRisk(i) = resamplingRisk * 100; 
    ResamplingRiskResults.baseResamplingRisk(i) = baseResamplingRisk * 100; 

end


save(strcat(prefix,'ResamplingRisk_',dataset,'_',num2str(permutations),'_',num2str(subV),'_',num2str(trainNum),'.mat'), 'ResamplingRiskResults');











