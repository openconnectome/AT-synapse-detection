function [CC, merge_counter] = ...
    merge_across_slices(CC, total_centroids, scale, dxy_thresh)
% This function determines the number of adjacent punctas per puncta
% INPUTS
% CC - Connected Components structure
% total_centroids - Vector containing the centroids of the blobs
% Scale - int, constant
% dxy_thresh - int, constant
% OUTPUTS
% CC - Connected components object
% merge_counter - mat, number of mergers per puncta


% Repeat slice index vector (z) to create square matrix
z1 = repmat(total_centroids(:, 3), 1, size(total_centroids, 1));

% Repeat slice index vector (z) to create square matrix
z2 = repmat(total_centroids(:, 3)', size(total_centroids, 1), 1);

% Find location where the centroid weights differ by only one slice
[offones_i, offones_j] = find(z1 - z2 == 1);

% centroidZ = total_centroids(:, 3);
% offones_i = zeros(size(centroidZ));
% offones_j = zeros(size(centroidZ));
%
%
% ind = 1;
% for r =1:length(centroidZ)
%
%     for c = 1:length(centroidZ)
%
%         if (abs(centroidZ(r) - centroidZ(c)) == 1)
%             offones_i(ind) = r;
%             offones_j(ind) = c;
%             ind = ind + 1;
%         end
%
%     end
%     if (mod(r, 100) == 0)
%         disp(r);
%
%     end
%
% end


% Compute distance vector between centroids which are only a slice apart
dx2 = (total_centroids(offones_i, 1) - total_centroids(offones_j, 1)).^2;
dy2 = (total_centroids(offones_i, 2) - total_centroids(offones_j, 2)).^2;
dxy = sqrt(dx2 + dy2);

% Find centroids which lie below the threshold
mergeones = find(scale*dxy < dxy_thresh);

%
merged_to = zeros(1, length(total_centroids));

%
merge_counter = ones(1, length(total_centroids));

for k = 1:length(mergeones)
    
    % Get index of centroid
    i = mergeones(k);
    
    % Indexes of centroids to merge
    source = offones_j(i);
    target = offones_i(i);
    
    % if the centroid hasn't been merged to anything:
    if (merged_to(source) == 0)
        
        %
        while merged_to(target) ~= 0
            target = merged_to(target);
        end
        
        % Consolidate pixel locations
        CC.PixelIdxList{target} = [CC.PixelIdxList{target}; CC.PixelIdxList{source}];
        CC.PixelIdxList{source} = [];
        merged_to(source) = target;
        merge_counter(target) = merge_counter(target) + merge_counter(source);
        
    end
end

% Remove elements without pixels
goodones = cellfun('length', CC.PixelIdxList) > 1;

% Update CC object
newList = CC.PixelIdxList(goodones);
CC.PixelIdxList = newList;
CC.NumObjects = length(newList);

%
merge_counter = merge_counter(goodones);

end

