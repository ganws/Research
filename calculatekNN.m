% calculate kNN score, F-score by cross validation (ONLY FOR BINARY CLASSIFICATION)
% ARGUMENTS
%   1) Dk: observed variables 
%   2) Y: class labels 
%   3) k: number of neigbours
%   4) cv-method: cross validation method:
%       {'kFold, k} name-value pair or 
%       {'LeaveOut'} for leave-one-out 
%           
% RETURNS
%	1) kNNScore: mean accuracy for all folds
%   2) F1Score: mean F1score for all folds
%   3) TPR: true positive rate
%   4) TNR: true negative rate
%   5) C: cell containing results of all confusion matrices for all folds

% ver20191209:- expanded functionality. changed function name from  'kNN_cv_error' -> 'calculatekNN'
%             - plot CV results figure

function [kNNScore,F,TPR,TNR,C] = calculatekNN(Dk, Y, numOfNeighbour, varargin)
%% init
    classLabel = unique(Y);
    nClass = numel(classLabel);
    Dk = Dk'; % consistent with fitcknn input argument where each row corresponds to one sample.
    
    % cross-validation method settings
    switch varargin{1}
        case 'kFold'
            if ~isempty(varargin{2})
                CV = cvpartition(Y, 'kFold', varargin{2});
            else 
                error('Please specify the number of folds, k in {''kFold'', k} name-pair argument.');
            end
        case 'LeaveOut'
            CV = cvpartition(Y, 'LeaveOut');
    end
    nFold = CV.NumTestSets;
    
    %preallocation
    C{nFold} = zeros(nClass, nClass) ; %confusion mat
    fold_score= zeros(1,nFold);
    fold_F = zeros(1,nFold); 
    fold_TPR = zeros(1,nFold);
    fold_TNR = zeros(1,nFold);
%% kNN cross-validation
       
    % iteration for each fold
    for k = 1:nFold
        trIndx = CV.training(k);
        teIndx = CV.test(k);
        
        %trainig set
        Dtrain = Dk(trIndx,:);
        Ytrain = Y(trIndx);
        
        %testing set
        Dtest = Dk(teIndx,:);
        Ytest = Y(teIndx);
        
        Mdl = fitcknn(Dtrain, Ytrain, 'NumNeighbors', numOfNeighbour);
      
        % Cross validation evaluation of kth fold.
        Label = predict(Mdl, Dtest);
        C{k} = confusionmat(Ytest, Label, 'order', flip(classLabel)); %confusion matrix for kth-fold, flip the order so that 'NG' is first index.
        TP = C{k}(1,1); % true positive
        FP = C{k}(2,1); % false positive 
        FN = C{k}(1,2); % false negative
        TN = C{k}(2,2); % true negative
        
        % Evaluation value
        Prec = TP/(TP+FP); % precision
        fold_TPR(k) = TP/(TP+FN); % recall or true positve rate
        fold_TNR(k) = TN/(TN+FP); % specificity or true negative rate
        fold_score(k) = (TP+TN)/(TP+FP+FN+TN); %accuracy
        fold_F(k) = 2/(1/Prec + 1/fold_TPR(k)); % F1-measure
        
        
        % vizualize prediction when k-fold = 1
        %{
        figure
        %plot train data
        plot(Dtrain(strcmp(Ytrain,classLabel{1}),1), Dtrain(strcmp(Ytrain,classLabel{1}),2), 'b.', 'MarkerSize', 13);% train data points of class 1
        hold on
        plot(Dtrain(strcmp(Ytrain,classLabel{2}),1), Dtrain(strcmp(Ytrain,classLabel{2}),2), 'r.', 'MarkerSize', 13);%  train data points of class 2
        
        %plot test data
        plot(Dtest(strcmp(Ytest,classLabel{1}),1), Dtest(strcmp(Ytest,classLabel{1}),2), 'bo', 'MarkerSize', 4);%  test data points of class 1
        plot(Dtest(strcmp(Ytest,classLabel{2}),1), Dtest(strcmp(Ytest,classLabel{2}),2), 'ro', 'MarkerSize', 4);%  test data points of class 2
        
        %plot neighbour of test data
        %[n2,d2] = knnsearch(Dtrain,Dtest,'k', numOfNeighbour);
        %plot(Dtrain(n2,1),Dtrain(n2,2),'o','Color',[.5 .5 .5],'MarkerSize',10)
     
        %mark result of prediction
        plot(Dtest(strcmp(Ytest,Label'),1), Dtest(strcmp(Ytest,Label'),2), 'go', 'MarkerSize', 10); %mark correctly labelled sample
        plot(Dtest(~strcmp(Ytest,Label'),1), Dtest(~strcmp(Ytest,Label'),2), 'ro', 'MarkerSize', 10); %mark wrongly labelled sample

        hold off
        legend(['Train\_',classLabel{1}]', ...
                ['Train\_',classLabel{2}], ...
                ['Test\_',classLabel{1}], ...
                ['Test\_',classLabel{2}], ...
                'Correct Label', 'Wrong Label');
        %}
        
        %fprintf('k_fold = %d: accuracy = %f, TPR = %f \n', k, fold_score(k), fold_TPR(k));      
    end
    
    %calculate evaluation score.
    kNNScore = mean(fold_score); %mean kNNScorek
    F = mean(fold_F); %mean F1measure
    TPR = mean(fold_TPR);
    TNR = mean(fold_TNR);
    fprintf('Average accuracy = %f, average TPR = %f \n', kNNScore, TPR);    
end