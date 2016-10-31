addpath('functions');addpath('include');
clear;
N = 100;
datasets = [50,100,200,400];
numDatasets = size(datasets,2);



permutations = 10000;


for i = 1:numDatasets
    N = datasets(i);
    dataset = strcat(num2str(N),'_',num2str(N/2),'_',num2str(N/2));
    dataset_title = strcat(num2str(N),'-',num2str(N/2),'-',num2str(N/2));
    prefix = strcat('../../outputs_parallel/',dataset,'/');
    savepath = '/home/felipe/Dropbox/Felipe_Vamsi/figures/KLDivs_All/';
    savepath2 = prefix;
    
    load(strcat(prefix,'KLDivs_',dataset,'.mat'));

    kldivs = KlDivsResults.kldivs_rapidpt_snpm;
    subV_labels = cellstr(KlDivsResults.subVsPercent);
    trainNum_labels = cellstr(KlDivsResults.trainNums);
    
    filename = strcat('Annotated_KLDiv_SnPM_',dataset,'_',num2str(permutations));
    plot_title = strcat('Dataset: ',dataset_title,',  ',num2str(permutations),' Permutations');
    PlotKLDiv_heatmap(kldivs(:,:,i),subV_labels,trainNum_labels,plot_title);
    fig = gcf;
    set(gca,'FontSize',14)

    if(i == 1)
        disp('stop');
    end

    print(fig,strcat(savepath,filename),'-dpng');
    print(fig,strcat(savepath2,filename),'-dpng');
end
