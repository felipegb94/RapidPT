addpath('functions')



N_All = [50,100,200,400];

for j = 1:size(N_All,2)

N = N_All(j);
dataset = strcat(num2str(N),'_',num2str(N/2),'_',num2str(N/2));
prefix = strcat('../../outputs_parallel/',dataset,'/');
save_path = '/home/felipe/Dropbox/permtest_neuroimage/figures/KLDivs_All/';
savepath2 = prefix;

permutations = [2000,5000,10000,20000,40000,80000,160000];
numPerms = size(permutations,2);

load(strcat(prefix,'KLDivs_',dataset,'.mat'));

kldivs = KlDivsResults.kldivs_rapidpt_naivept;

subV_labels = cellstr(KlDivsResults.subVsPercent);
trainNum_labels = cellstr(KlDivsResults.trainNums);

for i = 1:numPerms
    filename = strcat('KLDiv_NaivePT_',dataset,'_',num2str(permutations(i)));
    plot_title = strcat('KLDivergence RapidPT vs. NaivePT - ',num2str(permutations(i)),' Permutations');
    PlotKLDiv_heatmap(kldivs(:,:,i),subV_labels,trainNum_labels,plot_title);
    set(gca,'FontSize',14)
    saveas(fig,sprintf('%s',strcat(save_path,filename)),'epsc');
%     if(permutations(i) == 10000)
%         disp('stop');
%     end
%     print(fig,strcat(save_path,filename),'-dpng');
%     print(fig,strcat(savepath2,filename),'-dpng');
end
end