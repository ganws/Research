% Perform svd on selected process varialbe and plot all possible 
% combination of 2d spaces.

% GAN WEI SHENG
% v20191206 - created
% v20191223_released - changed name from 'test' to 'svdPlot'

clear;clc;
%% Setting

Dstruct = load('D_rsal_AC_191111.mat') ; %load Dmatrix
%Dstruct = load('D_rsal_171120_0.mat') ; %load Dmatrix

pcmode = 5; %number of pc to examine
varCombo = [1]; %combination of process variable
SVDmode= 0; % 0=svd(D_all), 1=svd(D_class1), 2=svd(D_class2)

[J,Dk,U,V,S] = plotPC(Dstruct, pcmode,varCombo,SVDmode) ; %svd and plot