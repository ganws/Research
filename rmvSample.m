% program to manually remove sample and update database info

% GAN WEI SHENG
% ver20191101
% ver20191206: modified into a function, changed function name from 'removeOutlier' to 'rmvSample'
%% SETTINGS

function [newshotObj] = rmvSample(shotObj, id_rmv)
    newshotObj = shotObj;
    % remove id from database
    totalRmv = 0 ;
    for i = 1:numel(id_rmv)
        ind_outlier = find2(newshotObj, 'ID', id_rmv{i}) ; 
        if ~isempty(ind_outlier)
            class = newshotObj.class;
            newshotObj(ind_outlier) = [];
            totalRmv  = totalRmv + 1; 
            fprintf('Sample [%s], class [%s] is removed from data base. \n', id_rmv{i}, class) ;
        else 
            fprintf('Sample [%s] is not found in the database. \n', id_rmv{i} ) ; 
        end
    end

    %% update database info
    fprintf('Total num removed: %d \n', totalRmv);
    fprintf('New class sizes after manual removal of outliers: \n') ;
end