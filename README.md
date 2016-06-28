# RapidPT
## Table of Contents
1. [Overview](#overview)
2. [Use Cases](#usecases)
3. [Setup](#setup)
4. [Usage](#usage)
5. [Usage within SnPM] (#usagesnpm)
  * [Prerequisites](#snpmprerequisites)
  * [SnPM + RapidPT Setup](#snpmrapidptsetup)
  * [Usage](#snpmusage)
  * [Outputs Info](#snpmoutputs)
  * [Important Notes](#snpmnotes)
6. [Code Organization](#codeorganization)
7. [Warnings](#warnings)
8. [References](#references)


<a name="overview">
## Overview
</a>

Multiple hypothesis testing is a problem when applying statistical tests on neuroimaging studies. Permutation testing is a nonparametric method for estimating an alpha threshold that can accurately help identify what brain regions display statistically significant differences or activity. The computational burden of this method, however, for low thresholds and large datasets can be prohibitive.

**RapidPT** is a MATLAB toolbox for fast, reliable, hardware independent, permutation testing. 

**1. Fast:** RapidPT has shown speedups ranging from **30-90x** faster than simple permutation testing implementations, and **3-6x** faster than SnPM, a state of the art permutation testing toolbox for neuroimaging data. The larger speedups are seen when the number of permutations being done exceeds 10,000, and the size of the dataset is larger than 20 subjects.

<table style="width:100%">
  <tr>
    <td><img src="https://raw.githubusercontent.com/felipegb94/RapidPT/master/images/FirstSetNaivePT_Speedups_80000.png" alt="SpeedupNaivePT"/></td>
    <td><img src="https://raw.githubusercontent.com/felipegb94/RapidPT/master/images/FirstSet_Speedups_160000.png" alt="SpeedupSnPM"/></td>
  </tr>
</table>

**2. Reliable:** RapidPT has been validated against SnPM and a personal permutation testing implementation. The validation was done by comparing the KL-Divergence and p-values of the maximum-null distribution recovered by each software. More than **200 validation runs** have been done with various neuroimaging datasets composed from 10 up to 400 subjects. 

<table style="width:100%">
  <tr>
    <td><img src="https://raw.githubusercontent.com/felipegb94/RapidPT/master/images/FirstSet_KLDiv_160000.png" alt="KLDivSnPM"/></td>
    <td><img src="https://raw.githubusercontent.com/felipegb94/RapidPT/master/images/FirstSet_KLDivNaivePT_10000.png" alt="KLDivNaivePT"/></td>
  </tr>
</table>



**3. Hardware Independent:** It has been shown that with powerful enough hardware (highend GPUs or a cluster) and an efficient implementation, the permutation testing procedure can be spedup by many orders of magnitude. These implementations highly rely on expensive hardware. RapidPT, however, takes advantage of the structure of the problem to speedup the algorithm, allowing it to be efficient even in regular laptops.

<a name="usecases">
## Use cases
</a>
RapidPT can be used for the nonparametric statistical analysis of neuroimaging data. The permutation testing procedure modeled by RapidPT is a nonparametric combination of two-sample t-test. Two sample t-test are typically used to determine if two population means are equal. Various use cases in neuroimaging and similar applications show up here such as:

**1. Placebo-Control Clinical Trials:** Detect statistically significant difference between the brain images of the subjects assigned to the placebo and control groups.

**2. Activation Studies:** Detect statistically significant differences between the brain images of subjects during activation vs. during rest.

**Note to users:** Feel free to add more use cases.

<a name="setup">
## Setup
</a>
Simply clone the repository and add the path of the repository inside your program to be able to call the functions.

```
addpath('PATH_WHERE_YOU_CLONED_THE_REPOSITORY');
%% YOUR MATLAB PROGRAM GOES HERE. 
```

If you don't want to have the `addpath` line in every program you make, you can have it in your `startup.m` file for you MATLAB setup.

<a name="usage">
## Usage
</a>
RapidPT only offer a function that performs Permutation Testing. It has no GUI, pre or post processing modules, right now. We have prepared a plugin for SnPM that allows the user to take advantage of SnPM's GUI and pre processing and performs permutation testing using RapidPT. Please refer to the [Usage Withing SnPM](#usagesnpm) section.


There are two ways to use the core of RapidPT, either by calling the wrapper function `TwoSampleRapidPT.m` or directly calling the core function `RapidPT.m`. `TwoSampleRapidPT` assigns some default inputs that have been extensively tested that produce an accurate recovery of the maxnull distribution and then calls `RapidPT`. On the other hand if you call `RapidPT` directly you will have to assign these parameters. Let's first go through `Example_TwoSampleRapidPT.m`:

#### `Example_TwoSampleRapidPT.m`
1. First add the path to where you cloned/downloaded the `RapidPT` repository, and also load the data you will be working with. The data matrix needs to be an `NxV`, where `N` is the total number of subjects and V is the number of voxel statistics per subject.

		RapidPTLibraryPath = '.';
		addpath(RapidPTLibraryPath);
		dataPath = 'PATH TO DATA'; 
		load(dataPath);
        
2. Set number of permutations and the number of subjects in either group 1 or 2 (it does not matter which one you specify).

		numPermutations = 5000;
		nGroup1 = 25; % You should what is the size of one of your groups prior.

3. Set `write`. If set to 0, outputs will only contain the constructed maximum null distribution. If set to 1, the outputs struct will contain the basis matrix, `U`, and coefficient matrix `W`. `U*W` recover the permutation matrix. For an in depth explanation see the references. 
4. Call `TwoSampleRapidPT.m`. `outputs` is a struct containing `outputs.MaxT`,`outputs.U`, and `outputs.W`. `timings` is a struct containing timing information of different part of `RapidPT` as well as the total timing.

		[outputs, timings] = TwoSampleRapidPT(Data, numPermutations, nGroup1, write, RapidPTLibraryPath);

5. Optionally save `outputs` and `timings`.
6. Get the t-threshold estimate from the recovered maximum null distribution.

		alpha_threshold = 1; % 1 percent
		t_threshold = GetTThresh(outputs.MaxT, alpha_threshold);
		
7. If you have the labels of the data available, you can calculate the two-sample t-test and see compare the result of each voxel to the t-threshold and see which voxels exhibit statistically significant activity.

#### `Example_RapidPT.m`
Take a look at the header comments of `RapidPT.m` and the comments in `Example_RapidPT.m` to see how to directly call `RapidPT.m`. It is recommended to use `TwoSampleRapidPT.m` in order to avoid hyperparameter tuning.

<a name="usagesnpm">
## Usage within SnPM
</a>
<a name="snpmprerequisites">
### Prerequistes
</a>

* [SPM12](http://www.fil.ion.ucl.ac.uk/spm/software/) - In order to be able to use RapidPT within SPM/SnPM you will need to have SPM12 setup (obviously). For an overview of how to install SPM please refer to their [wiki](https://en.wikibooks.org/wiki/SPM/Installation_on_64bit_Linux). If you have spm setup, running `spm fmri` in the MATLAB command line should launch a GUI such as the one shown in the section [snpm usage](#snpmusage).


* [NiFTI] (http://www.mathworks.com/matlabcentral/fileexchange/8797-tools-for-nifti-and-analyze-image) - You will also need the NiFTI toolset. Make sure the NiFTI toolset path is added before you run SnPM. `addpath('NiFTI toolset path')`.

* Git (recommended) - The setup below uses git to clone the repositories. Instead of cloning them you can also download the zip files from the links given throughout the setup instructions.

<a name="snpmrapidptsetup">
### SnPM + RapidPT Setup
</a>
Currently to use RapidPT within SnPM you will have to [download my fork of SnPM](https://github.com/felipegb94/SnPM-devel) (personal copy of SnPM). To do this, go to wherever your SPM installation/folder is (mine is under my MATLAB folder) and do the following commands:

```
cd WHEREVER YOUR SPM DOWNLOAD IS
cd spm12/toolbox/
git clone https://github.com/felipegb94/SnPM-devel.git
cd SnPM-devel/
```

Then we have to make a quick change to `snpm_cp.m` in order to be able to use RapidPT. In line `781` you will have to change 

```
RapidPT_path = ~/PermTest/RapidPT/
```

to the path where you downloaded `RapidPT`. For example, you can do the following

```
cd ~/
git clone https://github.com/felipegb94/RapidPT.git
```

Here we just downloaded RapidPT to your home folder, and then go into `snpm_cp.m` and change the `RapidPT_path` variable:

```
RapidPT_path = ~/RapidPT/
```

Save `snpm_cp.m` and, now in the MATLAB command line you can launch SPM and use RapidPT.

<a name="snpmusage">
### SnPM Usage
</a>

This would be a good time to read the important notes below. 

Now that you have setup RapidPT within SnPM, SnPM will work very similar to before. Launch SPM,

```
spm fmri
```

Now follow these steps:

1. Go to SPM Menu window.
2. Click on Batch and go to the batch window that just opened.
<table style="width:100%">
  <tr>
    <th align="center"><strong>SPM GUI</strong></th>
    <th align="center"><strong>SPM Batch</strong></th>
  </tr>
  <tr>
    <td align="center"><img src="https://raw.githubusercontent.com/felipegb94/RapidPT/master/images/spmgui.png" alt="spmgui"/></td>
    <td align="center"><img src="https://raw.githubusercontent.com/felipegb94/RapidPT/master/images/spmbatch.png" alt="spmbatch"/></td>
  </tr>
</table>

3. On the navigation bar click on SPM, then `tools/SnPM/Specify/2 Groups Two Sample T test; 1 scan per subject`.
4. Here you will be able to specifiy a folder where you want your outputs to be (`Analysis Directory`), your input data (.nii images of group1 and group2), and also the number of permutations you want to do. 
5. Click the green run button. This creates an SnPM config file in the path where you want your outputs to be. This step should take a few seconds only.
6. Go to SPM navigation bar again, then `Tools/SnPM/Compute`
7. Set the SnPM cfg file to the one you just made by clicking on the run button. 
8. Click the green run button again, and now SnPM will run with RapidPT.
9. Once you are done, go to the directory that you selected as your `Analysis Directory` and look at the outputs.

<a name="snpmoutputs">
### Outputs
</a>
Once you are done, inside your `analysis` directory you will find a folder called `outputs`. This folder contains the results from RapidPT:

*  `MaxT.mat`: This is the recovered maximum null distribution.
*  `SnPMt.mat`: This is the resulting test statistic calculated using the original labels of the data. 
*  `XYZ.mat`: This matrix has the x, y, z coordinates associated to each voxel.
*  `params.mat`: This structure contains the following parameters of the permutation testing run: nPerm (number of permutations), N (number of subjects), V (number of voxels after preprocessing), xdim, ydim, zdim.
*  `coords_activeBrain_*.mat`: This contains the x,y,z coordinates of the voxels that were found to be displaying significant group differences with a significance level of alpha=0.5, 0.25, 0.1, 0.05 0.01]. These coordinates are used to generate the activeBrain nii files.
*  `activeBrain_*.nii`: This is a binary brain nii file. The 1's are the voxels that were found to display significant group differences at a particular significance level (alpha=[0.5, 0.25, 0.1, 0.05 0.01]. 
*  `timings.mat`: Contains some timing from rapidpt. 

The following plot is a historgram of the Maxnull distribution in MaxT and a t-threshold associated to an alpha=0.05.

![maxnull](https://raw.githubusercontent.com/felipegb94/RapidPT/master/images/recoveredMaxNull.png)

<a name="snpmnotes">
###Improtant Notes (PLEASE READ BEFORE USING):
</a>

* RapidPT is only available for TwoSample t-test right now because it is the procedure that has been extensively validated and benchmarked. Regular SnPM should run if you try running SnPM with any other tests.

* I integrated RapidPT into SnPM for users to be able to take advantages of SPM/SnPM graphical user interface and pre-processing. If you run SnPM with RapitPT, however, you will not be able to take advantage of any of SnPM/SPM postprocessing features because RapidPT when doing the permutation tests does not generate all of the required data for SnPM to use. If RapidPT is fully integrated into SnPM, then we will make sure that the post-processing capabilities of SnPM are also available.



<a name="codeorganization">
## Code Organization
</a>
### RapidPT

#### `RapidPT.m`
This is the core of RapidPT. This is where the main algorithm and math ideas described in the NIPS paper happen.
#### `TwoSampleRapidPT.m`
This is a wrapper of the core. This function will assign most of the hyperparameters that can be given to `RapidPT.m` for you. The hyperparameters chosen have been extensively tested, and some of them are derived from the data dimensions and number of permutations chosen.
#### `Example_TwoSampleRapidPT.m`
This is an example script that uses `TwoSampleRapidPT.m` wrapper program.
#### `Example_RapidPT.m`
This is an example script that directly uses `RapidPT.m`. You will note that a lot more hyperparameters need to be passed to `RapidPT.m` compared to `TwoSampleRapidPT.m`.
#### `TwoSampleGetLabelsMatrices.m`
This is a function that given: `numPermutations` (Number of Permutations to be done), `N` (total number of subjects), `nGroup1` (The number of subjects in group1), returns the labels for each subject in each group that will be used at each permutation. 

### include/
The `include/` folder contains the library *grasta*. This library contains the online matrix completion method we use to accelerate permutation testing. For more information about *grasta* you can refer to the [project website](https://sites.google.com/site/hejunzz/grasta#TOC-Robust-Matrix-Completion).

### outputs/ & timings/
These are the default directories used to output the resulting max-null distribution, and timings of different sections of the algorithm. If the flag `inputs.write` is set to `1` the low-rank basis, `U`, and the coefficient matrix, `W`, that can recover the permutation matrix will also be saved.

### util/
This directory contains various utility functions used by RapidPT for input validation and post-processing. Separating these functions from the main code makes `TwoSampleRapidPT.m` more concise.
  
<a name="warnings">
## Warnings
</a>
RapidPT has been extensively tested on medium and large datasets (20+ subjects) of a specific flavor. The datasets have been composed of group1 and group2 type data. Additionally these datasets after preprocessing give 300,000+ voxel statistics. Hence speedups/accuracy seen here have been on these types of datasets, and it might not make sense to use RapidPT on smaller datasets since the permutation testing procedure would take only a few minutes compared to days/hours.

 
<a name="references">
## References
</a>
RapidPT is based on the paper, Speeding up Permutation Testing in Neuroimaging, presented at NIPS, 2013.

C. Hinrichs, V. K. Ithapu, Q. Sun, V. Singh, S. C. Johnson, Speeding up Permutation Testing in Neuroimaging, Neural Information Processing Systems (NIPS), 2013.

