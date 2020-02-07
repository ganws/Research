% List folder contents in cell array, without '.' and '..'
% INPUT
%   1. dir_name: directory name in string
% OUTPUT 
%   1. fList: list of contents in dir_name cells.

% GAN WEI SHENG
% 2019/11/01

function [fList] = listFile(dir_name)

    fList = ls(dir_name);
    fList = num2cell(fList,2); %convert character matrix into cell array with whitespace
    fList = strtrim(fList); %remove leading and trailing whitespace, creating new cell array list

    % removing '.' and ..' from the list
    indx = strcmp(fList, '.')|strcmp(fList,'..');
    fList(indx) = [];
end