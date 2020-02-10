% Load raw_[dataset].mat, preprocess and save to
% new matfile with name format:[preprocesslabel]_[dataset].mat'

% preprocesslabe is as the following:
% rs = rescaled
% al = aligned

% GAN WEI SHENG
% v20191206 - written
% v20191223_released - fix runtime error when there is no ID to be removed
% v20191224: return ref_pos from signalAlign function and plot a line at the timing of alignment 
% v20190208: change the ref_pos as the max within time_frame

clear;clc

%% SETTING <<==== CHANGE HERE

load raw_191111.mat
newmatname = 'rsal_191111.mat';
id_rmv = {'717201', '7003E1', 'F08370', '60A2C0'}; %ID to be removed %F08370

%select preprocess (true=yes, false=no)
isAligned = true; %signal alignment 
isScaled = true; %rescaling

%===signal alignment paramter===
ref_vindx = 1; %align variable index
rise = 10; %rise percentage [%]
targetFrame = [900, 1000]; % frame to be examined for signal rise

%===rescale parameter========
newRange = [0,1]; % new range, [lower bound, upper bound]

tStart = tic;
%% manual removal of outlier
if (exist('id_rmv', 'var')==0)
    id_rmv = {};
end
disp '=======REMOVING OUTLIER======';
newsample = rmvSample(sample, id_rmv) ;
[classSize, nSample] = updateSize(classLabel, newsample);

%% signal rise alignment 

if isAligned == true
    disp '=======ALIGNING SIGNAL======'
    [newsample, ref_pos, pd, indx_rise] = signalAlign(newsample, ref_vindx, rise, targetFrame) ;
end

%% rescaling

if isScaled == true
    disp '=======RESCALING======'
    [newsample, minval, maxval] = signalRescale(newsample, newRange) ;
end

%% plot before after

fprintf('Plotting before and after...\n')
timeAxisPlot = false; % x axis as time axis

%before
sample.plotSingleVar(ref_vindx, timeAxisPlot) ;
ax1 = gca;
hold on
plot([ref_pos, ref_pos],[ax1.YLim(1),ax1.YLim(2)], 'k-'); %plot reference timing
hold off
title('Before')

%after
newsample.plotSingleVar(ref_vindx, timeAxisPlot) ;
ax2 = gca;
hold on
plot([ref_pos, ref_pos],[ax2.YLim(1),ax2.YLim(2)], 'k-'); %plot reference timing
hold off
title('After')

%% save mat file

clear sample; 
sample = newsample;
save(newmatname, 'dataset', 'classLabel', 'classSize', 'nSample', 'nClass', ...
                               'nVar', 'varName', 'varUnit', 'sample', 'isAligned', 'isScaled', ... 
                               'minval', 'maxval');

fprintf('Succesfully saving data into %s.mat ...\n', newmatname);
tEnd = toc(tStart);
fprintf('Time Elapsed: %f s\n', tEnd);


