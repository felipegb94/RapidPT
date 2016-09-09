addpath('functions')
N = 400;
dataset = strcat(num2str(N),'_',num2str(N/2),'_',num2str(N/2));
prefix = strcat('../../timings_parallel/',dataset,'/');
savepath = '/home/felipe/Dropbox/Felipe_Vamsi/Paper_new/figures/Speedups_All/';
savepath2 = prefix;

permutations = [2000,5000,10000,20000,40000,80000,160000];
numPerms = size(permutations,2);

load(strcat(prefix,'Speedups_',dataset,'.mat'));

speedups = SpeedupsResults.Speedups_naivept(:,2:end,:);


subV_labels = cellstr(SpeedupsResults.subVs(2:end));
trainNum_labels = cellstr(SpeedupsResults.trainNums);


for i = 1:numPerms
    filename = strcat('Speedup_NaivePT_',dataset,'_',num2str(permutations(i)));
    plot_title = strcat('Speedup RapidPT vs. NaivePT - ',num2str(permutations(i)),' Permutations');
    PlotSpeedup_heatmap(speedups(:,:,i),subV_labels,trainNum_labels,permutations(i),plot_title);
    fig = gcf;
    print(fig,strcat(savepath,filename),'-dpng');
    print(fig,strcat(savepath2,filename),'-dpng');
end