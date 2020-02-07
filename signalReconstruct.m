% Signal reconstruction for 1variable

% GAN WEI SHENG
% v20191206 - written
% v20191223_released - modified
clear;
%% SETTINGS

load D_rsal_AC_191111.mat
%load D_rsal_171120_0.mat

pcselect = 1:2; %select pc to reconstruct
varSelect =8; %reconstruct variable
%% SVD

newIndex = [indx_var{varSelect}];
D = D(newIndex,:);

[U, S, V] = svd(D); %SVD

% Reconstruct
Drecon =U(:,pcselect)*S(pcselect, pcselect)*V(:,pcselect)';

DzOKmean = mean(Drecon(:,indx_class{1}),2);
DzNGmean = mean(Drecon(:,indx_class{2}),2);

%% error and rescaling
% base_val = (Dz-a)*(max-min)/(b-a) + mim

minv = minval(varSelect);
maxv = maxval(varSelect);
a = 0;b = 1;

DzOKRescale =(DzOKmean-a)*(maxv-minv)./(b-a)+minv; %mean rescaled timeseries (OK)
DzNGRescale =(DzNGmean-a)*(maxv-minv)./(b-a)+minv; %mean rescaled timeseries (NG)

Error = abs(DzOKRescale-DzNGRescale);
%% plot mean OK/NG mean timeseries

figure;
plot(DzOKRescale, classLine{1})
hold on
plot(DzNGRescale, classLine{2})
plot(Error)
hold off

legend('OK mean', 'NG mean', 'difference')