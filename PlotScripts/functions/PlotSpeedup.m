function [f] = PlotSpeedup(SamplingRate, NumTrainSamples, NumPermutations, Speedup, range)
%PlotSpeedup Summary of this function goes here
%   Comment. Was not able to flip NumTrainSamples

f = figure;
im = imagesc(SamplingRate, NumTrainSamples,Speedup,range);
plotTitle = strcat('Speedup SnPM/RapidPT-',NumPermutations,' Permutations');
colormap jet;
title(plotTitle);
xlabel('Sampling Rate');
ylabel('Number of Training Samples');
cb = colorbar;
ylabel(cb, 'Speedup')
% xlim([0 0.05])
% ylim([50 200])
set(gca,'FontSize',14)
end

