% Rescale all variable to new range [a,b], while preserving the relative value of all
% data points between samples.
% rescale equation: 
% Xnew = a + (b-a)*(X-min)/(max-min)
%---------------------------
% INPUT
% 1) shotObj: shot class objects
% 2) newRange = [a,b] : 1x2 vector specifying new range
%
% OUTPUT
% 1) newShotObj: rescaled shotObj
% 2) minval: coutaining minimum value of each variable
% 2) maxval: coutaining maximum value of each variable
%---------------------------
% GAN WEI SHENG
% ver20191206

function [newShotObj, minval, maxval] = signalRescale(shotObj, newRange)
    a = newRange(1); %lower bound
    b = newRange(2);; %upper bound
    newShotObj = shotObj;
    nSample = numel(shotObj);
    nVar=numel(shotObj(1).var);
    minval = zeros(1,nVar);
    maxval = zeros(1,nVar);

    %find min and max
    for i=1:nVar
        minval(i) = min(shotObj(1).var{i}); %initialize
        maxval(i) = max(shotObj(1).var{i}); %initialize
        for j=1:nSample
            tmpmin = min(shotObj(j).var{i});
            tmpmax = max(shotObj(j).var{i});
            if tmpmin<minval(i), minval(i) = tmpmin; end
            if tmpmax>maxval(i), maxval(i) = tmpmax; end
        end
    end
    
    %rescale
    for i = 1:nVar
        for j = 1:nSample
            tmp= shotObj(j).var{i};
            tmp = a + (b-a)*(tmp-minval(i))./(maxval(i)-minval(i)); %rescale equation
            newShotObj(j).var{i} = tmp;
        end
    end
fprintf('Signal succesfully rescaled to [%d %d] \n', a,b) ;
end