% find acculumative value of singular values to determine the cutoff mode
% number



% GAN WEI SHENG
% ver201912106 - written
clear;clc;
%% setting <===CHANGE HERE

load('D_rsal_AC_191111.mat') ;

%pcnum = 5; 
varCombo = [1:8]; %variable configuration
cutoffPercentage = 70; % cutoff accumulative percentage *100 [%] 


%% init

newIndex = [indx_var{varCombo}]; 
%pcindex = 1:pcnum;

D = D(newIndex,:);
%% _/_/_/ perform SVD on matrix D _/_/_/
tic;
[U, S, V] = svd(D, 'econ'); %svd
toc;

diag_s = diag(S);
nMode = numel(diag_s);


%Calculate percentage contribution of each principal component
contrib = [];
PC = {};
sumS = sum(diag_s);
for i=1:(length(diag_s))
    contrib(i) = diag_s(i)/sumS*100;
    PC{i} = strjoin({'PC',num2str(i),' (',num2str(contrib(i),3),'%)'},'');
end

% find accumulative percentage
accumulativeS(1) = contrib(1);
for i = 2:length(diag_s)
    accumulativeS(i) = accumulativeS(i-1) + contrib(i);
end

cutoffIndex = find(accumulativeS >= cutoffPercentage,1); % the first mode that reaches cutoffPercentage 
fprintf('first mode to reach %d %% = %dth mode \n', cutoffPercentage,  cutoffIndex);

%% plot

figure;

%plot signular value
yyaxis left
semilogy(1:nMode, diag_s, 'o');
xlabel('ith mode'), ylabel('Singular Value'); grid on;
%set(gca, 'XTick',1:length(diag_s));
hold on;

% plot cumulative value
yyaxis right
plot(0:nMode,[0,accumulativeS])
ylabel('Cumulative value [%] ');

% plot cutoff point
plot([cutoffIndex,cutoffIndex], [0,100]);

