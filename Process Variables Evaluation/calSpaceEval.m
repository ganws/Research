% Brute-force calculate J, kNNScore, F1, TPR for all configuration of process variable and all
% possible 2d subspace. 

% GAN WEI SHENG
% ver20181030: code written
% ver20191206: - changed name from 'Jallconfig' to 'calSpaceEval' 
%              - J [1:8], or case of all variable is also calculated
%              - added kNN evaluation value
%
%v20191223_released - modified comments

%clear;clc;
%% Setting

dir = '..\'; %directory of D matfile
fname = 'D_rsal_BD_191111.mat '; %select Dstruct dataset
load([dir,fname]); 
pcnum = 1:5; %select principal component

%knn eval parameters
k_nn = 1; % number of neighbour for 

%select cross validation method
cvMethod = 'kFold'; %kfold
%cvMethod = 'LeaveOut' %leave-one-out
k_fold = 10; %num of folds (not needed when selecting Leaveout)
%% Init

PCcombos = nchoosek(pcnum,2); %2d pc combination
PCncomb = length(PCcombos); %number of possible combination: 5C2

%preallocation
nVarCombo = zeros(1,nVar);
combos = cell(1,nVar);
Jmean = cell(1,nVar);
Jmed = cell(1,nVar);
J = combos;
NNScore = combos;
F1 = combos;
TPR = combos;
topVarJ = zeros(1,sum(1:8));
topVarJmed = zeros(1,sum(1:8));
Iter = 1;
 
datafname = ['J_', dataset] ;
%% loops 
tStart1 = tic; 

%iteration for all process variable configuration
for i=1:nVar
    nVarCombo(i) = nchoosek(nVar, i); %num of possible combination for i-var configuration
    combos{i} = nchoosek(1:nVar, i); %all possible combination for i-var configuration
    
    %iteration for all process variable combination for i-var configuration
    for j=1:nVarCombo(i)
        indexSelect = [indx_var{combos{i}(j,:)}]; %indx of selected process var
        Dtemp = D(indexSelect,:); %select process variable
        [U,S,V] = svd(Dtemp, 'econ' ); %SVD
        Uk = U(:,pcnum); 
        Dk = Uk'*Dtemp; %  dimension reduction
        
            % iteration for all subspace
             for k=1:PCncomb
                 tStart2 = tic;
                 Dk_2pc = Dk(PCcombos(k,:),:); % 2dimension D_tmp
                
                 %calculate evalation value
                 J{i}(j,k) = calculateJ(Dk_2pc,indx_class); %J
                 [NNScore{i}(j,k), F1{i}(j,k),TPR{i}(j,k), TNR{i}(j,k)] = calculatekNN(Dk_2pc,Y,k_nn,cvMethod,k_fold);
                 
                 tEnd2 = toc(tStart2);
                 fprintf('Iter = %d, time elapsed = %f .\n', Iter, tEnd2);
                 Iter = Iter + 1;
            end
    end
    
    % evaluate using mean
    %{
    Jmean{i} = mean(J{i},2); 
    [maxJ, index] = max(Jmean{i});
    tmp = sum(1:(i-1))+1;
    if i == 1, tmp  =1 ; end
    topVarJ(1,tmp:tmp+i-1) = combos{i}(index,:);
       
     % evaluate using median     
    Jmed{i} = median(J{i},2);
    [maxJmed, indexmed] = max(Jmed{i});
    topVarJmed(1,tmp:tmp+i-1) = combos{i}(index,:);
    %}
end
tEnd1 = toc(tStart1);
fprintf('...\n...\n');
fprintf('TOTAL EVALUATED SUBSPACE NUMBER = %d\n',sum(nVarCombo*10));
fprintf('TOTAL TIME ELAPSED = %f \n', tEnd1);
%% plot histrogram
%mean
%{
figure;
histogram(topVarJ);
title('Important Variable in terms of Jmean')
xlabel('Var')
ylabel('Frequency')

%median
figure;
histogram(topVarJmed);
title('Important Variable in terms of Jmedian')
xlabel('Var')
ylabel('Frequency')
%}

%% save mat

newmatname = ['eval_', fname]; % add 'eval' as prefix to D matfile
save(newmatname, 'J', 'combos', 'NNScore', 'F1', 'TPR', 'TNR') ;

fprintf('Successfully saved calculated evaluation value in %s. \n', newmatname);