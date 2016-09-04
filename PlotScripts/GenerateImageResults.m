addpath('functions');
addpath('../../SnPM-devel/');
addpath('../../nifti/');


clear;

pVal = 5;

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
    
ImageResults.snpmSignificantVoxelIndeces = find(tstat > snpmTThresh);
ImageResults.rapidptSignificantVoxelIndeces = find(tstat > rapidptTThresh);
ImageResults.snpmTThresh = snpmTThresh;
ImageResults.rapidptTThresh = rapidptTThresh;

snpmXYZ = snpmOutputs.XYZ(:,ImageResults.snpmSignificantVoxelIndeces);
rapidptXYZ = snpmOutputs.XYZ(:,ImageResults.rapidptSignificantVoxelIndeces);

%% FIGURE OUT WHAT IS V AND HOW WE CAN CREATE IT. It is in SnPM.ma
%% GIVES INDEX OF ARRAY 121x141x121
%% READ SPM_XYZ2E function to figure out what of V is needed
load('../../outputs_parallel/SnPM.mat');
template_nii = load_nii('../../AD_036_S_4894.nii');
ImageResults.template_nii = template_nii;


e = spm_xyz2e(snpmXYZ,V(1));
activatedSnpmImage = zeros(snpmOutputs.params.xdim,snpmOutputs.params.ydim,snpmOutputs.params.zdim);
activatedSnpmImage(e) = 1;
snpm_nii = template_nii;
snpm_nii.img = activatedSnpmImage;
snpm_nii.fileprefix = 'snpm_nii';

ImageResults.snpm_nii = snpm_nii;

e = spm_xyz2e(rapidptXYZ,V(1));
activatedRapidptImage = zeros(snpmOutputs.params.xdim,snpmOutputs.params.ydim,snpmOutputs.params.zdim);
activatedRapidptImage(e) = 1;
rapidpt_nii = template_nii;
rapidpt_nii.img = activatedSnpmImage;
rapidpt_nii.fileprefix = 'rapidpt_nii';

ImageResults.rapidpt_nii = rapidpt_nii;















