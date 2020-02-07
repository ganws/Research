% process variable evaluation based on result calculated from
% calSpaceEval.m

% GAN WEI SHENG
% ver20191206: code written

%% SETTINGS

fname = 'eval_D_rsal_AB_191111.mat';
figname_suffix = 'rsal_AB_vALL_191111'; %save figure name suffix

load(fname);

%select evaluation value
evalMetric{1} = J{1}; 
evalMetric{2} = NNScore{1};
evalMetric{3} = TPR{1};
evalMetric{4} = TNR{1};

% specify evaluation metrics name
metricName = {'J', '1NNScore', 'TPR', 'TNR'};
barColor = {[0.8500 0.3250 0.0980], ... %orange
                   [0.4660 0.6740 0.1880], ... %dark green
                   [0 0.4470 0.7410], ...  %dark blue
                   [0.4940 0.1840 0.5560]} ; %purple

%% Init
pcnum = 1:5;
PCcombos = nchoosek(pcnum,2); %pcCombo
nVar  = size(J{1},1);

%% evaluate process variable

for i=1:numel(evalMetric)
    Vmean = mean(evalMetric{i},2); %mean evaluation value for each variable
    [Vmsort,idx] = sort(Vmean, 'descend'); %sortJ

    % plot bar graph of mean evalv in descending order
    fig = figure;
    bar(Vmsort, 'FaceColor', barColor{i});
    ax = fig.Children;
    ax.XTickLabel = num2str(idx);

    % plot all individual pc on top of bar
    hold on
    Vsort = evalMetric{i}(idx,:); 
    plot(Vsort, 'k.', 'MarkerSize', 10)
    hold off
   
    % find top 3  pc
    [Vtop3, Loc] = maxk(evalMetric{i}(:),3); %top 3
    varIdx = rem(Loc,nVar); %top3 var indx
    for k = 1:numel(varIdx) %if remainder = 0 -> idx = nVar
        if varIdx(k) == 0
            varIdx(k) = nVar;
        end
    end
    pcIdx = (Loc-varIdx)./nVar+1; %top 3 pc indx

    %{
    % label top 3 pc
    for j = 1:3
        xloc = find(idx==varIdx(j));
        yloc = evalMetric{i}(varIdx(j),pcIdx(j));
        pclabel = ['PC',erase(num2str(PCcombos(pcIdx(j),:)), ' ')]; %remove whitespace in joining char
        text(xloc+0.2,yloc,pclabel);
    end
    %}
    
    % modify axis
    ylabel(metricName{i});
    xlabel('Variable #');
    if i~=1
        ylim([0,1]);
    end
    
    %save fig
    savefig(fig, [metricName{i},'_',figname_suffix]);
    
    
end