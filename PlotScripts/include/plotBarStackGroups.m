function [f] = plotBarStackGroups(stackData, groupLabels)
%% Plot a set of stacked bars, but group them according to labels provided.
%%
%% Params: 
%%      stackData is a 3D matrix (i.e., stackData(i, j, k) => (Group, Stack, StackElement)) 
%%      groupLabels is a CELL type (i.e., { 'a', 1 , 20, 'because' };)
%%
%% Copyright 2011 Evan Bollig (bollig at scs DOT fsu ANOTHERDOT edu
%%
%% 
NumGroupsPerAxis = size(stackData, 1);
NumStacksPerGroup = size(stackData, 2);


% Count off the number of bins
groupBins = 1:NumGroupsPerAxis;
MaxGroupWidth = 0.6; % Fraction of 1. If 1, then we have all bars in groups touching
groupOffset = MaxGroupWidth/NumStacksPerGroup;
f = figure;
    hold on; 
for i=1:NumStacksPerGroup

    Y = squeeze(stackData(:,i,:));
    
    % Center the bars:
    
    internalPosCount = i - ((NumStacksPerGroup+1) / 2);
    
    % Offset the group draw positions:
    groupDrawPos = (internalPosCount)* groupOffset + groupBins;
    
    h(i,:) =  bar(Y, 'stacked');
    if(i == 2)
       % h(i,:) = bar(Y, 'stacked', 'FaceColor', [1 0.54902 0]); %#ok<AGROW>
       set(h(i,1),'FaceColor', [0    0.4470    0.7410]);
    else
        %h(i,1) = bar(Y, 'stacked', 'FaceColor', [0.254902 0.411765 0.882353]); %#ok<AGROW>
        %h(i,2) = bar(Y, 'stacked', 'FaceColor', [0.678431 0.847059 0.901961]); %#ok<AGROW>
        
       set(h(i,1),'FaceColor',[0.6350    0.0780    0.1840]);
       set(h(i,2),'FaceColor',[0.8500    0.3250    0.0980]);

    end
    
    set(h(i,:),'BarWidth',groupOffset - 0.05);
    set(h(i,:),'XData',groupDrawPos);
end
hold off;
set(gca,'XTickMode','manual');
set(gca,'XTick',1:NumGroupsPerAxis);
set(gca,'XTickLabelMode','manual');
set(gca,'XTickLabel',groupLabels);
end 
