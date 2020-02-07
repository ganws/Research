% short program to create subplot from selected fig

clear;clc;
%% Settings

dataset = '191111';
subst = 'CD';

%figure name format
figName = {['J_rsal_', subst, '_', dataset, '.fig'], ...
                   ['1NNScore_rsal_', subst, '_', dataset, '.fig'], ...
                   ['TPR_rsal_', subst, '_', dataset, '.fig'], ...
                   ['TNR_rsal_', subst, '_', dataset, '.fig']};
               
%% subplot
fnew = figure;
for i=1:numel(figName)
    fig=openfig(figName{i});
    if i == 1
        title([dataset,'\_',subst]);
    end
    ax(i) = gca;
    ax_copy(i) = copyobj(ax(i), fnew);
    subplot(numel(figName),1,i,ax_copy(i));
end
    
%% save subplot

newfname = ['allmetrics_', subst];
savefig(fnew, newfname);
