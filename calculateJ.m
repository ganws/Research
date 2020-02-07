function [J, Jw,bSigma,meanSig] = calculateJ(D,indx_class)
%calculate J with argument input D and indxSet
%
    n = length(indx_class);
    wSigmaSum = 0;
    wSigma = zeros(1,n);
    for i=1:n
        wSigma(i) = withinClassVar(D(:,indx_class{i}));
    end
    wSigmaSum  = sum(wSigma);
    meanSig = wSigmaSum/n;
    bSigma = betweenClassVar(D,indx_class);
    J = bSigma/meanSig;
    
    deltaS = abs(wSigma(1)-wSigma(2));
    Jw = deltaS/wSigmaSum;
    
end

