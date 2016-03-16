function [ MaxT ] = TwoSamplePermTest_Naive(data, labels, N1)
%TwoSamplePermTest_Naive Summary of this function goes here
%   Detailed explanation goes here

nPerm = size(labels,1);
%numStatistics = size(data,2); 
%T = zeros(nPerm, numStatistics); 
MaxT = zeros(nPerm,1);

for i = 1:nPerm
    fprintf('Permutation %d of %d\n',i,nPerm);
    label_i = labels(i,:);
    [junk1, junk2, junk3, stats] = ...
        ttest2(data(label_i(1:N1), :), data(label_i(1+N1:end), :), 0.05, 'both', 'unequal');
    %T(i,:) = stats.tstat;
    MaxT(i) = max(stats.tstat);   
end

end

