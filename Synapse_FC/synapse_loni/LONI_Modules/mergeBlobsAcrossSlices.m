function mergeBlobsAcrossSlices(inputMatFile, outputFileName) 
% This function consolidates the puncta across slices
scale = 3.72;
dxy_thresh = 400;

%Bring CC & CC_stats into the workspace 
load(inputMatFile); 

% Get location of all the centroids detected
total_centroids = zeros(length(CC_stats), 3);
for n=1:length(CC_stats)
    total_centroids(n, :) = CC_stats(n).WeightedCentroid;
end


% Update CC structure to link synapses
[CC, merge_counter] = ...
    merge_across_slices(CC, total_centroids, scale, dxy_thresh);

save(outputFileName, 'CC', 'merge_counter'); 

end 


