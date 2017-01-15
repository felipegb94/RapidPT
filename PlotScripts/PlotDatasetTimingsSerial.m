clf; close all;clear;
addpath('functions');
addpath('include');

co = [0    0.4470    0.7410;...
    0.8500    0.3250    0.0980;...
    0.9290    0.6940    0.1250;...
    0.4940    0.1840    0.5560;...
    0.4660    0.6740    0.1880;...
    0.3010    0.7450    0.9330;...
    0.6350    0.0780    0.1840];

% RapidPT parameters
permutations = 20000;
numPerms = size(permutations,2);
N = [50,100,200,400];
numDatasets = size(N,2);
subV = 0.0035;
datasetLabels = {'50','100','200','400'}  ;        

save_path = '/home/felipe/Dropbox/permtest_neuroimage/figures/DatasetScaling_All/';
prefix = strcat('../../timings_parallel/');
description = strcat(num2str(subV),'_',num2str(permutations));
filename = strcat('DatasetTimingsSerial_',description,'.mat');
load(strcat(prefix,filename))

stackData = zeros(numDatasets, 2, 2);
for j = 1:numDatasets
    stackData(j,1,1) = DatasetTimings.rapidptTrainTimes(j) / 3600;
    stackData(j,1,2) = DatasetTimings.rapidptRecTimes(j) / 3600;
    if(j == 2)
      stackData(j,2,1) = DatasetTimings.snpmPermTimes(j) / 3600; 
    else
        stackData(j,2,1) = DatasetTimings.snpmPermTimes(j) / 3600;
    end
%     stackData(j,2,1) = DatasetTimings.snpmPermTimes(j) / 3600;
end
f = plotBarStackGroups(stackData, datasetLabels);
set(gcf,'Visible', 'off'); 

title(strcat('Dataset Serial Scaling, ',' L=',num2str(permutations)),'FontSize',14,'FontWeight','bold')
set(gca,'FontSize',14)
xlabel('Datasets (Number of Subjects)','FontSize',14);
ylabel('Runtime (Hours)','FontSize',14);
h = legend('RapidPT Train Time','RapidPT Recovery Time','SnPM Time', 'Location','northwest')
set(h,'fontsize',14);
grid on;

filename = strcat('DatasetTimingsSerial_',description);

    fig = gcf;
    set(gca,'FontSize',14)
    set(fig,'Units','Inches');
    pos = get(fig,'Position');
    set(fig,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
    print(fig,strcat(save_path,filename,'.pdf'),'-dpdf','-r200');
    hold off;
 