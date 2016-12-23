clf; close all;

co = [0    0.4470    0.7410;...
    0.8500    0.3250    0.0980;...
    0.9290    0.6940    0.1250;...
    0.4940    0.1840    0.5560;...
    0.4660    0.6740    0.1880;...
    0.3010    0.7450    0.9330;...
    0.6350    0.0780    0.1840];

% Parameters
permutations = 10000;
numPerms = size(permutations,2);
N = 400;
subV = 0.0035;
trainNum = N;
dataset = strcat(num2str(N),'_',num2str(N/2),'_',num2str(N/2));
dataset_title = strcat(num2str(N),'-',num2str(N/2),'-',num2str(N/2));
prefix = strcat('../../outputs_parallel/',dataset,'/');
description = strcat(num2str(permutations),'_',num2str(subV),'_',num2str(trainNum));
save_path = '/home/felipe/Dropbox/Felipe_Vamsi/figures/PVals_All/';
load(strcat(prefix,'PVal_',dataset,'_',description,'.mat'));

filename = strcat('PVal_',dataset,'_',description);

disp(pValResults);

fig = figure;
hold on;
snpm_p = plot(pValResults.tThresh,pValResults.snpmPVal/100,'o');
rapidpt_p = plot(pValResults.tThresh,pValResults.rapidptPVal/100,'*');
naivept_p = plot(pValResults.tThresh,pValResults.naiveptPVal/100,'+');

title(strcat('Dataset: ',dataset_title,',  L=',num2str(permutations)),'FontSize',14,'fontweight','bold');
set(snpm_p,'Color',co(1,:),'LineWidth',2,'MarkerSize',5)
set(rapidpt_p,'Color',co(2,:),'LineWidth',2,'MarkerSize',5)
set(naivept_p,'Color',co(7,:),'LineWidth',2,'MarkerSize',5)

xlabel('T-Threshold','FontSize',14);
ylabel('P-Value','FontSize',14);
h = legend('SnPM','RapidPT','NaivePT');
set(h,'fontsize',14);
set(gca,'FontSize',14)
grid on; 

saveas(fig,sprintf('%s',strcat(save_path,filename,'.eps')),'epsc');

hold off;

