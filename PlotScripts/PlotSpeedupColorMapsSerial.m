addpath('functions')


N_All = [50,100,200,400];

for j = 1:size(N_All,2)

N = N_All(j);

dataset = strcat(num2str(N),'_',num2str(N/2),'_',num2str(N/2));
dataset_title = strcat(num2str(N),'-',num2str(N/2),'-',num2str(N/2));
prefix = strcat('../../timings_parallel/',dataset,'/');
save_path = '/home/felipe/Dropbox/permtest_neuroimage/figures/Speedups_All/';
savepath2 = prefix;

permutations = [2000,5000,10000,20000,40000,80000,160000];
numPerms = size(permutations,2);

load(strcat(prefix,'SpeedupsSerial_',dataset,'.mat'));

speedups = SpeedupsResults.Speedups_snpm(:,2:end,:);


subV_labels = cellstr(SpeedupsResults.subVsPercentage(2:end));
trainNum_labels = cellstr(SpeedupsResults.trainNums);


for i = 1:numPerms
    filename = strcat('SpeedupSerial_SnPM_',dataset,'_',num2str(permutations(i)));
    plot_title = strcat('Serial Run, n=',num2str(N),',  L=',num2str(permutations(i)));
    PlotSpeedup_heatmap(speedups(:,:,i),subV_labels,trainNum_labels,permutations(i),plot_title);
    fig = gcf;
    set(gca,'FontSize',14)
    set(fig,'Units','Inches');
    pos = get(fig,'Position');
    set(fig,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
    print(fig,strcat(save_path,filename),'-dpdf','-r200');

end
end