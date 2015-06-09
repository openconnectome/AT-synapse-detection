function getOverlapAndFeatures(inputMatFileGT, input2, input3, ...
     outputFileName) 
% Determine which blobs correspond to actual synapses 

% load labels_CC 
load(inputMatFileGT); 

% loaf IF_CC_Stats 
load(input2); 

% load CC 
load(input3); 

% load token
% Edge Boundaries
bz = 1;
bxy = 10;

% OCP Settings
syn_settings; 

% Initialize API objects
oo = OCP();
oo.setDefaultResolution(resolution);

% Set server location and token
oo.setServerLocation(server);
oo.setImageToken(imageToken);
oo.setAnnoToken(anno_token);
oo.makeAnnoWritable();
channelList = oo.getChannelList;
channelList = channelList(channel_ids);



% Get overlap between PSD blobs and the ground truth
%overlap matrix - where the rows are say the psd-puncta, 
% and the columns are the EM identified synapses.
overlap_matrix = get_overlap(CC, labels_CC);

% Compare each blob with both the good pixels file and the volume
% dimensions to see if the blob lies on an edge

puncta_isedge = find_edge_cases(CC, oo, resolution, bitmask_token, bz, bxy);

disp('Puncta Matched');

% Create set of features from the region props
numOfIFChannels = length(channelList);

inputfeatures = generate_features(overlap_matrix, IF_CC_stats, ...
    merge_counter, numOfIFChannels);

% 
tot_overlap = sum(overlap_matrix > 0, 2);

% pred stands for "predicted?"
pred = tot_overlap(:) > 0;


save(outputFileName, 'pred', 'inputfeatures', 'puncta_isedge', ...
    'overlap_matrix', 'channelList'); 

end 
