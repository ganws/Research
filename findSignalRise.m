% Returns index of first point that increases more than or eql to [k]% than the previous point within frame [R1 R2].

% GAN WEI SHENG
% 2019/11/22
% ver20190208: add pd as output parameter
function [indx,pd] = findSignalRise(X,k,targetframe)
        R1 = targetframe(1);
        R2 = targetframe(2);
        pd = diff(X)./X(1:end-1) * 100;
        indx = find(pd(R1:R2)>=k,1) + R1 ;
        
        if isempty(indx)
            error('Could not find data point that increases more than %f [%%] in range [%d %d] of input vector. \n', k, R1, R2)
        end
end