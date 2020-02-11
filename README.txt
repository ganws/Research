VERSION. 20200211 - Introduced new signal align algorithm
VERSION. 20200208 - Implemeted Git version control system
VERSION. 20191224 - added OHLeak as parameter for dataset 191111
VERSION. 20191223_released -  edited comments and robustness ver20191206
VERSION. 20191206 - Object-Oriented Refactory. MATLAB VER.2018a
VERSION. 20191101 - Refactory

========================================
//////=========PROGRAM==========////////
========================================

============Preprocess==================
Lists of programs to prepare Dmatrix from raw data.

For datasets with csv files grouped together by class lables in folder:
DATASET: 1711120, 180410_product1, 180410_product2_su, 180831, 181019
	1) csv2mat: Extract raw data from csv files, save as 'raw_[XXX].mat'
	2) preprocess: manually remove samples, signal align, rescaling preprocess
	3) createDataMatrix: Generate Dmatrix
    4) rmvID_script: remove selected ID from a dataset (only when necessary)

Datasets that have label info in separate file:
DATASET: 191111
	1) readlabel: Read labels info from label_info_released(modified 20171223).xlsx and save as paramTab.mat
	2) csv2mat2: Extract raw data from csv files, label samples with info in paramTab, save as 'raw_[XXX].mat'
	3) preprocess: Manually remove samples, signal align, rescaling preprocess
  	4) createDataMatrix: Generate Dmatrix
   	5) splitD: Split datmatlaset into subsets and rescale.
    6) rmvID_script: remove selected ID from a dataset (only when necessary)

plotTimeseries: Function that takes 'Dmat' parameter to subplot time series data of all variables for all samples in a figure.

========Singular Value Decomposition===============
Program to perform SVD on Dmatrix

1) plotSingularValues.m: Calculate and singular value percentage and its cumulative percentage of each PC.
2) svdPlot: Perform SVD on selected process variables on Dmatrix, plot all 2d feature spaces.
3) plotPC_single: Plot one selected 2d feature space.
4) signalReconstruct: Reconstruct time series data from selected process variable.

plotPC: Function that takes in 'Dmat' as parameter to plot all possible combinations of PC.

========DATASET EVALUATION============
1) datasetEval_allvar: Evaluate datasubsets (191111) with J, NNScore, TPR, TNR metrics, plotted figures saved
as eg: [metric]_[preprocess]_allvar_191111.fig
2) plotSingularValues: Plot singular values and cumulative value in graph, finding the cutoffpoint
3) eval_1PC: Evaluate individual PC, using the cutoff mode from plotSingularValues 

4) probDensity: Plot normal distribution density function on selected PC

========PROCESS VARIABLE EVALUATION========
1) calSpaceEval: Calculate J, 
1.1) calSpaceEval_HEADER: Automate (1)calSpaceEval.m program with selected datasubsets
2) processVarEval: Evaluate process variables in terms of evaluation metrics calculated in calSpaceEval, automatically save bar graph.
3) subPlot: Subplot all graphs produced in (2) into one figure.
4) figWindSize: Resize targetd figures with a selected figure as reference.
5) signalReconstruct_isolate: modified version to reconstruct time series data of isolated IDs

========VAR8 INVESTIGATION (191111)========
1) signalReconstruction_isolate: reconstruct selected ID
2) OHleak_PC2_relation: plot PC-OHleak

=================================================
//////============MAT FILES==============////////
=================================================
This section explains .mat files that contains sample and analysis data. The notation is explained below.
Notation:
[dataset]represents dataset name. eg. 191111
[preprocess]represents preprocess performed on dataset. (rs=rescaling, al=alignment, al2=alignment with signalAlign_v2 function, raw=no preprocess done)

1 )paramTab_[dataset].mat: Contains label info (only 191111)
2) raw_[XXX].mat: Contains raw time series data gathered from csv files.
3) [preprocess]_[dataset].mat: Preprocessed time series data
4) D_[preprocess]_[dataset].mat: Dmatrix
5) D_[preprocess]_[subset]_[dataset].mat: Subset of dataset (only 191111)
6) D_[preprocess]_[subset]_[rmvid].mat: Subset of dataset with some ID removed

