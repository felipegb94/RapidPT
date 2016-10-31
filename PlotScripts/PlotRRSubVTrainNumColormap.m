addpath('functions');

pVal = 5;
N = 50;
perm = 10000;
trainNum = N;
dataset = strcat(num2str(N),'_',num2str(N/2),'_',num2str(N/2));

dataset_title = strcat(num2str(N),'-',num2str(N/2),'-',num2str(N/2));
prefix = strcat('../../outputs_parallel/',dataset,'/');
savepath = '/home/felipe/Dropbox/Felipe_Vamsi/figures/RRSubVTrainNum_All/';
savepath2 = prefix;

filename = strcat('RRSubVTrainNumResults_',dataset,'_',num2str(pVal));
load(strcat(prefix,filename,'.mat'));

index = find(RRSubVTrainNumResults.permutations == perm);

subV_labels = cellstr(RRSubVTrainNumResults.subVs);
trainNum_labels = cellstr(RRSubVTrainNumResults.trainNums);

[hImage, hText, hXText] = heatmap(RRSubVTrainNumResults.resamplingRisk(:,:,index),subV_labels,trainNum_labels,...
                                      '%0.1f','Colorbar',true,...
                                      'FontSize', 12,...
                                      'GridLines',':',...
                                      'TextColor','w',...
                                      'Colormap','jet');
%                                       
plot_title = strcat('ResamplingRisk, Dataset:',dataset_title);                                    
title(plot_title,'fontweight','bold')
xlabel('Sampling Rate');
ylabel('Num Training Samples');
set(gca,'FontSize',12,'FontName','Arial');

% fig = gcf;
% print(fig,strcat(savepath,filename,'.png'),'-dpng');
% print(fig,strcat(savepath2,filename,'.png'),'-dpng');