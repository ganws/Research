%read table of labels data and save it as .mat file.
%
% GAN WEI SHENG
% v20191206: written, target file: label_info_released(191203 modified).xlsx'
% v20191223_released: target file: label_info_released(191223 modified).xlsx'

%% SETTINGS

clear, clc

fname = '..\Raw_data\dataset_200826\label_info.xlsx' ;  %file name
matfname = 'paramTable_200826'; % new .mat file to be created

% Import table
opts = detectImportOptions(fname); 
paramTab = readtable(fname, opts);

% save .mat file
save(matfname, 'paramTab')
fprintf('Parameter table is successfully saved into newly created %s \n', matfname);

