% plot OHleak and Other Parameters vs PC2 to investigate their relationship {A,C,D}

% GAN WEI SHENG
% ver20191224: written
clear;clc
%% SETTINGS

fname = 'D_rsal_ACD_191111.mat';
load(fname);

ID_select = {'61A0B2', '31E0D0', 'C09183', ...
                    'C04291', 'D0A110', '6181F0', ...
                    'D0B020', 'E0F270', 'F08373', ...
                    'E0B312', 'D01282', 'E00373', '0161A1'... 
                    '512093', '2123C2', '5180A3', 'C07353'};
                
load('paramTable_191111.mat');

pcselect = 2  ; %select pc to reconstruct
varSelect =8; %reconstruct variable

newIndex = [indx_var{varSelect}];   
D = D(newIndex,:);

[U, S, V] = svd(D); %SVD
Uk = U(:,pcselect); %select left singular vectors
Dk = Uk'*D; %dimension reduction

paramCol = [3, 10:31]; %parameter column select
X = zeros(length(paramCol)+1, length(ID_select)); %+1 in row for PC1/PC2
%% extract parameters of selected ID

for n = 1:length(ID_select)
   indx = find(strcmp(ID_select{n},paramTab.ID));
   tmp = paramTab(indx, paramCol);
   X(2:end, n) = table2array(tmp)'; %reserve variable 1 for PC
   
   indx2 = find(strcmp(ID_select{n}, ID));
   X(1,n) = Dk(indx2);
end

Xnorm = normalize(X,2); %normalize X
% Xnorm(32,:) = []; %remove 32th column (Calculate Start Fast Short)
corrMat = corrcoef(Xnorm'); %return correlation coeff
figure
heatmap(corrMat);%plot heatmap
figure
plotmatrix(Xnorm');
%% plot PC vs OHleak
%{
%plot PC vs OHleak
figure
for i = 1:nSample
    plot(Dk(i), OHleak(i), classMarker{strcmp(Y(i), classLabel)});
    hold on;
    if (~isempty(find(strcmp(ID(i), ID_select))))
        plot(Dk(i), OHleak(i), 'go', 'MarkerSize', 10);
    end
end
%}
%mark selected ID on figure
