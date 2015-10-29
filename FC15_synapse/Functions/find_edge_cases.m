function isedge = find_edge_cases(CC, oo, resolution, maskToken, ...
    mask_channel, bz, bxy, useMask)
% This function determines if a blob is on the edge (numerically) of the
% volume
% INPUTS
% CC - Connected component structure
% oo - OCP Object with image token loaded
% maskToken - string, anno token for the mask
% bz - int, number of slices which are part of the edge
% bxy - int, number of pixels which form the edge on each slice
% OUTPUTS
% isedge - vector determining if the blob is an edge pixel or not

% Determine dimensions of the good pixels mask

[~, imgToken, ~, ~] = getSettings();
[lengthR, lengthC, numslices] = getCubeCutoutSize(imgToken);

if (useMask)
    oo.setAnnoToken(maskToken);
    oo.setAnnoChannel(mask_channel);
    
    
    % Download entire dataset
    [r, c, z] = getDataRanges(oo);
    
    
    offset = oo.imageInfo.DATASET.OFFSET(resolution);
    
    goodPixelFile = zeros(lengthR, lengthC, numslices, 'uint8');
    
    localInd = 1;
    
    for n = offset(3):1:(numslices+offset(3))
        
        gp_frame = downloadMasks(oo, n, resolution);
        goodPixelFile(:, :, localInd) = 255*uint8(gp_frame);
        localInd = localInd + 1;
    end
    disp('Mask Downloaded');
end

[r, c, z] = getDataRanges(oo);
N_row = lengthR;
M_col = lengthC;

pixel_list = regionprops(CC, 'PixelList');

%
bounds = zeros([2, 3, length(pixel_list)]);
%
tbounds = zeros([2, 3, length(pixel_list)]);

for i = 1:length(pixel_list)
    % Get the min max of each blob
    if(~isempty(pixel_list(i).PixelList))
        bounds(1, :, i) = min(pixel_list(i).PixelList, [], 1);
        bounds(2, :, i) = max(pixel_list(i).PixelList, [], 1);
    end
    
end

% Tighten bounds
tbounds(1, 3, :) = max(bounds(1, 3, :) - bz, 1);
tbounds(2, 3, :) = min(bounds(2, 3, :) + bz, numslices);

tbounds(1, 1:2, :) = max(bounds(1, 1:2, :)-bxy, 1);
tbounds(2, 1, :) = min(bounds(2, 1, :) + bxy, M_col);
tbounds(2, 2, :) = min(bounds(2, 2, :) + bxy, N_row);

%
badBox = zeros(1, size(tbounds, 3));

onZedge = zeros(1, size(tbounds, 3));

% I'm not sure if the iterative method is the best way to approach this
for i=1:size(tbounds,3)
    %disp(i);
    
    if(~isempty(pixel_list(i).PixelList))
        
        GPcut = zeros(tbounds(2, 2, i) - tbounds(1, 2, i) + 1,...
            tbounds(2, 1, i) - tbounds(1, 1, i) + 1, tbounds(2, 3, i)...
            - tbounds(1, 3, i) + 1);
        
        % Most of these operations exist because of the existing data
        % paradigm.
        for k = tbounds(1, 3, i):tbounds(2, 3, i)
            slot = k - tbounds(1, 3, i) + 1;
            
            if (useMask)
                GPcut(:, :, slot) = goodPixelFile( ...
                    [tbounds(1, 2, i):tbounds(2, 2, i)], ...
                    [tbounds(1, 1, i):tbounds(2, 1, i)], k);
            else
                goodPixelFile = 255*ones(N_row, M_col);
                
                GPcut(:, :, slot) = goodPixelFile( ...
                    [tbounds(1, 2, i):tbounds(2, 2, i)], ...
                    [tbounds(1, 1, i):tbounds(2, 1, i)]);
            end
            
        end
        
        
        BPcut = 255 - GPcut;
        badZprof = sum(sum(BPcut, 1), 2) == 0;
        if sum(badZprof) ~= length(badZprof)
            if length(badZprof) > 2
                three_in_a_row = badZprof(1:end - 2) + ...
                    badZprof(2:end - 1) + badZprof(3:end);
                badBox(i) = sum(three_in_a_row > 2) == 0;
            else
                badBox(i) = 1;
            end
        end
        if (bounds(1, 3, i) == 1)
            if (bounds(2, 3, i) < 2)
                onZedge(i) = 1;
            end
        end
        if (bounds(2, 3, i) == numslices)
            if (bounds(1, 3, i) > numslices - 1)
                onZedge(i) = 1;
            end
        end
    else
        badBox(i) = 1;
    end
end
isedge = or(badBox, onZedge);