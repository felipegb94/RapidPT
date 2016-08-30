addpath('functions')
N = 400;
dataset = strcat(num2str(N),'_',num2str(N/2),'_',num2str(N/2));
prefix = strcat('../../outputs_parallel/',dataset,'/');
savepath = '/Users/sbel/Dropbox/Felipe_Vamsi/Paper_new/figures/KLDivs_All/';
savepath2 = prefix;

permutations = [2000,5000,10000,20000,40000];
numPerms = size(permutations,2);

load(strcat(prefix,'KLDivsNaivePT_',dataset,'.mat'));

kldivs = KlDivsResults.kldivs_naivept;

subV_labels = cellstr(KlDivsResults.subVs);
trainNum_labels = cellstr(KlDivsResults.trainNums);

for i = 1:numPerms
    filename = strcat('KLDiv_NaivePT_',dataset,'_',num2str(permutations(i)));
    PlotKLDiv_heatmap(kldivs(:,:,i),subV_labels,trainNum_labels,permutations(i));
    fig = gcf;
    print(fig,strcat(savepath,filename),'-dpng');
    print(fig,strcat(savepath2,filename),'-dpng');
end
