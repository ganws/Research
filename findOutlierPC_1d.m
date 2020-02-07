% program to find outlier samples in 1d PC spaces. 

% GAN WEI SHENG
% ver20191224: written

clear;clc;
%% SETTINGS ==> change here

load D_rsal_AC_191111.mat

varCombo = [3]; %select process variable
pcCombo = [1,2]; %select 2 principal component

sd_threshold = 3; % samples that lie within mean+-sd_threshold*sigma is considered normal
mode = 1; %mode to represent data center. [mean = 0, median = 1];

%% check error

if (numel(pcCombo)>2)
    error('Please choose only 2 principal components');
elseif (numel(pcCombo)<2)
    error('You need more principal components');
end

if (~(mode==1 | mode==2))
    error('Mode can only be 1 or 2');
end

fprintf('threshold is set to +- %.2f std from data center\n', sd_threshold);
    
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
    
        if (mode==1)
            class_mean = mean(Dk(:, indx_class{i}), 2);
            if(i==1) fprintf('Mode = %d: the center of dataset is represented by the mean\n', mode); end
        elseif (mode==2)
            class_mean = median(Dk(:, indx_class{i}), 2);
            if(i==1) fprintf('Mode = %d: The center of dataset is represented by the median\n', mode); end
        end
        class_std = std(Dk(:, indx_class{i}), 0, 2);
        class_threshold = norm(sd_threshold*class_std);
        outlier_indx{i} = vecnorm(Dk(:, indx_class{i})-class_mean) > class_threshold;
        outlier_id{i} = ID(outlier_indx{i});
        
        %draw
        fig = figure;
        ax=fig.Children;
        plot(Dk(1, indx_class{i}), Dk(2, indx_class{i}), classMarker{i});
        hold on
        %xlim([class_mean - (sd_threshold+1)*class_std, class_mean + (sd_threshold+1)*class_std]); %always show +-1 than threshold std
        %ylim([-1,1]);
        
        %plot med and threshold
        theta=0:0.1:2*pi;
        trs_x = (class_threshold)*cos(theta)+class_mean(1);
        trs_y = (class_threshold)*sin(theta)+class_mean(2);
        plot(trs_x, trs_y, 'k--');
%         plot([class_mean,class_mean], [1,-2], 'k-', 'LineWidth', 2)
%         plot([class_threshold(1),class_threshold(1)], [1,-1], 'k--'); %lower threshold
%         plot([class_threshold(2),class_threshold(2)], [1,-1], 'k--'); %upper threshold
%         hold off
        xlabel(['PC ', int2str(pcCombo(1))]);
        xlabel(['PC ', int2str(pcCombo(2))]);
        title(classLabel{i});
end

