close all;
clf;
clear;

% Get the outputs struct you obtained from RapidPT
load('~/PermTest/outputs/TwoSample_ADRC_200_200_400/rapidpt/outputs_80000_0.005_200.mat');
alpha = 0.01; % Significance level of 1 percent
tThresh_RapidPT = prctile(outputs.maxT, 100 - (100*alpha));
% Get the data
load('~/PermTest/data/ADRC/TwoSample/ADRC_400_200_200.mat');
[h,p,ci,stats]=ttest2(Data(1:200,:),Data(201:400,:),0.05,'both','unequal');
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

%Get SnPM
% load('~/PermTest/outputs/TwoSample_ADRC_200_200_400/snpm/outputs_400_80000.mat');
% MaxTSnPM = MaxT(:,1);
% [counts2] = hist(MaxTSnPM, centers);
% tThresh_SnPM = prctile(MaxTSnPM, 100 - (100*alpha));
% 
% figure;
% plot(centers, counts1, '*r', centers, counts2, '+b', [tThresh_RapidPT tThresh_RapidPT],[0 4000],'r--',[tThresh_SnPM tThresh_SnPM],[0 4000],'b--',[tThresh_Bonferroni tThresh_Bonferroni],[0 4000],'k--');
% title('Maximum Null Distribution');
% xlabel('t-statistic');
% ylabel('count');
%     
% legend('RapidPT Null','SnPM Null', 'RapidPT t-threshold','SnPM t-threshold','Bonferroni t-threshold');
% set(gca,'FontSize',16)
%         





