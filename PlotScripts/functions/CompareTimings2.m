function [ ] = CompareTimings2( x, y1, y2, name1, name2, sampling )
%CompareTimings Summary of this function goes here
%   Detailed explanation goes here

close all;

figure
plot(x,y1,'-*',...
     x,y2,'--o');
title('Timings')
xlabel('Number of Permutations')
ylabel('Time in Seconds')
legend(name1,name2)

figure;
speedup1name = strcat('Speedup',name1,'/',name2);
speedup1vs2 = y2./y1;
plot(x,speedup1vs2,'-*');
title(strcat('Speedup y1 vs. y2 at sampling = ',num2str(sampling)));
xlabel('Number of Permutations')
ylabel('Speedup y1/yn')
legend(speedup1name)

hold off;

end



