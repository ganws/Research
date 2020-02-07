% Extract raw data from csv files in [FOLDER]Raw_data, arrange and 
% label them into .mat file with name format: raw_[dataset].mat
% For labelled dataset.

% GAN WEI SHENG
% VER 20191101
% VER 20191206_released: modified to be compatible with shot object.
%% SETTINGS <===== CHANGE HERE
clear;clc;

DIR = '..\Raw_data\vectorCSV_171120_0';  %directory of raw data files
dataset = '171120_0'; %manually label

t_col = 1; % time vector column;
VarCol = 2:9; %for datasets recorded CAST-TREND systems (ie 171120)

%for datasets recorded vizitrack systems (ie 180410)
%t_col = 4; % time vector column
%VarCol = [3,5,8,9,10]; 

% process variable names.
varName = {'Velocity', 'Head Pressure', 'Rod Pressure', ...
            'Metal Pressure', 'Stroke', 'Valve Opening Instruction', ...
            'Valve Opening', 'Vacuum Level'}; 

varUnit = {'m/s', 'MPa', 'MPa', 'MPa', 'mm', 'mm', 'mm', 'kPa'};% Units
%% Init

[folder] = listFile(DIR); %custom function to return all files from directory

if (numel(folder) == 0)
    error('Unable to find %s \n', DIR); 
end

nClass = length (folder); %number of class (OK, NG -> 2)
nVar = length(VarCol); %num of process var

%preallocation
sample(1) = Shot ;
samples = cell(1,2);
nSamples = zeros(1,nClass) ;

%%  Import data
% load every file into tables of rawdata{class}{samples}
% the variables are selected through modifying ImportOptions for table
fprintf('Loading data from %s... \n', DIR);

tStart = tic; %start timer
n = 1;
for i = 1:nClass
    fullPath = fullfile(DIR, folder{i});
    samples{i} = listFile(fullPath); %list individual sample csv file name
    nSamples(i) = length(samples{i}); %number of samples per class
    
    %import table from csv
    for j = 1:nSamples(i) 
        temp = fullfile(fullPath,samples{i}{j});        
        opts = detectImportOptions(temp);
        opts.SelectedVariableNames = opts.VariableNames([t_col,VarCol]); % select variables to import
        opts.VariableUnitsLine = 2;
        csv = readtable(temp,opts);
        csv = table2array(csv);  %Convert table into cell 
        
        
        sample(n).ID = erase(samples{i}{j}, '.csv'); % sample ID
        sample(n).class = folder{i}; % class label
        sample(n).isNaN = sum(sum(isnan(csv))); % NaN data points
        sample(n).isInf = sum(sum(isinf(csv))); %Inf data points
        sample(n).Len = size(csv,1); %original time series length
        sample(n).t_indx = csv(:,t_col); %time indx
        sample(n).varName = varName;
        sample(n).varUnit = varUnit;
        for k = 1:nVar
            sample(n).var{k} = csv(:,k+1); %load sensor data vector, offset 1 because 1st col is set as time vector
        end
        n  = n+1;
    end
%    fprintf('Class %s: %d samples \n', folder{i}, nSamples(i));
end

fprintf('NaN data points detected: %d \n', sum([sample.isNaN]));
fprintf('Inf data points detected: %d \n', sum([sample.isInf]));

%% Export as .mat file

classLabel = folder;

[classSize, nSample, nClass] = updateSize(classLabel, sample);
%classSize = nSamples ;
%totalSize = sum(classSize) ;

matfname = ['raw_', dataset]; 
save(matfname, 'dataset', 'classLabel', 'classSize', 'nSample', 'nClass', 'nVar', 'varName', 'varUnit', 'sample');

fprintf('Succesfully savd data into %s.mat ...\n', matfname);
tEnd = toc(tStart);
fprintf('Time Elapsed: %f s\n', tEnd);

