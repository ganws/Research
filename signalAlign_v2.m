% v2 differ from original version in the algorithm for alignment.
% The selection of reference timing is based on 2 conditions as below: 
% 1) 10% of increment from previous data point
% 2) the absolute signal value (velocity) 

% GAN WEI SHENG

% ver20190211: written

%% SETTINGS
%clear, clc 

%load raw_191111.mat

function [newShotObj, ref_pos, pd, indx_rise] = signalAlign_v2 (shotObj, varIndx, rise, targetframe)
    %initialize variable
  %  R1 = targetframe(1);
   % R2 = targetframe(2);
    nSample = numel(shotObj) ;
    nVar = numel(shotObj(1).var);
    newShotObj = shotObj;
    
    dt = shotObj(1).t_indx(2)-shotObj(1).t_indx(1) ; % sampling period
    
    %% find signal rise index
    findRise = @(x) findSignalRise(shotObj(x).var{1}, rise, targetframe);
    indx_rise = arrayfun(findRise, 1:nSample);
    [~, pd] = arrayfun(findRise, 1:nSample, 'UniformOutput', false);
    
    % select reference shot
    [ref_pos, ref_sample] = min(indx_rise);
    ref_velocity = shotObj(ref_sample).var{1}(ref_pos);
    
    % find data point that is cloesest to reference velocity
    for n = 1:nSample
        diff_tmp = abs((shotObj(n).var{1}((indx_rise(n)-3):(indx_rise(n)+3)) - ref_velocity)./ref_velocity);
        [~, new_indx_rise] = min(diff_tmp);
        if new_indx_rise < 4
            indx_rise(n) = indx_rise(n) - (4-new_indx_rise);
        else
            if new_indx_rise > 4
                indx_rise(n) = indx_rise(n) + new_indx_rise-4;
            end
        end
    end
        
    %findLen = @(x) length(shotObj(x).var{varIndx}) ;
    %sigLen = arrayfun(findLen, 1:nSample);

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