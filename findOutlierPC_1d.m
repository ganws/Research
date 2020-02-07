% program to find outlier samples in 1d PC spaces. 

% GAN WEI SHENG
% ver20191224: written

clear;clc;
%% SETTINGS

load D_rsal_AC_191111.mat

varCombo = [3]; %select process variable
pcCombo = [1,2]; %select principal component

sd_threshold = 3; % samples that lie within mean+-sd_threshold*sigma is considered normal

%% SVD

newIndex = [indx_var{varCombo}]; %create new index

Dnew = D(newIndex, :) ;
[U,S,V] = svd(Dnew) ;

%singular value
diag_S = diag(S);  
sumS = sum(diag_S);
pc1_percent = diag_S(pcCombo(1))/sumS * 100; %pc 1 singular value percentage
pc2_percent = diag_S(pcCombo(2))/sumS * 100; %pc 2 singular value percentage

Uk = U(:,pcCombo); %PCA
Dk = Uk'*Dnew;

%% find outlier

outlier_id = cell(numel(classLabel),numel(pcCombo)); %row: class, column: pc
outlier_indx = cell(numel(classLabel),numel(pcCombo)); 

for i = 1:numel(classLabel) %iterate for class
    for j = 1:numel(pcCombo) %iterate for PC
        class_mean = median(Dk(j, indx_class{i}));
        class_std = std(Dk(j, indx_class{i}));
        class_threshold = [class_mean - sd_threshold*class_std, class_mean + sd_threshold*class_std];
        outlier_indx{i,j} = Dk(j, indx_class{i})<class_threshold(1) | Dk(j, indx_class{i}) >class_threshold(2);
        outlier_id{i,j} = ID(outlier_indx{i,j});
        
        %draw
        fig = figure;
        ax=fig.Children;
        plot(Dk(j, indx_class{i}), 0, classMarker{i});
        hold on
        %xlim([class_mean - (sd_threshold+1)*class_std, class_mean + (sd_threshold+1)*class_std]); %always show +-1 than threshold std
        ylim([-1,1]);
        
        %plot med and threshold
        plot([class_mean,class_mean], [1,-2], 'k-', 'LineWidth', 2)
        plot([class_threshold(1),class_threshold(1)], [1,-1], 'k--'); %lower threshold
        plot([class_threshold(2),class_threshold(2)], [1,-1], 'k--'); %upper threshold
        hold off
        xlabel(['PC ', int2str(j)]);
        title(classLabel{i});
    end
end

