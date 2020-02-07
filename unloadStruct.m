% unload all fields of struct into current workspace

function [ ] = unloadStruct (Dstruct)
    fldnames = fieldnames(Dstruct) ;
    for i = 1:numel(fldnames)
        assignin('caller', fldnames{i}, Dstruct.(fldnames{i}) ); 
    end
end