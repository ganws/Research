%remove selected IDs from a dataset and update its property
% INPUT:
% 1) Dstruct: data structure that contains Dmatrix and other properties 
% 2) ID_cell: 
function [Dstruct] = rmvID(Dstruct, ID_rmv)
    
    %unload necessary variable
    classLabel = Dstruct.classLabel;
    classSize = Dstruct.classSize;
    D = Dstruct.D;
    ID = Dstruct.ID;
    indx_class = Dstruct.indx_class;
    nSample = Dstruct.nSample;
    OHleak = Dstruct.OHleak;
    t_indx = Dstruct.t_indx;
    Y = Dstruct.Y;
    
    %% find ID indeces
    rmv_num = numel(ID_rmv); %number of IDs to be removed
    
    rmvIndx = false(1,nSample); %index if ID to remove
    
    %indexing
    fprintf('Removing ID...\n');
    for n = 1:rmv_num
        tmp = strcmp(ID_rmv{n}, Dstruct.ID);
        
        %display error if there is no ID found in database for potential typo
        if (~tmp)
            error('No ID [%s] found in the dataset', ID_rmv{n});
        else
            fprintf('ID [%s] \n', ID_rmv{n});
            rmvIndx = rmvIndx | tmp; 
        end
        
        
    end
    
    fprintf('All %d IDs have been removed succesfully from dataset %s\n', numel(ID_rmv), Dstruct.dataset);
    
    %% remove ID and update Dstruct
    
    D(:, rmvIndx) = [];
    ID(rmvIndx) = [];
    Y(rmvIndx) = [];
    t_indx(:, rmvIndx) = [];
    OHleak(rmvIndx) = [];
    nSample = length(Y);
    
    for i = 1:numel(classLabel)
        indx_class{i} = ismember(Y, classLabel{i});
        classSize(i) = sum(indx_class{i});
    end
  
    Dstruct.D = D;
    Dstruct.ID = ID;
    Dstruct.Y = Y;
    Dstruct.t_indx = t_indx;
    Dstruct.OHleak = OHleak;
    Dstruct.nSample = nSample;
    Dstruct.indx_class = indx_class;
    Dstruct.classSize = classSize;
    
end