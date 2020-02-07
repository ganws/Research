% plot OHleak vs PC2 to investigate their relationship {A,C,D}

% GAN WEI SHENG
% ver20191224: written
clear;clc
%% SETTINGS

fname = '../D_rsal_AC_191111.mat';
load(fname);

ID_select = {'61A0B2', '31E0D0', 'C09183', ...
                    'C04291', 'D0A110', '6181F0', ...
                    'D0B020', 'E0F270', 'F08373', ...
                    'E0B312', 'D01282', 'E00373', '0161A1'... 
                    '512093', '2123C2', '5180A3', 'C07353'};

pcselect = 2  ; %select pc to reconstruct
varSelect =8; %reconstruct variable

newIndex = [indx_var{varSelect}];
D = D(newIndex,:);

[U, S, V] = svd(D); %SVD
Uk = U(:,pcselect); %select left singular vectors
Dk = Uk'*D; %dimension reduction
%% plot PC vs OHleak

%plot PC vs OHleak
figure
for i = 1:nSample
    plot(Dk(i), flow_vol(i), classMarker{strcmp(Y(i), classLabel)});
    hold on;
    if (~isempty(find(strcmp(ID(i), ID_select), 1)))
        plot(Dk(i), flow_vol(i), 'go', 'MarkerSize', 10);
    end
end

%mark selected ID on figure
