clf; close all;

co = [0    0.4470    0.7410;...
    0.8500    0.3250    0.0980;...
    0.9290    0.6940    0.1250;...
    0.4940    0.1840    0.5560;...
    0.4660    0.6740    0.1880;...
    0.3010    0.7450    0.9330;...
    0.6350    0.0780    0.1840];


permutations = 10000;

N = 400;
subV = 0.0035;
trainNum = N;
dataset = strcat(num2str(N),'_',num2str(N/2),'_',num2str(N/2));
prefix = strcat('../../outputs_parallel/',dataset,'/');
save_path = '/home/felipe/Dropbox/Felipe_Vamsi/figures/SmoothResamplingRisk_All/';

description = strcat(num2str(permutations),'_',num2str(subV),'_',num2str(trainNum));
filename = strcat('ResamplingRisk_',dataset,'_',description);

load(strcat(prefix,filename,'.mat'));

disp(ResamplingRiskResults);

fig = figure;
hold on;
smoothResamplingRisk_snpm_naivept_p = plot(ResamplingRiskResults.pVals/100,ResamplingRiskResults.smoothResamplingRisk_snpm_naivept,'*-');
smoothResamplingRisk_snpm_rapidpt_p = plot(ResamplingRiskResults.pVals/100,ResamplingRiskResults.smoothResamplingRisk_snpm_rapidpt,'*-');
smoothResamplingRisk_naivept_rapidpt_p2 = plot(ResamplingRiskResults.pVals/100,ResamplingRiskResults.smoothResamplingRisk_naivept_rapidpt,'*-');


title(strcat('Resampling Risk -',' n=',num2str(N)),'FontSize',14,'fontweight','bold');
set(smoothResamplingRisk_snpm_naivept_p ,'Color',co(1,:),'LineWidth',2,'MarkerSize',5)
set(smoothResamplingRisk_snpm_rapidpt_p ,'Color',co(2,:),'LineWidth',2,'MarkerSize',5)
set(smoothResamplingRisk_naivept_rapidpt_p2 ,'Color',co(3,:),'LineWidth',2,'MarkerSize',5)

xlabel('P-Values','FontSize',14);
ylabel('Resampling Risk (%)','FontSize',14);
h = legend('NaivePT-SnPM','RapidPT-SnPM','NaivePT-RapidPT','Location','northeast');
set(h,'fontsize',14);
set(gca,'FontSize',14);
grid on; 

% print(strcat(prefix,'',filename,'.png'),'-dpng');
% print(strcat(save_path,'',filename,'.png'),'-dpng');

%saveas(fig,sprintf('%s',strcat(save_path,filename,'.eps')),'epsc');

hold off;
