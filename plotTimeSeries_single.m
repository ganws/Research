% subplot time series data of all variables for all samples
% INPUT:
%   1. D struct file
%   2. timeAxisPlt [logical] (true: xaxis as time axis, false(default): xaxis as
%   sampling instace) 
% OUTPUT:
%     1. subplot figure

% GAN WEI SHENG
% 2019/11/27


function [fig_subplt] = plotTimeSeries(Dstruct, var_indx, varargin)
    unloadStruct(Dstruct); %unload Dstruct into function workspace
    
    % set tiemAxisPlt based on 2nd input argument 
    if isempty(varargin)
        timeAxisPlt = false; %default
    else
        if length(varargin) == 1
            if isa(varargin{1}, 'logical')
                timeAxisPlt = varargin{1} ;
            else 
                error('2nd input argument must be a logical variable');
            end
        end
        if length(varargin) > 1
            error('Too many input arguments');
        end
    end
    
    fig_subplt = figure;
        for j = 1:nClass
            % x-axis as time axis
            if timeAxisPlt == true 
                dt = t_indx(2,1) - t_indx(1,1);
                tAxis = dt*frame;
                hp = plot(tAxis, D(indx_var{var_indx}, indx_class{j}),classLine{j}) ;

                xlabel('Time [s]');
            % x-axis as sampling point
            else 
                hp = plot(D(indx_var{var_indx}, indx_class{j}),classLine{j}) ;
                xlabel('Sampling point');
            end
            set(hp, {'DisplayName'}, ID(indx_class{j})'); %ID labelling
            hold on
        end
        hold off
        ylabel([varName{var_indx},' [',varUnit{var_indx}, ']']) ; 

end