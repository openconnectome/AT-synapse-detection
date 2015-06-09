function [CC, CC_stats] = segment_vstack(oo, primaryIFChannel, ...
    bitmask_token, signalthresh, resolution, listOfMatFiles, channelList, generateCC, CC)
% Processes an IF Data cube and generates a connected components object
% INPUTS
% oo - ocp object
% primaryIFChannel - cell containing a string, name of channel to analyze
% bitmask_token - string, mask token
% signalthresh signal threshold
% listOfMatFiles - cell array of strings, location of each data cube
% channelList - cell array of strings (names of channels)
% generateCC - boolean, if true, create connected components object
% CC - connected components object
% OUTPUTS
% CC - Connected components object
% CC_stats - regionprops stats object

oo.setAnnoToken(bitmask_token);

% Allocate Memory
ranges = oo.imageInfo.DATASET.IMAGE_SIZE(resolution);
N_rows = ranges(2);
M_cols = ranges(1);
zrange = oo.imageInfo.DATASET.SLICERANGE;
numfiles = zrange(2) - zrange(1) + 1;
data = zeros(N_rows, M_cols, numfiles, 'uint8');

numOfCutouts = length(listOfMatFiles) / length(channelList);

primaryIFChannelInd = 0;

% Determine Location of primary channel in the cell array
for n = 1:length(channelList)
    if strcmp(channelList{n}, primaryIFChannel{:})
        primaryIFChannelInd = n;
    end
end

psdFileInd = primaryIFChannelInd * numOfCutouts - (numOfCutouts - 1);

% Loop through each cube cutout
localSlizeInd = 1;
globalSliceInd = zrange(1); 

for n = psdFileInd:(psdFileInd+numOfCutouts-1)
    load(listOfMatFiles{n}, 'cube');
    cube = cube{1};
    
    cubesize = size(cube.data);
    for cubeslice = 1:cubesize(3)
        IF_frame = cube.data(:, :, cubeslice);
        
        if (generateCC)
            gp_frame = downloadMasks(oo, globalSliceInd, resolution);
            
            % Get reverse mask
            badpixels = gp_frame == 0;
            
            % Mask out data
            IF_frame(badpixels) = 0;
        end
        data(:, :, localSlizeInd) = IF_frame;
        disp([localSlizeInd, numfiles]);
        localSlizeInd = localSlizeInd + 1;
        globalSliceInd = globalSliceInd + 1; 
    end
    
end

if (generateCC)
    % Connect 3D blobs with intensity values above the treshold
    CC = bwconncomp(data > signalthresh, 4);
end

CC_stats = regionprops(CC, data, 'BoundingBox', 'MeanIntensity', 'Area', ...
    'MaxIntensity', 'WeightedCentroid');

end

