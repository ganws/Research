% evaluate datasubset of 191111 in terms of mean J, NNScore, TPR, TNR when all processs variable are used.
% Load results stored in mat file that was calculated from calSpaceEval.m program.
% Read matfile name format example: eval_D_rsal_AB_191111.mat
% save figure as eg: [metric]_[preprocess]_allvar_191111.fig, where 
% metric = {J, TPR, TNR, 1NNScore}, [preprocess] = {rsal, rs}

% GAN WEI SHENG
% ver20191206 written

clear;clc;

%% Settings

%select data subset to compare
subset = {'AB', 'AC', 'AD', 'BC', 'BD', 'CD'};
                    
nSubset = numel(subset); %number of subsets
metricName = {'J', '1NNScore', 'TPR', 'TNR'};% specify evaluation metrics name

figname_suffix = 'rsal_allvar_191111.fig';

%{
barColor = [0.6350, 0.0780, 0.1840; ... % AB - dark red
                    0.3010, 0.7450, 0.9330; ...% AC - light blue
                    0.4660, 0.6740, 0.1880; ... % AD - green
                    0.4940, 0.1840, 0.5560; ... % BC - purple
                    0.9290, 0.6940, 0.1250; ... % BD - tangerine yellow
                    0.8500, 0.3250, 0.0980] ;% CD - orange
%}

%define bar color using colormap
barColor = lines;
barColor = barColor(1:nSubset, :);

%% initialization

pcnum = 1:5;
PCcombos = nchoosek(pcnum,2); %pcCombo

%allocation
evalMetric{4} = zeros(nSubset, length(PCcombos)); %cell array to  store all metric values from all datasets
%% gather metric values from all subsets

for n=1:nSubset
    fname = ['eval_D_rsal_', subset{n}, '_191111.mat'];
    tmp = load(fname, 'J', 'NNScore', 'TPR', 'TNR');
    %metric{8} contains the SVD results when all process variable is used
    evalMetric{1}(n,:) = tmp.J{8};  %J
    evalMetric{2}(n,:)  = tmp.NNScore{8};  %J
    evalMetric{3}(n,:)  = tmp.TPR{8};  %J
    evalMetric{4}(n,:)  = tmp.TNR{8};  %J
end

%% plot bar graph - 1 figure for each metric

for i=1:numel(metricName)
    Vmean = mean(evalMetric{i},2); %mean evaluation value for each dataset
    %[Vmsort,idx] = sort(Vmean, 'descend'); %sortJ

    % plot bar graph of mean evalv
    fig = figure;
    %bar(Vmsort, 'FaceColor', barColor{i});
    bbar = bar(Vmean);
    
    %change face color
    bbar.FaceColor = 'flat'; %set to 'flat' so that the chart uses the colors defined in the CData property.
    bbar.CData = barColor; %change facecolor to the one defined in setting
    
    ax = fig.Children;
    ax.XTickLabel = subset;

    % plot all individual pc on top of bar
    hold on
    %Vsort = evalMetric{i}(idx,:); 
    %plot(Vsort, 'k.', 'MarkerSize', 10)
    plot(evalMetric{i}, 'k.', 'MarkerSize', 10)
    hold off
   
%{
    % find top 3  pc
    [Vtop3, Loc] = max(evalMetric{i}(:),3); %top 3
    varIdx = rem(Loc,nVar); %top3 var indx
    for k = 1:numel(varIdx) %if remainder = 0 -> idx = nVar
        if varIdx(k) == 0
            varIdx(k) = nVar;
        end
    end
    pcIdx = (Loc-varIdx)./nVar+1; %top 3 pc indx
    %}

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
