function [CC, CC_stats] = segment_vstack(imgChn, useMask,...
    server, mask_token, anno_chan, imgToken, signalthresh, ...
    resolution, listOfMatFiles, ...
    channelList, generateCC, CC)
% REFACTORED TO MAKE MASK OPTIONAL
% FIXME - parameter list documentation
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
% mask - logical

% Initialize API objects
oo = OCP();
oo.setDefaultResolution(resolution);
oo.setServerLocation(server);
oo.setImageToken(imgToken);
oo.setImageChannel(imgChn);

offset = oo.imageInfo.DATASET.OFFSET(resolution);
[~, ~, z] = getDataRanges(oo);

numfiles = length(z);


load(listOfMatFiles);
data = cube.data;

if (useMask)
    % Mask out data
    oo.setAnnoToken(mask_token);
    oo.setAnnoChannel(anno_chan);
    
    % Download entire dataset
    goodPixelFile = zeros(size(data), 'uint8');
    
    localInd = 1;
    for n = offset(3):1:(numfiles+offset(3)-1)
        gp_frame = downloadMasks(oo, n, resolution);
        badpixels = gp_frame == 0;
        
        goodPixelFile(:, :, localInd) = badpixels;
        localInd = localInd + 1;
    end
    disp('Mask Downloaded');
    
    
    data(logical(goodPixelFile)) = 0;
end

if (generateCC)
    % Connect 3D blobs with intensity values above the treshold
    CC = bwconncomp(data > signalthresh, 4);
end

CC_stats = regionprops(CC, data, 'BoundingBox', 'MeanIntensity', 'Area', ...
    'MaxIntensity', 'WeightedCentroid');

disp(imgChn);
end

