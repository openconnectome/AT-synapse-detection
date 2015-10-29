function uploadDetections(inputMatFile, input2, getOverlapAndFeaturesFN, downloadGroundTruthFN)
% Upload detections

load(inputMatFile);
load(input2);
load(getOverlapAndFeaturesFN); 
load(downloadGroundTruthFN); 

[~, ~, chList, res] = getSettings();
    
[server, token, annoUploadChannel_gt, anno_neg_ch, annoUploadChannel] = getUploadToken();
semaphore = false;

% upload true positives 
synapses = packageSyanpses(CC, predicted_positive_detection, chList{end}, res);
uploadRAMON(server, token, annoUploadChannel, synapses, semaphore, []);

%upload false positives 
synapses = packageSyanpses(CC, predicted_negative_detection, chList{end}, res);
uploadRAMON(server, token, anno_neg_ch, synapses, semaphore, []);

%upload ground truth associated with the trial 
synapses = matchGroundTruth(overlap_matrix ,labels_CC, testones, chList{end}, res); 
uploadRAMON(server, token, annoUploadChannel_gt, synapses, semaphore, []);


end