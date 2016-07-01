function [ ] = CompareTimings3( x, y1, y2, y3, name1, name2, name3 )
%CompareTimings Summary of this function goes here
%   Detailed explanation goes here

%close all;

figure
plot(x,y1,'-*',...
     x,y2,'--o',...
     x,y3,'-.bx');
title('Timings')
xlabel('Number of Permutations')
ylabel('Time in Seconds')
legend(name1,name2,name3)

figure;
speedup1name = strcat('Speedup',name1,'/',name2);
speedup2name = strcat('Speedup',name1,'/',name3);
speedup1vs2 = y2./y1;
speedup1vs3 = y3./y1;
plot(x,speedup1vs2,'-*',...
     x,speedup1vs3,'--o');
title('Speedup y1 vs. y2 and y3')
xlabel('Number of Permutations')
ylabel('Speedup y1/yn')
legend(speedup1name,speedup2name)

hold off;

end

