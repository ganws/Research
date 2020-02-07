% Returns indices of targeted value from a particular field in data struct
% INPUT
%   1. sample: structured data
%   2. field: field name of interest in string 
%   3. findval: target value
% OUTPUT
%	1. indx: searched index
% 
% eg. find2(rawdata, 'ID', 'F0F240') 
% will return the index of sample with ID='F0F240' in structured rawdata
%
% GAN WEI SHENG
% 2019/11/19

function [indx] = find2(sample, field, findval)

    fns = fieldnames(sample); 
    indx_f = find(strcmp(field, fns)) ;
    if isa(sample(1).(fns{indx_f}) , 'char') ||  isa(sample(1).(fns{indx_f}) , 'cell') % for field value of type char or cell
        fun = @(x) strcmp(sample(x).(fns{indx_f}) , findval); 
           else % for field value OTHER THAN type char or cell
        fun = @(x) sample(x).(fns{indx_f}) == findval;
            end
    
    tf2 = arrayfun(fun, 1:numel(sample)) ; 
    indx = find(tf2) ; 
    if sum(indx) <= 0
end