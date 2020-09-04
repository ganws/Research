% Evaluate resampling method
% Evaluate interpolation methods (spline, pchip, linear) used in
% resampling of an artificially-induced non-uniformly sampled time series
% data against its original data by RMSE.

clear;clc

% rand seed for reproducibility purpose
rng(1)
s = RandStream('mlfg6331_64'); 
%% load original

load raw_191111.mat % this data set has a uniformly sampled data

y_ori = sample(1).var{1}; % velocity data of sample1
Fs = 400; %400 Hz
t_ori = 0:1/Fs:(length(y_ori)-1)*1/Fs;

%% artificially induce missing values

missingFraction = 0.2; % fraction of missing values
indx = randsample(s, 2, length(y_ori), true, [missingFraction, 1-missingFraction]); % 1 = missing value, 2 = preserved

% make sure data length stays the same
indx(1) = 2;
indx(end) = 2;

% create data with missing values
y_miss = y_ori(indx==2);
t_miss = t_ori(indx==2);

disp(" Ratio of modified length to originial length = "+length(y_miss)/length(y_ori))

%% resampling
% use resample function
% imethod = {'linear', 'spline', 'pchip'};
% pstyle = {':', '-.', '--'};
% 
% y_resampled = zeros(length(y_ori), length(imethod));
% t_resampled = zeros(length(y_ori), length(imethod));
% 
% figure
% plot(t_ori, y_ori, 'DisplayName', 'original', 'LineWidth', 2)
% hold on
% plot(t_miss, y_miss, 'o', 'DisplayName', 'sampled points') 
% for i = 1:length(imethod)
%     
%     [ynew, tnew] = resample(y_miss, t_miss, Fs, 1,1, imethod{i});
%     rmse(i) = sqrt(sum(((y_ori - ynew).^2))./length(y_ori));
%     plot(tnew, ynew, pstyle{i} ,'DisplayName', imethod{i});
%     
%     y_resampled(:,i) = ynew;
%     t_resampled(:,i) = tnew;
%     disp("RMSE of "+ imethod{i} +"= "+ rmse(i))
% end
% 
% legend('show')

%% interpolation
% use interpolation function to evaluate makima because resample() doesnt 
% take in makima as method
% repeat the experiment N times and take the average

imethod = {'linear', 'spline', 'pchip', 'makima'};
pstyle = {':', '-.', '--', '-.'};

y_resampled = zeros(length(y_ori), length(imethod));
t_resampled = zeros(length(y_ori), length(imethod));

figure
plot(t_ori, y_ori, 'DisplayName', 'original', 'LineWidth', 2)
hold on
plot(t_miss, y_miss, 'o', 'DisplayName', 'sampled points') 
for i = 1:length(imethod)
    
    ynew = interp1(t_miss, y_miss, t_ori, imethod{i});
    tnew = t_ori;
    rmsex = sqrt(sum(((y_ori - ynew').^2))./length(y_ori));
    plot(tnew, ynew, pstyle{i} ,'DisplayName', imethod{i});
    
    y_resampled(:,i) = ynew;
    t_resampled(:,i) = tnew;
    disp("RMSE of "+ imethod{i} +"= "+ rmsex)
end
legend('show')
