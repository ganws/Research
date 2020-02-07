% short program to manually align size.

% select reference fig

%refFig = 'allmetrics_AB.fig';
refFig = '1NNScore_rsal_allvar_191111.fig';

%targetsubSet =  {'AC', 'AD', 'BC', 'BD', 'CD'};
targetsubSet = {'J', 'TPR', 'TNR'};

for i = 1:numel(targetsubSet)
    %targetFig = ['allmetrics_', targetsubSet{i}, '.fig'];
    targetFig = [targetsubSet{i}, '_rsal_allvar_191111.fig'];
    
    fig = openfig(refFig);
    refPos = fig.Position;

    fig2 = openfig(targetFig);
    fig2.Position = refPos;
    savefig(fig2, targetFig);
end