function [f] = PlotKLDiv(SamplingRate, NumTrainSamples, NumPermutations, KLDiv, range1, range2, range3)
%PlotKLDiv Summary of this function goes here
%   Comment. Was not able to flip NumTrainSamples

f = figure;
im = imagesc(SamplingRate, NumTrainSamples,KLDiv, range1);
plotTitle = strcat('KLDivergence RapidPT vs. SnPM-',NumPermutations,' Permutations');
colormap jet;
title(plotTitle);
xlabel('Sampling Rate');
ylabel('Number of Training Samples');
cb = colorbar;
ylabel(cb, 'KLDivergence')
xlim(range2)
ylim(range3)
set(gca,'FontSize',14)
end

