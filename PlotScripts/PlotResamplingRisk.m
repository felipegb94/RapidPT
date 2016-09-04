clf; close all;

co = [0    0.4470    0.7410;...
    0.8500    0.3250    0.0980;...
    0.9290    0.6940    0.1250;...
    0.4940    0.1840    0.5560;...
    0.4660    0.6740    0.1880;...
    0.3010    0.7450    0.9330;...
    0.6350    0.0780    0.1840];


permutations = 80000;

N = 50;
subV = 0.005;
trainNum = N;
dataset = strcat(num2str(N),'_',num2str(N/2),'_',num2str(N/2));
prefix = strcat('../../outputs_parallel/',dataset,'/');
save_path = '/home/felipe/Dropbox/Felipe_Vamsi/figures/ResamplingRisk_All/';

description = strcat(num2str(permutations),'_',num2str(subV),'_',num2str(trainNum));
filename = strcat('ResamplingRisk_',dataset,'_',description);

load(strcat(prefix,filename,'.mat'));

disp(ResamplingRiskResults);

fig = figure;
hold on;
baseResamplingRisk_p = plot(ResamplingRiskResults.pVals/100,ResamplingRiskResults.baseResamplingRisk,'*-');
resamplingRisk_p = plot(ResamplingRiskResults.pVals/100,ResamplingRiskResults.resamplingRisk,'*-');
% naivept_p = plot(ScalingResults.permutations,ScalingResults.naiveptTimes./3600,'*-');

title(strcat('Resampling Risk -',' N=',num2str(N)),'FontSize',14,'fontweight','bold');
set(baseResamplingRisk_p ,'Color',co(1,:),'LineWidth',2,'MarkerSize',6)
set(resamplingRisk_p ,'Color',co(2,:),'LineWidth',2,'MarkerSize',6)
% set(naivept_p,'Color',co(7,:),'LineWidth',2,'MarkerSize',6)


xlabel('P-Values (%)','FontSize',14);
ylabel('Resampling Risk (%)','FontSize',14);
legend('NaivePT-SnPM','RapidPT-SnPM','Location','northeast');

set(gca,'FontSize',14)
print(strcat(prefix,filename,'.png'),'-dpng');
print(strcat(save_path,filename,'.png'),'-dpng');

hold off;
