function [wSigma] = withinClassVar(X)

sigma = var(X,1,2);
wSigma = sum(sigma);

end
