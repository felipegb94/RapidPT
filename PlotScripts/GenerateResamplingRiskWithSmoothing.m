addpath('functions');
addpath('../../spm12/toolbox/SnPM-devel/');
addpath('../../nifti/');


clear;

N_All = [50,100,200,400];
trainNum_All = floor(2*N_All);
for k = 1:4

N = N_All(k);
trainNum = trainNum_All(k);


pVals = 1:0.2:10;
numPVals = size(pVals,2);
% Parameters
permutations = 10000;
subV = 0.0035;
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
ResamplingRiskResults.smoothNaiveptSignificantVoxelIndeces = cell(numPVals,1);
ResamplingRiskResults.smoothRapidptSignificantVoxelIndeces = cell(numPVals,1); 
ResamplingRiskResults.smoothSnpmSignificantVoxelIndeces = cell(numPVals,1); 

ResamplingRiskResults.resamplingRisk_snpm_naivept = zeros(1,numPVals);
ResamplingRiskResults.resamplingRisk_snpm_rapidpt = zeros(1,numPVals);
ResamplingRiskResults.resamplingRisk_naivept_rapidpt = zeros(1,numPVals);
ResamplingRiskResults.smoothResamplingRisk_snpm_naivept = zeros(1,numPVals);
ResamplingRiskResults.smoothResamplingRisk_snpm_rapidpt = zeros(1,numPVals);
ResamplingRiskResults.smoothResamplingRisk_naivept_rapidpt = zeros(1,numPVals);


tstat = snpmOutputs.SnPMt;
load('../../outputs_parallel/SnPM.mat');

for i = 1:numPVals
    activatedSnpmImage = zeros(snpmOutputs.params.xdim,snpmOutputs.params.ydim,snpmOutputs.params.zdim);
    activatedNaiveptImage = zeros(snpmOutputs.params.xdim,snpmOutputs.params.ydim,snpmOutputs.params.zdim);
    activatedRapidptImage = zeros(snpmOutputs.params.xdim,snpmOutputs.params.ydim,snpmOutputs.params.zdim);
   
    pVal = pVals(i);
    
    
    [resamplingRisk_snpm_rapidpt, snpmTThresh, rapidptTThresh, snpmSignificantVoxelIndeces, rapidptSignificantVoxelIndeces, snpmRapidptSignificantVoxelIndeces] = GetResamplingRisk_Full(snpmMaxT,rapidptMaxT,pVal,tstat);
    [resamplingRisk_naivept_rapidpt, naiveptTThresh, rapidptTThresh, naiveptSignificantVoxelIndeces, rapidptSignificantVoxelIndeces, naiveptRapidptSignificantVoxelIndeces] = GetResamplingRisk_Full(naiveptMaxT,rapidptMaxT,pVal,tstat);
    [resamplingRisk_snpm_naivept, snpmTThresh, naiveptTThresh, snpmSignificantVoxelIndeces, naiveptSignificantVoxelIndeces, snpmNaiveptSignificantVoxelIndeces] = GetResamplingRisk_Full(snpmMaxT,naiveptMaxT,pVal,tstat);

    snpmXYZ = snpmOutputs.XYZ(:,snpmSignificantVoxelIndeces);
    naiveptXYZ = snpmOutputs.XYZ(:,naiveptSignificantVoxelIndeces);
    rapidptXYZ = snpmOutputs.XYZ(:,rapidptSignificantVoxelIndeces);    

    e = spm_xyz2e(snpmXYZ,V(1));
    activatedSnpmImage(e) = 1;
    activatedSnpmImage = smooth3(activatedSnpmImage);
    smoothSnpmSignificantVoxelIndeces = find(activatedSnpmImage > 0)';  

    e = spm_xyz2e(naiveptXYZ,V(1));
    activatedNaiveptImage(e) = 1;
    activatedNaiveptImage = smooth3(activatedNaiveptImage);
    smoothNaiveptSignificantVoxelIndeces = find(activatedNaiveptImage > 0)';   
 
    e = spm_xyz2e(rapidptXYZ,V(1));
    activatedRapidptImage(e) = 1;
    activatedRapidptImage = smooth3(activatedRapidptImage);
    smoothRapidptSignificantVoxelIndeces = find(activatedRapidptImage > 0)';

    smoothResamplingRisk_snpm_naivept = GetResamplingRisk(smoothSnpmSignificantVoxelIndeces,smoothNaiveptSignificantVoxelIndeces);
    smoothResamplingRisk_snpm_rapidpt = GetResamplingRisk(smoothSnpmSignificantVoxelIndeces,smoothRapidptSignificantVoxelIndeces);
    smoothResamplingRisk_naivept_rapidpt = GetResamplingRisk(smoothNaiveptSignificantVoxelIndeces,smoothRapidptSignificantVoxelIndeces);

    ResamplingRiskResults.snpmTThresh(i) = snpmTThresh;
    ResamplingRiskResults.rapidptTThresh(i) = rapidptTThresh;
    ResamplingRiskResults.naiveptTThresh(i) = naiveptTThresh;
    ResamplingRiskResults.snpmSignificantVoxelIndeces{i} = snpmSignificantVoxelIndeces;
    ResamplingRiskResults.rapidptSignificantVoxelIndeces{i} = rapidptSignificantVoxelIndeces;
    ResamplingRiskResults.naiveptSignificantVoxelIndeces{i} = naiveptSignificantVoxelIndeces;
    ResamplingRiskResults.snpmRapidptSignificantVoxelIndeces{i} = snpmRapidptSignificantVoxelIndeces; 
    ResamplingRiskResults.snpmNaiveptSignificantVoxelIndeces{i} = snpmNaiveptSignificantVoxelIndeces; 
    ResamplingRiskResults.resamplingRisk_snpm_rapidpt(i) = resamplingRisk_snpm_rapidpt; 
    ResamplingRiskResults.resamplingRisk_naivept_rapidpt(i) = resamplingRisk_naivept_rapidpt; 
    ResamplingRiskResults.resamplingRisk_snpm_naivept(i) = resamplingRisk_snpm_naivept; 

    ResamplingRiskResults.smoothSnpmSignificantVoxelIndeces{i} = smoothSnpmSignificantVoxelIndeces;
    ResamplingRiskResults.smoothRapidptSignificantVoxelIndeces{i} = smoothRapidptSignificantVoxelIndeces;
    ResamplingRiskResults.smoothNaiveptSignificantVoxelIndeces{i} = smoothNaiveptSignificantVoxelIndeces;    
    ResamplingRiskResults.smoothResamplingRisk_snpm_rapidpt(i) = smoothResamplingRisk_snpm_rapidpt; 
    ResamplingRiskResults.smoothResamplingRisk_naivept_rapidpt(i) = smoothResamplingRisk_naivept_rapidpt; 
    ResamplingRiskResults.smoothResamplingRisk_snpm_naivept(i) = smoothResamplingRisk_snpm_naivept; 
end

disp(ResamplingRiskResults.smoothResamplingRisk_snpm_naivept)
disp(ResamplingRiskResults.smoothResamplingRisk_snpm_rapidpt)
disp(ResamplingRiskResults.smoothResamplingRisk_naivept_rapidpt)

save(strcat(prefix,'ResamplingRisk_',dataset,'_',num2str(permutations),'_',num2str(subV),'_',num2str(trainNum),'.mat'), 'ResamplingRiskResults');


end








