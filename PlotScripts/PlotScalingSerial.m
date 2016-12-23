clf; close all;

co = [0    0.4470    0.7410;...
    0.8500    0.3250    0.0980;...
    0.9290    0.6940    0.1250;...
    0.4940    0.1840    0.5560;...
    0.4660    0.6740    0.1880;...
    0.3010    0.7450    0.9330;...
    0.6350    0.0780    0.1840];


permutations = [2000,5000,10000,20000,40000,80000,160000];
numPerms = size(permutations,2);
N = 400;
subV = 0.0035;
trainNum = N;
dataset = strcat(num2str(N),'_',num2str(N/2),'_',num2str(N/2));
prefix = strcat('../../timings_parallel/',dataset,'/');
save_path = '/home/felipe/Dropbox/Felipe_Vamsi/figures/Scaling_All/';

description = strcat(num2str(subV),'_',num2str(trainNum));
filename = strcat('ScalingSerial_',dataset,'_',description);
filenamefull = strcat('ScalingSerial_',dataset,'_',description,'.mat');

load(strcat(prefix,filenamefull));

disp(ScalingResults);

fig = figure;
hold on;
snpm_p = plot(ScalingResults.permutations,ScalingResults.snpmTimes./3600,'*-');
rapidpt_p = plot(ScalingResults.permutations,ScalingResults.rapidptTimes./3600,'*-');
% naivept_p = plot(ScalingResults.permutations,ScalingResults.naiveptTimes./3600,'*-');

title(strcat('SnPM vs RapidPT Serial Scaling -',' N=',num2str(N)),'FontSize',14,'fontweight','bold');
set(snpm_p,'Color',co(1,:),'LineWidth',2,'MarkerSize',6)
set(rapidpt_p,'Color',co(2,:),'LineWidth',2,'MarkerSize',6)
% set(naivept_p,'Color',co(7,:),'LineWidth',2,'MarkerSize',6)


xlabel('Number of Permutations','FontSize',14);
ylabel('Time (hours)','FontSize',14);
legend('SnPM','RapidPT','NaivePT','Location','northwest');

set(gca,'FontSize',14)
print(strcat(prefix,filename,'.png'),'-dpng');
print(strcat(save_path,filename,'.png'),'-dpng');

hold off;
