% generate index for variable, sample.
% INPUT
%	1. len: Length of time series data of a variable
%	2. nVar: number of process variable
%	3. Y: class label 
% OUTPUT
%   1. indx_var: index of data points by variables
%   2. indx_class: index of samples by class

% GAN WEI SHENG
% 2019/11/26

function [indx_var, indx_class] = generateIndex (len, nVar, Y)
    
    % generate indx_var
    for n = 1:nVar
        indx_var{n} = len*(n-1)+1 : len*(n) ;
    end
    
    % generate indx_class
    classLabel = unique(Y) ; %find the number of classes
    for n = 1:numel(classLabel)
        indx_class{n} = strcmp(classLabel{n}, Y) ;
    end
              
end