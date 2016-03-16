# RapidPT
## Table of Contents
1. [Overview](#overview)
2. [Use Cases](#usecases)
3. [Setup](#setup)
4. [Code Organization](#codeorganization)
5. [Usage](#usage)
6. [References](#references)


<a name="overview">
## Overview
</a>

Multiple hypothesis testing is a problem when applying statistical tests on neuroimaging studies. Permutation testing is a nonparametric method for estimating an alpha threshold that can accurately help identify what brain regions display statistically significant differences or activity. The computational burden of this method, however, for low thresholds and large datasets can be prohibitive.

**RapidPT** is a MATLAB toolbox for fast, reliable, hardware independent, permutation testing. 

**1. Fast:** RapidPT has shown speedups ranging from 30-90x faster than simple permutation testing implementations, and 3-6x faster than SnPM, a state of the art permutation testing toolbox for neuroimaging data. The speedups against SnPM are seen when the number of permutations being done exceeds 10,000.

**2. Reliable:** RapidPT has been validated against SnPM and a personal permutation testing implementation. The validation was done by comparing the KL-Divergence and p-values of the maximum-null distribution recovered by each software. More than 200 validation runs have been done with various neuroimaging datasets composed from 10 up to 400 subjects. 

**3. Hardware Independent:** It has been shown that with powerful enough hardware (highend GPUs or a cluster) and an efficient implementation, the permutation testing procedure can be spedup by many orders of magnitude. These implementations highly rely on expensive hardware. RapidPT, however, takes advantage of the structure of the problem to speedup the algorithm, allowing it to be efficient even in regular laptops.

<a name="usecases">
## Use cases
</a>
RapidPT can be used for the nonparametric statistical analysis of neuroimaging data. The permutation testing procedure modeled by RapidPT is a nonparametric combination of two-sample t-test. Two sample t-test are typically used to determine if two population means are equal. Various use cases in neuroimaging and similar applications show up here such as:

**1. Placebo-Control Clinical Trials:** Detect statistically significant difference between the brain images of the subjects assigned to the placebo and control groups.

**2. Activation Studies:** Detect statistically significant difference between the brain images of subjects during activation vs. during rest.

**Note to users:** Feel free to add more use cases.

<a name="setup">
## Setup
</a>
Simply clone the repository

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

<a name="usage">
## Usage
</a>

<a name="references">
## References
</a>
RapidPT is based on the paper, Speeding up Permutation Testing in Neuroimaging, presented at NIPS, 2013.

C. Hinrichs, V. K. Ithapu, Q. Sun, V. Singh, S. C. Johnson, Speeding up Permutation Testing in Neuroimaging, Neural Information Processing Systems (NIPS), 2013.


