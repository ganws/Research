% plot rmse results from 'evaluation multiple run'

fname = {'frac_01', 'frac_02', 'frac_03', 'frac_04', 'frac_05', 'frac_06', 'frac_07', 'frac_08'};

frac = 0.1:0.1:0.8; % fraction of missing values

% load and plot
figure
for n = 1:length(fname)
    data = load(fname{n}, '-mat');
    rmse_mean(n,:) = data.RMSE_mean;
    rmse_std(n,:) = data.RMSE_std;
end


figure
hold on
for i = 1:length(data.imethod)
    errorbar(frac, rmse_mean(:,i), rmse_std(:,i), 'DisplayName',data.imethod{i})
end
legend('show')