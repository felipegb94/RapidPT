addpath('functions')
clear;
close all;
co = [0    0.4470    0.7410;...
    0.8500    0.3250    0.0980;...
    0.9290    0.6940    0.1250;...
    0.4940    0.1840    0.5560;...
    0.4660    0.6740    0.1880;...
    0.3010    0.7450    0.9330;...
    0.6350    0.0780    0.1840];

% Parameters
perm = 10000;
N = 50;
subV = 0.0035;
trainNum = N;
dataset = strcat(num2str(N),'_',num2str(N/2),'_',num2str(N/2));
dataset_title = strcat(num2str(N),'-',num2str(N/2),'-',num2str(N/2));
prefix = strcat('../../outputs_parallel/',dataset,'/');

% Get SnPM output data
snpmPath = strcat(prefix,'snpm/outputs_',dataset,'_320000.mat');
load(snpmPath);
MaxTsnpm = snpmOutputs.MaxT(:,1);

% Get naivept output data
naiveptPath = strcat(prefix,'completept/outputsNaive_',dataset,'_40000.mat');
load(naiveptPath);
MaxTnaivept = naiveptOutputs.MaxT(:,1);

% RapidPT parameters
rapidptPathPrefix = strcat(prefix,'rapidpt/outputs_');
description = strcat('160000_',num2str(subV),'_',num2str(trainNum));
load(strcat(rapidptPathPrefix,description,'.mat'));
MaxTrapidpt = outputs.MaxT;

kldiv_rapidpt_snpm = CompareHistograms(MaxTrapidpt(1:perm),MaxTsnpm(1:perm));
kldiv_rapidpt_naivept = CompareHistograms(MaxTrapidpt(1:perm),MaxTnaivept(1:perm));
kldiv_naivept_snpm = CompareHistograms(MaxTnaivept(1:perm),MaxTsnpm(1:perm));

pval = 0.05;
binVal = perm - (pval*perm);

[counts1,centers] = hist(MaxTsnpm(1:perm), 100);
[counts2] = hist(MaxTrapidpt(1:perm), centers);
[counts3] = hist(MaxTnaivept(1:perm), centers);

index1 = find(cumsum(counts1) > binVal,1); 
index2 = find(cumsum(counts2) > binVal,1); 
index3 = find(cumsum(counts3) > binVal,1); 

xVal = centers(index1);

fig = figure;
hold on;
snpm_p = plot(centers, counts1, '-o');
rapidpt_p = plot(centers, counts2, '-*');

set(snpm_p,'Color',co(1,:),'LineWidth',1.5,'MarkerSize',6)
set(rapidpt_p,'Color',co(2,:),'LineWidth',1.5,'MarkerSize',6)

naivept_p = plot(centers, counts3, '-+');
set(naivept_p,'Color',co(7,:),'LineWidth',1.5,'MarkerSize',6)

plot([xVal xVal],get(gca,'ylim'),'--','LineWidth',1.5,'MarkerSize',6)


%title(strcat('Dataset: ',dataset_title,',  ',num2str(perm),' Permutations'),'FontSize',14,'fontweight','bold');
title('Maximum Null Distribution','FontSize',14,'fontweight','bold');
xlabel('Maximum T-Statistic','FontSize',14);
ylabel('Histogram Count','FontSize',14);
h=legend('SnPM','RapidPT','NaivePT','T-Threshold at p=0.05');
set(h,'fontsize',14);
set(gca,'FontSize',14)
grid on;

hold off;

description = strcat(num2str(perm),'_',num2str(subV),'_',num2str(trainNum));
filename = strcat('Maxnull_',dataset,'_',description);
save_path = '/home/felipe/Dropbox/Felipe_Vamsi/figures/Maxnull_All/';
saveas(fig,sprintf('%s',strcat(save_path,filename,'.eps')),'epsc');

% print(strcat(prefix,filename,'.png'),'-dpng');
% print(strcat(save_path,filename,'.png'),'-dpng');







