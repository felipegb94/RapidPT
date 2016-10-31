close all;

s_rapidpt_nii = rapidpt_nii;
s_rapidpt_nii.img = smooth3(rapidpt_nii.img,'gaussian',3);
 

disp('Num of activated rapidpt activated voxels before smoothing:');
disp(size(find(rapidpt_nii.img > 0)));
disp('Num of activated rapidpt activated voxels after smoothing:');
disp(size(find(s_rapidpt_nii.img > 0)));
view_nii(s_rapidpt_nii);


s_snpm_nii = snpm_nii;
s_snpm_nii.img = smooth3(snpm_nii.img,'gaussian',3);
 
disp('Num of activated snpm activated voxels before smoothing:');
disp(size(find(snpm_nii.img > 0)));
disp('Num of activated snpm activated voxels after smoothing:');
disp(size(find(s_snpm_nii.img > 0)));
view_nii(s_snpm_nii);

snpmNumActivatedVoxels = size(find(snpm_nii.img > 0),1);
s_snpmNumActivatedVoxels = size(find(s_snpm_nii.img > 0),1);
rapidptNumActivatedVoxels = size(find(rapidpt_nii.img > 0),1);
s_rapidptNumActivatedVoxels = size(find(s_rapidpt_nii.img > 0),1);
disp('Resampling risk before smoothing:');
disp(0.5 * (snpmNumActivatedVoxels - rapidptNumActivatedVoxels)/snpmNumActivatedVoxels);
disp('Resampling risk after smoothing:');
disp(0.5 * (s_snpmNumActivatedVoxels - s_rapidptNumActivatedVoxels)/s_snpmNumActivatedVoxels);
