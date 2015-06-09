%% RUNME for Forrest's Synapse Detection Algorithm

%% Settings
%Manually determined by Forrest.
signalthresh = 0.025 * 256;
scale = 3.72;
dxy_thresh = 400;

% Edge Boundaries
bz = 1;
bxy = 10;

% Number of times to run the classifier
ntrials = 100;

% OCP Settings
resolution = 0;
server = 'http://openconnecto.me/';

bitmask_token = 'collman_silane_mask_anno';
anno_token = 'collman_silane_truthlabels'; 
upload_anno_token = 'silane_upload_test';
imageToken = 'collman15';
primaryIFChannel = {'PSD95_488'};


bitmask_token = 'collman_gelatin_mask_anno';
anno_token = 'collman_gelatin_truth_labels'; %'collman_silane_truthlabels';
upload_anno_token = 'collman14anno_anish1';
imageToken = 'collman14';
primaryIFChannel = {'PSDr'};


% Cube Download Locations 
qdownloadLocation = pwd;
downloadLocationBase = pwd;

%% Initialize API objects
oo = OCP();
oo.setDefaultResolution(resolution);

% Set server location and token
oo.setServerLocation(server);
oo.setImageToken(imageToken);
oo.setAnnoToken(anno_token);
oo.makeAnnoWritable();

% List of IF Channels names
channelList = oo.getChannelList;
% 5 - NR1
% 6 - PSDr
% 8 - VGluT1
% 11 - Synapsin
channelList = channelList([5, 6, 8, 11]);
%channelList = channelList([10, 11, 12, 13]);

disp('Settings Loaded')

%% Download Cubes
listOfMatFiles = downloadCubeData(oo,  server, imageToken, ...
    channelList, qdownloadLocation, downloadLocationBase, resolution);

numOfCutouts = length(listOfMatFiles) / length(channelList);

disp('Cubes Downloaded');
%% Get PSD Blobs
generateCC = true;
CC = [];
[CC, CC_stats] = segment_vstack(oo, primaryIFChannel, ...
    bitmask_token, signalthresh, resolution, listOfMatFiles, channelList, generateCC, CC);


% Get location of all the centroids detected
total_centroids = zeros(length(CC_stats), 3);
for n=1:length(CC_stats)
    total_centroids(n, :) = CC_stats(n).WeightedCentroid;
end

disp('Got PSD Blobs');

%% Update CC structure to link synapses
[CC, merge_counter] = ...
    merge_across_slices(CC, total_centroids, scale, dxy_thresh);

% Determine properties of other IF Channels
IF_CC_stats = cell(length(channelList), 1);

generateCC = false;
for n = 1:length(channelList)
    
    [~, CC_stats] = segment_vstack(oo, channelList(n), ...
        bitmask_token, signalthresh, resolution, listOfMatFiles, channelList, generateCC, CC);
    IF_CC_stats{n} = CC_stats;
    
end

disp('All IF Channels analyzed');

%% Load ground truth as a connected components object


[labels_CC, isgaba] = generateStatsFromLabels(oo, anno_token);

disp('Ground Truth Loaded');

%% Get overlap between PSD blobs and the ground truth
%overlap matrix - where the rows are say the psd-puncta, 
% and the columns are the EM identified synapses.
overlap_matrix = get_overlap(CC, labels_CC);

% Compare each blob with both the good pixels file and the volume
% dimensions to see if the blob lies on an edge

puncta_isedge = find_edge_cases(CC, oo, resolution, bitmask_token, bz, bxy);

disp('Puncta Matched');

%% Create set of features from the region props
numOfIFChannels = length(channelList);

inputfeatures = generate_features(overlap_matrix, IF_CC_stats, ...
    merge_counter, numOfIFChannels);

% 
tot_overlap = sum(overlap_matrix > 0, 2);

% pred stands for "predicted?"
pred = tot_overlap(:) > 0;

% 
block = [inputfeatures(~puncta_isedge, :), pred(~puncta_isedge')];
disp('Features Generated');

%% Classifier
% Index of features to select
feature_inds = 1:(length(channelList) + 2);
[overallCMat, psd_ids] = run_classifier(pred,...
    inputfeatures, puncta_isedge, feature_inds, ntrials);

disp('Classifier');

%% Calculate accuracy
accuracyvec = zeros(ntrials, 1);
for n=1:ntrials
    accuracyvec(n) = (overallCMat(1, 1, n) + overallCMat(2, 2, n)) / sum(sum(overallCMat(:, :, n)));
end
final_accuracy = mean(accuracyvec)

disp('Accuracy Numbers Calculated');

%% Create RAMON Volumes
rvolume = getRamonVolumeFromIds(oo, psd_ids, CC, resolution);

cubeUploadVoxelList(server, upload_anno_token, rvolume, 'RAMONSynapse', false)

disp('Annotations Uploaded');

emailAnish(num2str(final_accuracy)); 



