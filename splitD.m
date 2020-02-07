%% program to split dataset and generate indx

% GAN WEI SHENG
% ver20191101
% ver20191206: moved rescaling to another program
% ver20191224: added OHleak parameter, fixed bug

clear;clc
%% SETTINGS

load D_rsal_191111.mat
subSet = {'A', 'C', 'D'} ; % subset setting
newmatname = 'D_rsal_ACD_191111.mat';

%% Create subset

nSubset = numel ( subSet ); 
indx = false(nSubset,nSample);
indxNew = false(1,nSample);
isSub = false(1,nClass);

for i = 1:nSubset
    isSub = isSub | strcmp(subSet{i}, classLabel)';
    indx(i, :) = strcmp(subSet{i}, Y);
    indxNew = indxNew | indx(i,:);
end

%% update dataset info

classSize = classSize(isSub); %class size
classMarker = classMarker(isSub); %classmarker
classLine = classLine(isSub); %classline
classLabel = subSet; %classlabel
nClass = nSubset; %class number
D = D(:, indxNew); %D
Y = Y(indxNew); %Y
t_indx = t_indx(:, indxNew); %t_indx
ID = ID(indxNew); %ID
nSample = sum(classSize) ; %sample number
[indx_var, indx_class] = generateIndex(len, nVar, Y) ; %indx_var, indx_class
OHleak = OHleak(indxNew);
flow_vol = flow_vol(indxNew);

%% save in mat

save(newmatname, 'dataset', 'nSample', 'nClass','classLabel', ...
                                'classSize','nVar', 'varName', 'varUnit', ...
                                'frame', 'len','t_indx', 'D', 'Y','ID', 'indx_class', ...
                                'indx_var','classMarker','classLine', 'isScaled', 'isAligned', ...
                                'minval', 'maxval', 'OHleak', 'flow_vol') ;

fprintf('Data of frame [%d %d] is successfully converted into matrix D [%d x %d] and saved into %s.mat. \n', ...
            frame(1), frame(end), size(D,1), size(D,2), newmatname) ;