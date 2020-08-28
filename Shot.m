classdef Shot
% contains sensor data and properties for each shot
%
% v20191206: written
% v20191223_released: removed 'Defect' property
% v20191224: added OHleak, total flow volume as parameter in property.
% v20200828: added PT parameter
    
    properties
        ID
        class
        PT
        t_indx
        var
        Len
        isNaN
        isInf
        varName
        varUnit
        OHleak
        flow_vol
    end

methods
    function [fig] = plotSingleVar(shotObj, varindx, timeAxisPlot)
        nSample = numel(shotObj);
        dt = shotObj(1).t_indx(2) - shotObj(1).t_indx(1); %sampling period

        %plot
        fig = figure;
                
        for i= 1:nSample
                    
            %line color based on class label
            if strcmp(shotObj(i).class, 'A'), class_color = 'b-'; end %blue
            if strcmp(shotObj(i).class, 'B'), class_color = 'm-'; end %magenta
            if strcmp(shotObj(i).class, 'C'), class_color = 'r-'; end %red
            if strcmp(shotObj(i).class, 'D'), class_color = 'r-'; end %red
            
            if timeAxisPlot == true %plot with time axis
                tAxis = 0:dt:dt*(shotObj(i).Len-1); %create time axis
                plot(tAxis, shotObj(i).var{varindx}, class_color, 'DisplayName', shotObj(i).ID) 
                xlabel('Time [s]');
            else %plot with data points
                plot(shotObj(i).var{varindx}, class_color,'DisplayName', shotObj(i).ID)
                xlabel('Sampling point');
            end
            ylabel([shotObj(i).varName{varindx}, ' [', shotObj(i).varUnit{varindx}, ']']);
            hold on;
        end
    hold off

    end
end
            
    
    
end

