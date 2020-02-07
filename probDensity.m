function [] = probDensity(X, indx_class)
   %function to plot probality density function graph of 2 classes
   % X = [m x n], m: number of dimension, n: number of total samples
   % indxSet = index of samples for each class
    
  %% Mean and Std of each class
    dim = size(X,1);
    mu = zeros(dim, length(indx_class)); % each column represent a class, with each row as the corresponding mean value in that pc
    sigma = mu; % same as mean, but for variance
    LABEL = ones(indx_class{2}(end),1);
    LABEL(indx_class{2}) = 2

for i = 1:dim
    for j = 1:length(indx_class)
            mu(i,j) = mean(X(i,indx_class{j}));
            sigma(i,j) = var(X(i,indx_class{j}));
    end
end
%% Plot Distribution Density Function and calculate J, NN

for i  =1:dim
        x1 = X(i, indx_class{1}); 
        x2 = X(i, indx_class{2});
        
        %subplot(dim/2,2,i);
        figure;
        plot(x1, zeros(length(x1)), 'bo'); hold on
        fig = gcf;
        axLabel = sprintf('PC %d', i); 
        plot(x2, zeros(length(x2)), 'rx'); hold on
        ax(i)= fig.CurrentAxes;
        xlabel(axLabel); ylabel('P(x)');
        ax(i).YTick = [];
        xDistrib = ax(i).XLim(1) : (ax(i).XLim(2)-ax(i).XLim(1))/100 : ax(i).XLim(2);
        y1 = normpdf(xDistrib, mu(i,1), sqrt(sigma(i,1)));
        y2 = normpdf(xDistrib, mu(i,2), sqrt(sigma(i,2)));
        
        plot(xDistrib,y1, 'b-.'); hold on
        plot(xDistrib,y2, 'r-.'); hold off
        
        %{
        % calculate J, NNScore
        [J(i)] = calculateJ(X(i,:), indx_class);
        Jtxtbk(i) = calculateJ_txtbk(X(i,:), indx_class);
        [NNScore(i), F1(i)] = kNN_cv_error(X(i,:)', LABEL, 1);
        NNScore(i) = 1-NNScore(i);
        
              
        %annotation (J and NN Score)
        %ANNOTATION
        str = sprintf('J = %f , NN = %f', J(i), NNScore(i));
        title(str);
        %annotation('textbox', [0.68 0.85 0.1 0.05], 'String', str, 'FitBoxToText', 'on')
        %}
end
end