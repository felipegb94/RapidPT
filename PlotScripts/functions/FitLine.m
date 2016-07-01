function [ slope, newData, failIndex ] = FitLine( x, data )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here


    failIndex = size(data,1);
    
    for j = 1:size(data,1)
       if(data(j) == 0)
           failIndex = j - 1;
           break;
       end
    end

    data = data(1:failIndex);
    slope = x(1:failIndex) \ data;
    newData = slope * x;
  

end

