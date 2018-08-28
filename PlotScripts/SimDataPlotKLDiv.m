addpath('functions')
clear;
close all;
co = [0    0.4470    0.7410;...
    0.8500    0.3250    0.0980;...
    0.9290    0.6940    0.1250;...
    0.4940    0.1840    0.5560;...
    0.4660    0.6740    0.1880;...
    0.3010    0.7450    0.9330;...
    0.6350    0.0780    0.1840];



% Get KLDivergences
perm = 50000;
N = 30;
trainNum = 30;
sub = [0.5,1,2,4,8,16,32];
kldiv = [10,5,3,1,0.5,0.2,0.1];

fig = figure;
set(gcf,'Visible', 'on'); 

hold on;
kldiv_p = plot(sub, kldiv, '-o');
set(kldiv_p,'Color',co(1,:),'LineWidth',1.5,'MarkerSize',6)


title(strcat('KL-Divergence: L=',num2str(perm)),'FontSize',14,'fontweight','bold');
xlabel('\eta (%)','FontSize',14);
ylabel('KL-Divergence','FontSize',14);
h=legend('N=N');
set(h,'fontsize',14);
set(gca,'FontSize',14)
grid on;

hold off;

description = strcat(num2str(perm),'_',num2str(trainNum));
filename = strcat('KLDiv_SimData_',description);

% save_path = '/home/felipe/Dropbox/permtest_neuroimage/figures/Maxnull_All/';
% set(gcf,'Visible', 'off'); 
set(gca,'FontSize',14)
% set(fig,'Units','Inches');
% pos = get(fig,'Position');
% set(fig,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
% print(fig,strcat(save_path,filename,'.pdf'),'-dpdf','-r200');
