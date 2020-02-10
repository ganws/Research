% Align all samples, piston velocity as the reference frame.

% GAN WEI SHENG
% ver20191101
% ver20191206: modified into function for class Shot. 
% ver20191224: now returns ref_sample and ref_pos
% ver20190208: added 'pd' as return parameter

%% SETTINGS
%clear, clc 

%load raw_191111.mat

function [newShotObj, ref_pos, pd, indx_rise] = signalAlign (shotObj, varIndx, rise, targetframe)
    %initialize variable
    R1 = targetframe(1);
    R2 = targetframe(2);
    nSample = numel(shotObj) ;
    nVar = numel(shotObj(1).var);
    newShotObj = shotObj;
    
    dt = shotObj(1).t_indx(2)-shotObj(1).t_indx(1) ; % sampling period
    
    %% find signal rise index
    findRise = @(x) findSignalRise(shotObj(x).var{1}, rise, targetframe);
    indx_rise = arrayfun(findRise, 1:nSample);
    [~, pd] = arrayfun(findRise, 1:nSample, 'UniformOutput', false);
    [ref_pos, ref_sample] = min(indx_rise);

    findLen = @(x) length(shotObj(x).var{varIndx}) ;
    sigLen = arrayfun(findLen, 1:nSample);

    fprintf('Reference signal rise ID: %s, with signal rise time: %f [s] \n', shotObj(ref_sample).ID, shotObj(ref_sample).var{varIndx}(ref_pos));

    %% Alignment

    offset = indx_rise - ref_pos ; 

    for n = 1:nSample
        for i = 1:nVar
            newShotObj(n).var{i} = shotObj(n).var{i}(1+offset(n):end);
            newShotObj(n).t_indx = shotObj(n).t_indx(1+offset(n):end);
            newShotObj(n).Len = length(newShotObj(n).var{varIndx}); %update length
        end
    end

    fprintf('Max time offset = %f [s] \n', max(offset)*dt);
    %% plot bfore after
%{
    fprintf('Plotting velocity time series data....\n');
    subplot(2,1,1) ; %before
    for n = 1:nSample
        plot(shotObj(n).var{varIndx});
        hold on
    end
    ylabel('Velocity [m/s]')
    title('Before Alignement')
    hold off

    subplot(2,1,2) ; %after
    for n = 1:nSample
        plot(newShotObj(n).var{varIndx}, 'DisplayName', newShotObj(n).ID);
        hold on
    end
    ylabel('Velocity [m/s]')
    title('After Alignement');
    hold off    
    %}

end

%% save as mat
%{
sample = aligned_sample ;
matfname = ['aligned_', dataset]; 
save(matfname, 'dataset', 'classLabel', 'classSize', 'nSample', 'nClass', 'nVar', 'varName', 'varUnit', 'sample');
fprintf('Aligned data successfully saved as %s.mat \n', matfname); 
%}