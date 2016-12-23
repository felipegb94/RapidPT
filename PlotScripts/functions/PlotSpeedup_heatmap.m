    function [hImage, hText, hXText] = PlotSpeedup_heatmap(speedups,subV_labels,trainNum_labels,nPerm,plot_title)

    maxSpeedup = max(max(speedups));
    if(maxSpeedup < 5)
       maxSpeedup = 5;        
    end
    
	[hImage, hText, hXText] = heatmap(speedups,subV_labels,trainNum_labels,...
                                      '%0.2f','Colorbar',true,...
                                      'FontSize', 14,...
                                      'MinColorValue', 0,...
                                      'MaxColorValue', maxSpeedup,...
                                      'GridLines',':',...
                                      'Colormap','hot',...
                                      'TextColor','black');
                                      
                                      
    title(plot_title,'FontSize',14,'fontweight','bold')
    xlabel('Sub-Sampling Rate (%)');
    ylabel('Training Samples');
    set(gca,'FontSize',14)
    

end