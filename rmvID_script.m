% program to remove ID from dataset

% GAN WEI SHENG
% ver20191224: written

clear;clc
%% SETTINGS

Dstruct = load('D_rsal_AC_191111.mat'); % load dataset

%select ID to remove from dataset
ID_rmv = {'61A0B2', '31E0D0', 'C09183', ...
                    'C04291', 'D0A110', '6181F0', ...
                    'D0B020', 'E0F270', 'F08373', ...
                    'E0B312', 'D01282', 'E00373', '0161A1'};
                
newfname = 'D_rsal_AC_idrmv_191111.mat';
                
%% remove data

Dstruct_new = rmvID(Dstruct, ID_rmv);

%% save to new file
unloadStruct(Dstruct_new);

save(newfname, 'dataset', 'nSample', 'nClass','classLabel', ...
                                'classSize','nVar', 'varName', 'varUnit', ...
                                'frame', 'len','t_indx', 'D', 'Y','ID', 'indx_class', ...
                                'indx_var','classMarker','classLine', 'isScaled', 'isAligned', ...
                                'minval', 'maxval', 'OHleak') ;
                            
fprintf('Data saved success into mat file "%s"\n', newfname);