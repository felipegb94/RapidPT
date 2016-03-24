# RapidPT
## Table of Contents
1. [Overview](#overview)
2. [Use Cases](#usecases)
3. [Setup](#setup)
4. [Usage](#usage)
5. [Code Organization](#codeorganization)
6. [Warnings](#warnings)
7. [References](#references)


<a name="overview">
## Overview
</a>

Multiple hypothesis testing is a problem when applying statistical tests on neuroimaging studies. Permutation testing is a nonparametric method for estimating an alpha threshold that can accurately help identify what brain regions display statistically significant differences or activity. The computational burden of this method, however, for low thresholds and large datasets can be prohibitive.

**RapidPT** is a MATLAB toolbox for fast, reliable, hardware independent, permutation testing. 

**1. Fast:** RapidPT has shown speedups ranging from **30-90x** faster than simple permutation testing implementations, and **3-6x** faster than SnPM, a state of the art permutation testing toolbox for neuroimaging data. The larger speedups are seen when the number of permutations being done exceeds 10,000, and the size of the dataset is larger than 20 subjects.

**2. Reliable:** RapidPT has been validated against SnPM and a personal permutation testing implementation. The validation was done by comparing the KL-Divergence and p-values of the maximum-null distribution recovered by each software. More than **200 validation runs** have been done with various neuroimaging datasets composed from 10 up to 400 subjects. 

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