7) eval_D_[preprocess]_[subset]_[dataset].mat: results calculated from calSpaceEval program.
	Details:
		Every metrics contain 8 cells: each cell contains different process-variable configuration
		{1-var configï}, {2-var config}, {3-var config} ...... {all-var config}
		
		In every cell, metrics values are in matrix form
		
		Row - Process data combination. 
		eg. In {2-var config}- 1st row: {var#1,var#2}, 2nd row:{var#1,var#3}, ... ,28th row:{var#7,var#8}
		
		Column - feature spaces of PC1-PC5 combination
		1st col:{PC1,PC2}, 2nd col:{PC1,PC3}, 3rd colï:{PC1,PC4}, ... ,10th col:{PC4,PC5},  
		
8) [subset]_eval1PC: contains evaluation metric values of 1dimension of [subset]
=================================================
//////=========CUSTOM FUNCTIONS==========////////
=================================================
    1) listFile: returns Dir contents in cell array without '.' and '..'
    2) find2: search a value in specific field in struct array and return the index.
    3) findSignalRise: returns index in vector X.
    4) updateSize: Return class size and total sample size.
    5) sortStruct : Perform a nested sort of a struct array based on multiple fields. - by Jake Hughey
    https://www.mathworks.com/matlabcentral/fileexchange/28573-nestedsortstruct
    6) generateIndex: generate index by variables and samples.
    7) withinClassVar: calculate within-class variance
    8) betweenClassVar: calculate between-class variance
    9) calculateJ: calculate J
    10) plotTimeSeries: subplot time series data of all variables for all samples in a figure.
    11) plotPC
    12) unloadStruct
    13) calculatekNN
    14) rmvID

========PREPROCESSING FUNCTION========
    1) rmvSample: manually remove sample
    2) signalAlign: signal rise alignment
    3) signalAlign_v2: signal rise alignment version2
    4) signalRescale: rescale signal
    

===========================================================
//////===============DATA STRUCTURE================////////
===========================================================
1) raw_[dataset].mat : 
Raw data and information extracted from csv files.
    -dataset: string of dataset name.
    -classLabel: labels of classes in the dataset.
    -classSize; class size of each classes.
    -nSample: total number of samples.
    -nClass: class number
    -nVar: total number of process variable (including Time variable).
    -varName: Cells containing name of process variable (Cell1 is always set to Time vector).
    -varUnit: Cells containing the units of each process variable.
    -paramTab: Table containing label info. (not all dataset has this)
    -sample(): object aray of 'shot' class 
        -sample(1)
        -sample(2)
            :
        -sample(k): Shot object
                Proterties: 
                [ID]: ID of sample #k as of original .csv file , eg. 511181.csv
                [isNaN]: total num of NaN data points found in sample #k.
                [isInf]: total num of Inf data points found in sample #k.
                [len]: time series length
                [Defect]: Defect type
                [class]: Class label
                [t_indx]: time index
                [varName]: cell containing variable names
                [varUnit]: cell containing variable unit
                [var]: cells containing data vector of corresponding process variable
                    - var{1} : Time
                    - var{2}
                        :
                    - var{S}

                Methods:
                1) plotSingleVar: plot time series data of a selected process variable 

3) [preprocess]_[dataset].mat
Preprocessd data. Share same structure as raw_[dataset].mat

3) D_[preprocess]_[subset].mat
Dataset D matrix and its properties necessary for analysis program.
        -Dmat struct
            Dataset properties:
                [dataset]: dataset name
                [classLabels]: label of each class
                [classSize]: sizes of each class
                [nClass]: number of classes
                [nSample]: number of all samples
                [nVar]: total number of process variables
                [varName]: name of process variables
                [varUnit]: unit of process variables
                [isAligned]: Signal alignment(TRUE=done, FALSE=not done)
                [isScaled]: Rescale (TRUE=done, FALSE=not done)
                [frame]: Selected frame from original time series data
                [len]: Length of selected frame
                [minval]: Scaling coefficient
                [maxval]: Scaling coefficient
                [classLine]: Line color setting for each class
                [classMarker]: Marker settings for each class
            Dmatrix properties:
                [D]: Dmatrix
                [Y]: Sample labels
                [t_indx]: Time index
                [ID]: sample ID number
                [indx_var]: Process variable index in Dmatrix
                [indx_class]: Class index in Dmatrix


    
    

