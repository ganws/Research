function [J,Dk,U,V,S] = plotPC(track, pcnum,varCombo,mode)
% Function to subplot combinations of graphs on different principal axes, with option to filter undesired variables on original data set.
% Input argument:
% track = structure array consisting Dz and D (data matrix), indx_class, indx_var
% pcnum = total number of principal axes to be plotted. total num of graph = nchoosek(pcindex,2)
% plotStyle = eg. {'bo', 'rx'}
% varCombo[row vector] = variables to be retained during SVD. eg. [1:8] -> retain all 8 variables.
% track.dataset = title of the graph.
% Mode = 0 : svd(D), 1: svd(Dz);
%
%
% Returns J ,degree of separation in each graph

% v20191223_released: edited comments
%% Variables initialization

    D = track.D; %matrixD
    Y = track.Y; %label
    indx_var = track.indx_var;
    indx_class = track.indx_class; 
    nClass = track.nClass; 

    newIndex = [indx_var{varCombo}];
    pcindex = 1:pcnum; %pc number

    % parameter for calculating kNN
    numOfNeighbour = 1; %kNNScore number of neighbour
    k_fold = 10; %fold number in k-fold cross validation

    D = D(newIndex,:);
    %% _/_/_/ perform SVD on matrix D _/_/_/
    tic; %start timer

    if mode ==0, [U, S, V] = svd(D); end
    if mode ==1, [U, S, V] = svd(D(:, indx_class{1})); end
    if mode ==2, [U, S, V] = svd(D(:, indx_class{2})); end

    combos = nchoosek(pcindex, 2); %all possible combinations of 2 pc.
    ncomb = length(combos); %total number of combination

    Uk = U(:,pcindex); %select left singular vectors
    Dk = Uk'*D; %dimension reduction

    toc; %end timer
    %% Singular value plot

    nMode =10; %number of mode to show on graph
    diag_s = diag(S); %length of mode

    figure; 
    semilogy(1:nMode, diag_s(1:nMode), 'o');
    xlabel('ith mode'), ylabel('Singular Value'); grid on;
    set(gca, 'XTick',1:nMode);

    %{
    figure;
    imagesc(V(:,1:nMode), [-0.8, 0.8]); colormap(gray);
    xlabel('ith mode'), ylabel('Trial#');
    set(gca, 'XTick', 1:nMode);
    axis ij; axis square;
    colorbar;   
    %}

    %Calculate percentage contribution of each principal component

    %preallocation
    contrib = zeros(1,length(diag_s));
    PC{length(diag_s)} = [];

    sumS = sum(diag_s); %total singular value
    for i=1:pcnum
        contrib(i) = diag_s(i)/sumS*100; %ith singular value/total
        PC{i} = strjoin({'PC',num2str(i),' (',num2str(contrib(i),3),'%)'},''); %PC-axis label
    end

    %% % Plot all combinations of 2d PC spaces.

    %allocation
    J = zeros(1,ncomb); 
    kNNScore= J;
    F=J;
    TPR=J;
    TNR=J;
    
    %plot 2d paces
    for j=1:ncomb
        subplot(2, round(ncomb/2), j)

            for i=1:nClass
                xtemp = Dk(combos(j,1),indx_class{i});
                ytemp = Dk(combos(j,2),indx_class{i});
                plot(xtemp,ytemp, track.classMarker{i});
                hold on;
            end

        Dtemp = Dk(combos(j,:),:);
        J(j)= calculateJ(Dtemp,indx_class); %Calculate J, degree of Sep
        [kNNScore(j),F(j),TPR(j),TNR(j)] = calculatekNN(Dtemp, Y, numOfNeighbour, 'kFold', k_fold); %Calculate 1NNScores
        hold off;

        % Graph axis label, title
        axis square;
        xlabel(PC(combos(j,1)));
        ylabel(PC(combos(j,2)));
    end
end