
% subroutine to plot one feature space 
%
%
% GAN WEI SHENG
% v20191206: Written
% v20191223_released: Sample ID is linked to 2d plot
% v20191224: Added (singular value %) to axis title

%%
%load D_rsal_191111.mat;
%load D_rsal_171120_0.mat;
load D_rsal_AC_191111.mat

varCombo = [3]; %select process variable
pcCombo = [1,2]; %select principal component

newIndex = [indx_var{varCombo}]; %create new index

Dnew = D(newIndex, :) ;
[U,S,V] = svd(Dnew) ;

%singular value
diag_S = diag(S);
sumS = sum(diag_S);
pc1_percent = diag_S(pcCombo(1))/sumS * 100; %pc 1 singular value percentage
pc2_percent = diag_S(pcCombo(2))/sumS * 100; %pc 2 singular value percentage

Uk = U(:,pcCombo); %PCA
Dk = Uk'*Dnew;

%% plot single pc space

figure; 
for i = 1:nSample
    classIndx = strcmp(Y(i),classLabel);
    hp = plot(Dk(1,i), Dk(2,i), classMarker{classIndx}) ;
    
    set(hp, {'DisplayName'}, ID(i), 'MarkerSize', 10, 'LineWidth', 1); %ID labelling
    hold on
end
xlabel(['PC ', num2str(pcCombo(1)), '(', num2str(pc1_percent, 3), '%)']) ;
ylabel(['PC ', num2str(pcCombo(2)), '(', num2str(pc2_percent, 3), '%)']) ;

hold off

