%% arrange time series data into matrix D.

% GAN WEI SHENG
% v20191101: written
% ver20191206: modified
% ver20191224: - added OHleak to parameter(for 191111)
%                      - added flow volume to parameter
clear; clc;
%% SETTINGS


load rsal_191111.mat;
frame = 1: 2000 ;  % frame to be extracted from time series data to form matrix D
classMarker = {'b.', 'c^', 'rx', 'r*'};
classLine = {'b-', 'm-', 'r-', 'r-'};
newmatname = ['D_rsal_', dataset, '.mat'];


%{
load rsal_171120_0.mat;
classMarker = {'bo', 'rX'};
classLine = {'b-', 'r-'};
frame = 1: 2000 ;  % frame to be extracted from time series data to form matrix D
newmatname = ['D_rsal_', dataset, '.mat'];
%}
%% Init
len = length(frame) ;
% preallocation

t_indx = zeros(len, nSample);
D = zeros((nVar)*len, nSample); 
ID = cell(1, nSample) ;
Y = cell(1, nSample) ;
OHleak = zeros(1,nSample);
flow_vol = zeros(1,nSample);

sample = sortStruct(sample, 'class') ; 
for n = 1:nSample
    Y{n} = sample(n).class ;
    ID{n} = sample(n).ID;
    if ~isempty(sample(1).OHleak)
        OHleak(n) = sample(n).OHleak;
        flow_vol(n) = sample(n).flow_vol;
    end
end
[indx_var, indx_class] = generateIndex(len, nVar, Y) ; %generate index

%% arrange in matrix D

for n = 1:nSample
    t_indx(:, n)= sample(n).t_indx(frame); %time index
    for v = 1:nVar 
        D(indx_var{v}, n) = sample(n).var{v}(frame); %process variable
    end
end


%% Save .mat file

save(newmatname, 'dataset', 'nSample', 'nClass','classLabel', ...
                                'classSize','nVar', 'varName', 'varUnit', ...
                                'frame', 'len','t_indx', 'D', 'Y','ID', 'indx_class', ...
                                'indx_var','classMarker','classLine', 'isScaled', 'isAligned', ...
                                'minval', 'maxval', 'OHleak', 'flow_vol') ;

fprintf('Data of frame [%d %d] is successfully converted into matrix D [%d x %d] and saved into %s \n', ...
            frame(1), frame(end), size(D,1), size(D,2), newmatname) ;