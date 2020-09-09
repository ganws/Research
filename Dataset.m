classdef Dataset
% dataset class that define the data structure of dataset
%
% v20200909: written
    
    properties
        name % name of dataset (eg: 191111)
        Shot % array of shot objects
        varName
        varUnit
        preprocess % record preprocess done to this dataset
    end
    
    properties (Dependent)
        nVar
        nSample
        classLabel % class labels in 
        shotLabels % class label of each shot
        classSize % num of size of each class
        nClass % num of class
    end

    % get methods
    methods
        function nvar = get.nVar(obj)
            nvar = length(obj.Shot(1).var); % assume all shots have the same num of var
        end
        
        function nsample = get.nSample(obj)
            nsample = length(obj.Shot);
        end
        
        function labels = get.shotLabels(obj)
            labels = cell(1, obj.nSample);
            for n = 1:obj.nSample
                labels{n} = obj.Shot(n).class;
            end
        end
        
        function nclass = get.nClass(obj)
            nclass = length(obj.classLabel);
        end
        
        function c = get.classLabel(obj)
            c = unique(obj.shotLabels);
        end
        
        function csize = get.classSize(obj)
            
            csize = zeros(1, length(obj.classLabel));
            for c = 1:obj.nClass
                csize(c) = sum(strcmp(obj.classLabel{c}, obj.shotLabels));
            end
            
        end
                

    end
  
end

