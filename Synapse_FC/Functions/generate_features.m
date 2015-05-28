function inputfeatures = generate_features(overlap_matrix, IF_CC_stats, ...
    merge_counter, numOfIFChannels)
% Generate additional features for classification
% INPUTS
% overlap_matrix - mat, number of pixels of each puncta which overlap with
% an annotated synapse
% IF_CC_stats - cell array of CC stats objects
% merge_counter - vector, number of mergers per puncta
% numOfIFChannels - number of IF channels which are being analyzed
% OUTPUTS
% inputfeatures - mat, features used for classification

tot_max_intensity = zeros(size(overlap_matrix, 1), numOfIFChannels);
tot_mean_intensity = zeros(size(overlap_matrix, 1), numOfIFChannels);

tot_area = zeros(size(overlap_matrix, 1), 1);
tot_centroids = zeros(size(overlap_matrix, 1), 3);

for n=1:(numOfIFChannels - 1)
    
    cc_stat_element = IF_CC_stats{n};
    
    for t=1:length(cc_stat_element)
        tot_max_intensity(t, n) = cc_stat_element(t).MaxIntensity;
        tot_mean_intensity(t, n) = cc_stat_element(t).MeanIntensity;
    end
end

% Specific case for PSDr
cc_stat_element = IF_CC_stats{numOfIFChannels};
for t=1:length(cc_stat_element)
    tot_max_intensity(t, numOfIFChannels) = cc_stat_element(t).MaxIntensity;
    tot_mean_intensity(t, numOfIFChannels) = cc_stat_element(t).MeanIntensity;
    
    
    tot_area(t) = cc_stat_element(t).Area;
    tot_centroids(t, :) = cc_stat_element(t).WeightedCentroid;
end

% brightness = area*intensity
tot_bright_matrix = repmat(tot_area, 1, size(tot_mean_intensity, 2)) .* ...
    tot_mean_intensity;

mean_bright_rep = repmat(mean(tot_mean_intensity, 1), size(tot_mean_intensity, 1), 1);
std_bright_rep = repmat(std(tot_mean_intensity, 0, 1), size(tot_mean_intensity, 1), 1);

norm_bright = (tot_mean_intensity - mean_bright_rep) ./ std_bright_rep;
norm_area = (tot_area - mean(tot_area)) / std(tot_area);
norm_merge_counter = (merge_counter' - mean(merge_counter)) / std(merge_counter);

% #UNCLEAR why normalize "merge counter"
inputfeatures = [norm_bright, norm_area, norm_merge_counter];


end

