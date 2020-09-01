% resampling the whole dataset to desired sample rate and save into new mat files

% Gan Wei Sheng
% 20200901 - written


clear;clc;
load raw_200826.mat

%% Frequency components for all samples
% compare the highest and lowest freq components for all samples
% to decide the desired frequency

for i = 1:length(sample)
    fs = 1./diff(sample(i).t_indx);
    maxFs(i) = max(fs);
    minFs(i) = min(fs);
end

% plot max frequency components for all samples
figure
plot(maxFs, '.')
title("Max Frequency Component")
xlabel("Sample #")
ylabel("Sample rate [Hz]")

% plot min frequency components for all samples
figure
plot(minFs, '.')
title("Min Frequency Component")
xlabel("Sample #")
ylabel("Sample rate [Hz]")

fprintf("Highest freq component = %f [Hz], \nlowest freq component = %f [Hz]\n", max(maxFs), min(minFs))

%% Test single shot
%Try a single sample shot before performing resampling

sampleidx = 1;

t = sample(sampleidx).t_indx;
var = sample(sampleidx).var{2}; % variable to test
tmp = find(strcmp(sample(sampleidx).PT, 'T'));
ptidx = tmp(1);

fs = 1./diff(t);
fs = [0;fs];

fprintf("Highest freq component = %f [Hz], \nlowest freq component = %f [Hz]\n", max(fs), min(fs))

fig = figure;
yyaxis left
plot(var);
hold on % plot P-T sample rate transition
plot([ptidx, ptidx],[0, fig.Children.YLim(2)]);
yyaxis right
plot(fs/1000)
title("Speed-Data Points")
xlabel("Data point")
ylabel("Speed [m/s]")
legend("Speed", "P-T transition", "Sample rate")

fig2 = figure;
yyaxis left
plot(t, var) % injection speed-time graphc
hold on
plot([t(ptidx), t(ptidx)],[0, fig2.Children.YLim(2)]);
yyaxis right
plot(t, fs/1000) %samplerate-time graph
ylabel("Sample Rate [kHz]")

xlabel("Time [s]")
title("Speed-Time")
legend("Speed", "P-T transition", "Sample rate")

% resampling
desiredFs = 10000;
[varnew_linear, tnew_linear] = resample(var, t, desiredFs, 1,1, 'linear');
[varnew_pchip, tnew_pchip] = resample(var, t, desiredFs, 1,1, 'pchip');
[varnew_spline, tnew_spline] = resample(var, t, desiredFs, 1,1, 'spline');

figure
plot(t, var, 'o', tnew_linear, varnew_linear, '.-')
title("linear")
legend("original", "resampled");

figure
plot(t, var, 'o', tnew_pchip, varnew_pchip, '.-')
title("pchip")
legend("original", "resampled");

figure
plot(t, var, 'o', tnew_spline, varnew_spline, '.-')
title("spline")
legend("original", "resampled");

%% Resampling
% resample whole dataset
desiredFs = 10000;

for i = 1:length(sample)
    for j = 1:length(sample(i).var)
        [sample(i).var{j}, tnew] = resample(sample(i).var{j}, sample(i).t_indx, desiredFs, 1,1, 'pchip');
    end
    sample(i).t_indx = tnew;
    sample(i).Len = length(tnew);
end

save('resampled_pchip_200826.mat', '-v7.3', ...
     'sample', 'classLabel', 'classSize', 'dataset', 'nClass', ...
     'nSample', 'nVar', 'sample', 'varName', 'varUnit'...
    ); 
%% 