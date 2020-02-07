% evaluate J, kNNScore, TPN, TNR for each single dimension of Dk

clear;clc;

% GAN WEI SHENG
% ver20191206 written
%% SETTINGS <=== CHANGE HERE

load('D_rsal_AC_191111.mat') ;
nMode = 108; %result from plotSingularValues (when cumulative S > 70%)
newmatfname = 'AB_eval1PC_VAR3.mat' % matfile to save the result

varCombo = 3; %variable configuration

% kNN evaluation parameter
cvMethod = 'kFold'; %cross validation method
k_fold = 10; % num of fold in kfold method

k_nn = 5; %num of neighbour
%% init

newIndex = [indx_var{varCombo}]; %select index based on variable configuration

D = D(newIndex,:);

%preallocation
NNScore = zeros(nMode,1);
F1 = NNScore;
TPR = NNScore;
TNR = NNScore;
J =  NNScore;

%% SVD and dimension reduction

[U, S, V] = svd(D, 'econ'); %svd

%dimension reduction
Uk = U(:,1:nMode); %reduce to nMode-dimension
Dk = Uk'*D; % D in lower dimension

%% Evaluate all mode

for mode = 1:nMode
    fprintf('Evaluating %dth mode...\n', mode);
    Dtmp = Dk(mode, :);
    J(mode) = calculateJ(Dtmp,indx_class); %J
    [NNScore(mode), F1(mode),TPR(mode), TNR(mode)] = calculatekNN(Dtmp,Y,k_nn,cvMethod,k_fold); % TNR, TPR
end

%% sort and find the top 1 PC for all evaluation metrics

[J , PC_J] = sort(J, 'descend');
[NNScore , PC_NNS] = sort(NNScore, 'descend');
[F1 , PC_F1] = sort(F1, 'descend');
[TPR , PC_TPR] = sort(TPR, 'descend');
[TNR , PC_TNR] = sort(TNR, 'descend');

%% plot bar graph

figure;
bar(J);
title('J');
%set(gca, 'XTick',1:length(diag_s));

figure;
bar(TPR);
title('TPR');

figure;
bar(TNR);
title('TNR');

%% save data

save(newmatfname, 'Dk', 'J', 'NNScore', 'TPR', 'TNR', 'F1', 'PC_J', 'PC_NNS', 'PC_F1', 'PC_TPR', 'PC_TNR');