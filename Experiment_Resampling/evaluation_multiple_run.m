% Evaluate interpolation methods for resampling
% repeat the experiment N times
clear;clc

% experiment settings
N = 10; % repeat N times
missingFraction = 0.8; % fraction of missing values

imethod = {'linear', 'spline', 'pchip', 'makima'}; % methods to compare
pstyle = {':', '-.', '--', '-.'}; % plot style

%% load original

load raw_191111.mat % this data set has a uniformly sampled data

y_ori = sample(1).var{1}; % velocity data of sample1
Fs = 400; %400 Hz
t_ori = 0:1/Fs:(length(y_ori)-1)*1/Fs;

%% artificially induce missing values

for n = 1:N
    
    rng(n); % for reproducibility for each experiment index. 
    s = RandStream('mlfg6331_64'); 
    indx = randsample(2, length(y_ori), true, [missingFraction, 1-missingFraction]); % 1 = missing value, 2 = preserved

    % make sure data length stays the same
    indx(1) = 2;
    indx(end) = 2;

    % create data with missing values
    y_miss = y_ori(indx==2);
    t_miss = t_ori(indx==2);
    
    % preallocation
    y_resampled = zeros(length(y_ori), length(imethod));
    t_resampled = zeros(length(y_ori), length(imethod));
     
    % perfrom interpoation and calculate rmse for each method
    for i = 1:length(imethod)

        ynew = interp1(t_miss, y_miss, t_ori, imethod{i});
        tnew = t_ori;
        RMSE(n,i) = sqrt(sum(((y_ori - ynew').^2))./length(y_ori));

        y_resampled(:,i) = ynew;
        t_resampled(:,i) = tnew;
    end

    RMSE_mean = mean(RMSE);
    RMSE_std = std(RMSE);
end

% save exp data
frac = num2str(missingFraction);
save(['frac_0', frac(3), '.mat'], 'RMSE', 'RMSE_mean', 'RMSE_std', 'imethod');
