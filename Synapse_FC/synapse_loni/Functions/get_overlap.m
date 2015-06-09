function overlap_matrix = get_overlap(CC1, CC2)
% Determines the amount of intersection between pixels of two CC objects
% INPUTS
% CC1, CC2 - connected components structures of the same length / size
% OUTPUTS
% overlap_matrx - mat, indicated the number of pixels overlapping
% where the rows are say the psd-puncta, and the columns are the
% EM identified synapses.
% EXAMPLE
% overlap_matrix = get_overlap(CC, labels_CC);

% Allocate memory
overlap_matrix = zeros(length(CC1.PixelIdxList),length(CC2.PixelIdxList));

% Loop over every puncta

for i=1:length(CC1.PixelIdxList)
    for j=1:length(CC2.PixelIdxList)
        overlap_inds = intersect(CC1.PixelIdxList{i}, CC2.PixelIdxList{j});
        overlap_matrix(i, j) = length(overlap_inds);
    end
    disp([i, length(CC1.PixelIdxList)]);
end

