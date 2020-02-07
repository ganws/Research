% Return class size and total sample size 
% INPUT
%	1. classLabel: class labels in cell array. eg. {'A', 'B'}
%	2. sample: structuered data
% OUTPUT
%   1. calssSize: sample size in each class.
%   2. totalSize: total sample size

% GAN WEI SHENG
% 1019/11/25

function [classSize, totalSize, nClass] = updateSize(classLabel, sample)
nClass = numel(classLabel) ;
for i = 1:nClass
    classSize(i) = numel(find2(sample, 'class', classLabel{i})) ;
    fprintf('%s : %d \n', classLabel{i}, classSize(i))
end
totalSize = sum(classSize);
fprintf('\nTotal num of samples: %d \n', totalSize);

end