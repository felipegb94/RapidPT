addpath('functions');

N = 100;
subV = 0.005;
trainNum = N;
dataset = strcat(num2str(N),'_',num2str(N/2),'_',num2str(N/2));

dataset_title = strcat(num2str(N),'-',num2str(N/2),'-',num2str(N/2));
prefix = strcat('../../outputs_parallel/',dataset,'/');
savepath = '/home/felipe/Dropbox/Felipe_Vamsi/figures/RRPValPerm_All/';
savepath2 = prefix;

filename = strcat('RRPValPerm_',dataset,'_',num2str(subV),'_',num2str(trainNum));
load(strcat(prefix,filename,'.mat'));

pVal_labels = cellstr(RRPValPermResults.pVals_str);
perm_labels = cellstr(RRPValPermResults.permutations_str);

[hImage, hText, hXText] = heatmap(RRPValPermResults.resamplingRisk,perm_labels,pVal_labels,...
                                      '%0.1f','Colorbar',true,...
                                      'FontSize', 12,...
                                      'GridLines',':',...
                                      'TextColor','w',...
                                      'Colormap','jet');
                                      
plot_title = strcat('ResamplingRisk, Dataset:',dataset_title);                                    
title(plot_title,'fontweight','bold')
xlabel('Permutations');
ylabel('P-Values');
set(gca,'FontSize',12,'FontName','Arial');
fig = gcf;
%print(fig,strcat(savepath,filename,'.png'),'-dpng');
%print(fig,strcat(savepath2,filename,'.png'),'-dpng');