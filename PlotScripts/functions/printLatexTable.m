function [ ] = printLatexTable( X, firstCol, firstRow )
%printLatexTable Summary of this function goes here
%   Detailed explanation goes here

[nrows, ncols] = size(X);


for i = 1:nrows
    if(i == 1)
       rowStr = firstRow{1};
       for k = 2:size(firstRow,2)
           rowStr = strcat(rowStr,'&',firstRow{k});
       end
       rowStr = strcat(rowStr,'    \\    \hline');
       fprintf('%s  \n',rowStr);
    end
    rowStr = strcat(firstCol{i}, '&', num2str(X(i,1)));
    
    for j = 2:ncols
        rowStr = strcat(rowStr,'    &    ',num2str(X(i,j)));
    end
    rowStr = strcat(rowStr,'    \\    \hline');
    fprintf('%s  \n',rowStr);
end


end

