# Statistics and Neuroimaging Terms and Definition

* **Omnibus Null Hypothesis:** There is no activation in any voxel. Rejecting any voxel-wise null hypothesis means rejecting the omnibus.
* **Statistic Images:** 
* **FWER:** Family-wise error rate. Probability of making at least one type one error. Becomes very high when performing multiple hypothesis tests.
* **FDR:** False-Discovery Rate. The ratio between number of false positives (type I errors or voxels that have been falsely rejected) and total number of rejected voxels (both falsely rejected and correctly rejected).
* **Weak control of FWER:** Require that the omnibus test is valid. That is the probability of declaring any voxel as activated when, in fact, none is, is at most a given level \alpha. Weak control tells us that there was or there was not an activation somewhere in the brain.
* **Strong control of FWER:** *Desired*. Requires that for any subset of voxels the omnubus test is valid. Strong control guarantees that a false positive at a particular voxel will occur with probability \alpha at most.
* **Permutation Distribution:** Estimation of the sampling distribution under the null hypothesis. If we are able to perform all possible permutations the permutation distribution is in fact the null sampling distribution. Used to calculate thresholds associated to a p-value. 
* **Exchangeability:** Under the null hypothesis the labels given to the data are artificial. This is the only assumption permutation tests make. How can it fail in a neuroimaging dataset? No control for nuissance variables such as age and gender. [Permutation inference for the general linear model] (http://www.sciencedirect.com/science/article/pii/S1053811914000913) is a recent paper discussing how to overcome these nuissance variables and presents a generic framework to do so. fMRI scans on individual subjects have temporal autocorrelations which are an issue for permutation tests.
* **Issues with Permutation Tests-Small Datasets:** With N possible relabeling the smalles p-value is 1/N. If we are doing a healthy vs diseased on only 5 healthy and 5 diseased patients the number of possible relabelings is nchoosek(10,5)=252, and the smallest p-value=1/252=0.003.
* **Issues with Permutation Tests-Experimental Design:** Each experimental design needs unique code to generate the permutations.



