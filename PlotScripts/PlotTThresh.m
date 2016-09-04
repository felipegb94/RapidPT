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
N = 50;
subV = 0.0035;
trainNum = N/2;
dataset = strcat(num2str(N),'_',num2str(N/2),'_',num2str(N/2));
prefix = strcat('../../outputs_parallel/',dataset,'/');
description = strcat(num2str(permutations),'_',num2str(subV),'_',num2str(trainNum));
save_path = '/home/felipe/Dropbox/Felipe_Vamsi/Paper_new/figures/TThresh_All/';
load(strcat(prefix,'TThresh_',dataset,'_',description,'.mat'));

filename = strcat('TThresh_',dataset,'_',description);

pVals = tThreshResults.pVals;
snpmTThresh = tThreshResults.snpmTThresh;
rapidptTThresh = tThreshResults.rapidptTThresh;
naiveptTThresh = tThreshResults.naiveptTThresh;

numPVals = size(pVals,2);

barPlotData_x = pVals;
barPlotData_y = [snpmTThresh',rapidptTThresh',naiveptTThresh'];

b = bar(barPlotData_y);
set(b(1),'FaceColor',co(1,:));
set(b(2),'FaceColor',co(2,:));
set(b(3),'FaceColor',co(7,:));

title(strcat('T-Threshold Comparisson -',' N=',num2str(N)),'FontSize',14,'fontweight','bold');
xlabel('P-Value (%)','FontSize',14);
ylabel('T-Threshold','FontSize',14);
legend('SnPM','RapidPT','NaivePT','Location','northwest');
set(gca,'XTickLabel',num2cell(pVals));

set(gca,'FontSize',14)

print(strcat(prefix,filename,'.png'),'-dpng');
print(strcat(save_path,filename,'.png'),'-dpng');
