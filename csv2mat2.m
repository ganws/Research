% Extract raw data from csv files in [FOLDER]Raw_data, arrange and 
% label them into .mat file with name format: raw_[dataset].mat
% For dataset with label on separate file.

% GAN WEI SHENG
% ver20191101: first version
% ver20191207: modified to be compatible with shot object.
% ver20191223_released: modified to read labels in parameter table label in
% english
% ver20191224:  - include OHleak parameter to samples.
%                       - change 'class' from string to char
%                       - include total flow volume(flow_vol) as area under velocity-time graph parameter to samples
%% SETTINGS  <===== CHANGE HERE
clear;clc;

% file name and pathing
dir = '..\Raw_data\dataset_191111\vectorCSV';  %directory of raw data files
dataset = '191111'; 
load paramTable_191111.mat ; %load labels

% Select variables [col] in CSV file.

t_col = 1; % time vector column;
VarCol = 2:9; %for datasets recorded CAST-TREND systems (ie 171120)
nVar = length(VarCol); %num of process var

% Appropriate process variable names.
varName = {'Velocity', 'Head Pressure', 'Rod Pressure', 'Metal Pressure', 'Stroke', 'Valve Opening Instruction', 'Valve Opening', 'Vacuum Level'};

% Units for all the variables to be extracted from the csv file
varUnit = {'m/s', 'MPa', 'MPa', 'MPa', 'mm', 'mm', 'mm', 'kPa'};

defectLabel = 4; %select the column in paramTab for class labellling (for 191111 -> Defect)
OHleakCol = 3;% OHleak column
%%  Readtable from csv data
% the variables are selected through modifying ImportOptions for table
fprintf('Loading data from %s... \n', dir);

tStart = tic; %start timer

samples = listFile(dir); %list individual sample csv file name
nCSV = length(samples); %number of samples per class
%sample(nCSV) = struct('ID', '', 'isNaN', 0, 'isInf', 0, 'Len', 0, 'OHResult', 0, 'Defect', '', 'DefectCode', 0) ;%preallocation
sample(nCSV) = Shot ; %preallocation

%import table from csv and load into structured data
for k = 1:nCSV 
    temp = fullfile(dir,samples{k});        
    opts = detectImportOptions(temp);
    opts.SelectedVariableNames = opts.VariableNames([t_col,VarCol]); % select variables to import
    opts.VariableUnitsLine = 2;
    csv = readtable(temp,opts);
    csv = table2array(csv);  %Convert table into cell 
    
    sample(k).ID = erase(samples{k}, '.csv'); % sample ID
    sample(k).isNaN = sum(sum(isnan(csv))); % NaN data points
    sample(k).isInf = sum(sum(isinf(csv))); %Inf data points
    sample(k).Len = size(csv,t_col); %original time series length
    sample(k).t_indx = csv(:,t_col); %time indx
    sample(k).varName = varName;
    sample(k).varUnit = varUnit;
    
    for j = 1:nVar
        sample(k).var{j} = csv(:,j+1); %load sensor data vector, offset 1 because 1st col is set as time vector
    end
    
    %calculate area under curve of velocity-time graph
    velocity_indx = find(strcmp(varName, 'Velocity'));
    sample(k).flow_vol = trapz(sample(k).t_indx, sample(k).var{velocity_indx});
end
fprintf('Samples number in %s : %d \n', dir, nCSV);

fprintf('NaN data points detected: %d \n', sum([sample.isNaN]));
fprintf('Inf data points detected: %d \n', sum([sample.isInf]));
%% Labelling

csvData = erase(samples, '.csv');

% identiy csv that do not have labels
[hasLabel, csv2lbl_ind] = ismember(csvData, [paramTab.ID]);
    
% identify id that do not have csv data file.
[hasCSV, indx] = ismember([paramTab.ID], csvData);

% identify repeated ID
[n,bin] = histcounts(indx, unique(indx));
multiple = find(n>1);
indx_rpt = find(ismember(bin,multiple(2:end))); %exclude multiple(0) because it is the freq of samples without csv file. 

classLabel = unique (table2cell (paramTab(:,defectLabel)));

% label csv with class label and OHleak parameter. 
for i = 1:nCSV
    if hasLabel(i) == 1
        sample(i).class = char(paramTab{csv2lbl_ind(i), defectLabel}); %class label
        sample(i).OHleak = table2array(paramTab(csv2lbl_ind(i), OHleakCol));
    end
end

% remove csv without label
fprintf('Removing ID...\n');
csv2Remove = {sample(hasLabel==0).ID} ;
for rm = 1:numel(csv2Remove) 
    fprintf('Removing csv ID without label: [%s] \n', csv2Remove{rm});
    sample(find2(sample, 'ID', csv2Remove{rm}))=[] ;
end

[classSize, nSample, nClass] = updateSize(classLabel, sample) ;
%% Export as .mat file

matfname = ['raw_', dataset]; 
save(matfname, 'dataset', 'classLabel', 'classSize', 'nSample', 'nClass', 'nVar', 'varName', 'varUnit', 'sample');

fprintf('Succesfully saving data into %s.mat ...\n', matfname);
tEnd = toc(tStart);
fprintf('Time Elapsed: %f s\n', tEnd);
