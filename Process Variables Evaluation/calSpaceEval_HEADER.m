% kernel for calSpaceEval.m. automate calSpaceEval for all selected
% D.matfile.
clear;clc;
%% SETTING 

%select subset for feature space evaluation calc
dataset={'D_rsal_AB_191111.mat', ...
    'D_rsal_AC_191111.mat', ...
    'D_rsal_AD_191111.mat', ...
    'D_rsal_BC_191111.mat', ...
    'D_rsal_CD_191111.mat'} ;
%     'D_rsal_BD_191111.mat', ...


%% run calSpaceEval
for i =dataset
    fname = cell2mat(i);
    calSpaceEval;
end

        