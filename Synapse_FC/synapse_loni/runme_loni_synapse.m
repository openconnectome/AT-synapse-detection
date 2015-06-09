% LONI RUNME 


downloadCubesFileName = 'dcfn.mat'; 
downloadCubes(downloadCubesFileName, pwd) 
disp('downloadCubes');

extractMainIFChannelBlobsFN = 'emifcb.mat'; 
extractMainIFChannelBlobs(downloadCubesFileName, extractMainIFChannelBlobsFN) 
disp('Got PSD Blobs');

mergeBlobsAcrossSlicesFN = 'mbas.mat'; 
mergeBlobsAcrossSlices(extractMainIFChannelBlobsFN, mergeBlobsAcrossSlicesFN)
disp('mergeBlobsAcrossSlices'); 

segmentIFChannelsFN = 'sifc.mat'; 
segmentIFChannels(mergeBlobsAcrossSlicesFN, downloadCubesFileName, ...
    segmentIFChannelsFN) 
disp('segmentIFChannels');

downloadGroundTruthFN = 'dgt.mat'; 
downloadGroundTruth(downloadGroundTruthFN)
disp('Ground Truth Loaded');

getOverlapAndFeaturesFN = 'goaf.mat'; 
getOverlapAndFeatures(downloadGroundTruthFN, segmentIFChannelsFN, ...
    mergeBlobsAcrossSlicesFN, getOverlapAndFeaturesFN) 
disp('Features Generated');

loniclassifierFN = 'loniclass.mat';     
loniclassifier(getOverlapAndFeaturesFN, loniclassifierFN) 
disp('Accuracy Numbers Calculated');


uploadDetections(loniclassifierFN, mergeBlobsAcrossSlicesFN) 
disp('Annotations Uploaded');

emailAnish; 
