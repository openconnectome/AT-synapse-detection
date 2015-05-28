function [CC, isgaba] = generateStatsFromLabels(oo, anno_token)
% Downloads ground truth and generates CC object
% INPUTS
% oo - OCP Object with synapse annotation token loaded
% OUTPUTS
% CC - connected components structure containing all the synapses in the
% dataset
% isgaba - binary vector, 1 if the synapse is GABAergic

% Forrest's data is never indexed from 1. It's either 0 or 31. Therefore,
% the synapse download script has to shift the slice origin to 1.  The data
% is then shifted back during upload 

oo.setAnnoToken(anno_token);
oo.makeAnnoWritable();

zrange = double(oo.imageInfo.DATASET.SLICERANGE);
numfiles = zrange(2) - zrange(1) + 1;

ranges = oo.imageInfo.DATASET.IMAGE_SIZE(0);
N_rows = ranges(2);
M_cols = ranges(1);

q = OCPQuery(eOCPQueryType.RAMONIdList);
q.setResolution(0);
q.addIdListPredicate(eOCPPredicate.type, eRAMONAnnoType.synapse);

% Get List of Annotation Ids
idList = oo.query(q);

% Generate CC Object
CC.Connectivity = 4;
CC.ImageSize = [N_rows, M_cols, numfiles];

CC.PixelIdxList = cell(1, length(idList));
isgaba = zeros(length(idList), 1);

for n = 1:length(idList)
    
    query = OCPQuery(eOCPQueryType.RAMONDense, idList(n));
    query.setResolution(0);
    
    s2 = oo.query(query);
    
    syn_id = s2.dynamicMetadata('syn_id');
    pixellist = getPixelIdList(s2, CC.ImageSize, zrange(1));
    
    % Translate 
    
    
    CC.PixelIdxList{syn_id} = pixellist;
    
    isgaba(syn_id) = s2.dynamicMetadata('isgaba');
    disp([n, length(idList)]);
end

CC.NumObjects = length(CC.PixelIdxList);

end