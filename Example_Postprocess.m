close all;
clf;
clear;

% Get the outputs struct you obtained from RapidPT
load('~/PermTest/outputs/TwoSample_ADRC_25_25_50/rapidpt/outputs_10000_0.005_100.mat');
alpha = 0.01; % Significance level of 1 percent
tThresh_RapidPT = prctile(outputs.maxT, 100 - (100*alpha));
% Get the data
load('~/PermTest/data/ADRC/TwoSample/ADRC_50_25_25.mat');
[h,p,ci,stats]=ttest2(Data(1:25,:),Data(26:50,:),0.05,'both','unequal');
SampleMaxT = max(stats.tstat);

figure;
hold on;
h = histogram(outputs.maxT)
plot([tThresh_RapidPT tThresh_RapidPT],[0 4000],'b--');
legend('RapidPT Null', 'RapidPT t-threshold');
title('Maximum Null Distribution');
xlabel('t-statistic');
ylabel('count');  
set(gca,'FontSize',16)
%plot(SampleMaxT,0,'*r')





