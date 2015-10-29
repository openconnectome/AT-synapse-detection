function [CC, isgaba] = generateStatsFromLabels(server, resolution,...
    imgToken, imgChannel, anno_token, annoCH)
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

% Initialize API objects
oo = OCP();
oo.setDefaultResolution(resolution);

% Set server location and token
oo.setServerLocation(server);
oo.setAnnoToken(anno_token);
oo.setAnnoChannel(annoCH); 
oo.setImageToken(imgToken); 
oo.setImageChannel(imgChannel); 

oo.makeAnnoWritable();

ranges = oo.imageInfo.DATASET.IMAGE_SIZE(resolution); %[c, r, z]

%FIX FOR COLLMAN15
[length_r, length_c, length_z] = getDatasetSize(imgToken);

% Download entire dataset
[rows, cols, numfiles] = getDataRanges(oo);

%offset = oo.imageInfo.DATASET.OFFSET(resolution);
offset = [0 0 1]; 
localoffset = [cols(1), rows(1), numfiles(1)]; 


q = OCPQuery(eOCPQueryType.RAMONIdList);
q.setResolution(resolution);
q.addIdListPredicate(eOCPPredicate.type, eRAMONAnnoType.synapse);

% Get List of Annotation Ids
idList = oo.query(q);

% Generate CC Object
CC.Connectivity = 4;
% FIXME - will not work on nick's data 
CC.ImageSize = [length_r, length_c, length_z]; 
globalVolSize = [ranges(2), ranges(1), ranges(3)]; % [r, c, z]

CC.PixelIdxList = cell(1, length(idList));
CC.NumObjects = length(CC.PixelIdxList);

isgaba = zeros(length(idList), 1);

for n = 1:length(idList)
    
    query = OCPQuery(eOCPQueryType.RAMONDense, idList(n)); %Not sure why RAMONMetaOnly
    query.setResolution(resolution);
    
    s2 = oo.query(query);
    
    syn_id = s2.dynamicMetadata('syn_id');
    
    pixellist = getGlobalPixelIdList(s2, globalVolSize, offset(3));
    
    % Go from global to local 
    pixellist = globalToLocalPixelList(pixellist, localoffset, ...
        globalVolSize, CC.ImageSize); 
    
    CC.PixelIdxList{n} = pixellist;
    
    isgaba(n) = s2.dynamicMetadata('isgaba');
    disp([n, length(idList)]);
end


end