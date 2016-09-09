addpath('functions');
addpath('../../SnPM-devel/');
addpath('../../nifti/');


clear;

pVal = 5;

% Parameters
permutations = 10000;
N = 50;
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

ImageResults.pVal = pVal;
ImageResults.rapidptMaxT = rapidptMaxT;
ImageResults.snpmMaxT = snpmMaxT;
ImageResults.subV = subV;
ImageResults.trainNum= trainNum;
ImageResults.permutations= permutations;
ImageResults.tstat= snpmOutputs.SnPMt;
ImageResults.rapidptTThresh = 0;
ImageResults.snpmTThresh = 0;


tstat = snpmOutputs.SnPMt;

snpmTThresh = prctile(snpmMaxT, 100 - pVal);
rapidptTThresh = prctile(rapidptMaxT, 100 - pVal);
    
snpmSignificantVoxelIndeces = find(tstat > snpmTThresh);
snpmNumSigVoxels= size(snpmSignificantVoxelIndeces,2);
rapidptSignificantVoxelIndeces = find(tstat > rapidptTThresh);
rapidptNumSigVoxels= size(rapidptSignificantVoxelIndeces,2);

snpmXYZ = snpmOutputs.XYZ(:,snpmSignificantVoxelIndeces);
rapidptXYZ = snpmOutputs.XYZ(:,rapidptSignificantVoxelIndeces);

snpmPVals = zeros(1,snpmNumSigVoxels);
rapidptPVals = zeros(1,rapidptNumSigVoxels);

for i = 1:snpmNumSigVoxels
   t = tstat(snpmSignificantVoxelIndeces(i));
   snpmPVals(i) = 100 * size(find(snpmMaxT > t),1)/permutations;
end

for i = 1:rapidptNumSigVoxels
   t = tstat(rapidptSignificantVoxelIndeces(i));
   rapidptPVals(i) = 100 * size(find(rapidptMaxT > t),1)/permutations;
end



%% FIGURE OUT WHAT IS V AND HOW WE CAN CREATE IT. It is in SnPM.ma
%% GIVES INDEX OF ARRAY 121x141x121
%% READ SPM_XYZ2E function to figure out what of V is needed
load('../../outputs_parallel/SnPM.mat');
template_nii = load_nii('../../AD_036_S_4894.nii');
ImageResults.template_nii = template_nii;

e = spm_xyz2e(snpmXYZ,V(1));
activatedSnpmImage = zeros(snpmOutputs.params.xdim,snpmOutputs.params.ydim,snpmOutputs.params.zdim);
activatedSnpmImage(e) = snpmPVals;
snpm_nii = template_nii;
snpm_nii.img = activatedSnpmImage;
snpm_nii.fileprefix = strcat('snpm_nii_',dataset,'_',num2str(permutations));
save_nii(snpm_nii,strcat('/home/felipe/PermTest/',snpm_nii.fileprefix));
ImageResults.snpm_nii = snpm_nii;

e = spm_xyz2e(rapidptXYZ,V(1));
activatedRapidptImage = zeros(snpmOutputs.params.xdim,snpmOutputs.params.ydim,snpmOutputs.params.zdim);
activatedRapidptImage(e) = rapidptPVals;
rapidpt_nii = template_nii;
rapidpt_nii.img = activatedSnpmImage;
rapidpt_nii.fileprefix = strcat('rapidpt_nii_',dataset,'_',num2str(permutations),'_',num2str(subV),'_',num2str(trainNum));
save_nii(rapidpt_nii,strcat('/home/felipe/PermTest/',rapidpt_nii.fileprefix));
ImageResults.rapidpt_nii = rapidpt_nii;















