function [bSigma, classMu] = betweenClassVar(X,class_index)
% Arguments
% X             Data matrix [var x sample] size
% index      cell index.  eg classindex = [{1,2,3},{4,5,6,7}];

n = length(class_index);
for i=1:n
    classMu(:,i) = mean(X(:,class_index{i}),2);
end
sigma = var(classMu,1,2);
bSigma = sum(sigma);

% second version
totalMu = mean(X,2);