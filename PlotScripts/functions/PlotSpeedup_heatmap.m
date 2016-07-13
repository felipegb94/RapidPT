function [hImage, hText, hXText] = PlotSpeedup_heatmap(speedups,subV_labels,trainNum_labels,nPerm)

    maxSpeedup = max(max(speedups));
    if(maxSpeedup < 5)
       maxSpeedup = 5;        
    end
    
    plot_title = strcat('Speedup RapidPT vs. SnPM - ',num2str(nPerm),' Permutations');
	[hImage, hText, hXText] = heatmap(speedups,subV_labels,trainNum_labels,...
                                      '%0.2f','Colorbar',true,...
                                      'FontSize', 12,...
                                      'MinColorValue', 0,...
                                      'MaxColorValue', maxSpeedup,...
                                      'GridLines',':',...
                                      'Colormap','copper',...
                                      'TextColor','w');
                                      
                                      
    title(plot_title,'fontweight','bold')
    xlabel('Sampling Rate');
    ylabel('Number of Training Samples');
    set(gca,'FontSize',14,'FontName','Arial')
    

end