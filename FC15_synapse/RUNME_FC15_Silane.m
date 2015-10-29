% FC 15 Silane Dataset RUNME 
% Contact: anish.simhal@duke.edu 

cubecutout_psd = 'cubecutout_psd.mat'; 
cubeCutout_PSD95_488(cubecutout_psd)
disp('psd downloaded');

cubecutout_nr1 = 'cubeCutout_nr1.mat'; 
cubeCutout_NR1594(cubecutout_nr1); 
disp('nr1 downloaded'); 

cubecutout_vglut = 'cubecutout_vglut'; 
cubeCutout_VGluT1_647(cubecutout_vglut); 
disp('Vglut downloaded'); 

cubecutout_synapsin = 'cubecutout_synapsin'; 
cubeCutout_Synapsin647(cubecutout_synapsin); 
disp('Synapsin Downloaded'); 

extractMainIFChannelBlobsFN = 'emifcb.mat'; 
extractMainIFChannelBlobs(cubecutout_psd, extractMainIFChannelBlobsFN); 
disp('Got PSD Blobs');

mergeBlobsAcrossSlicesFN = 'mbas.mat'; 
mergeBlobsAcrossSlices(extractMainIFChannelBlobsFN, mergeBlobsAcrossSlicesFN)
disp('mergeBlobsAcrossSlices'); 

segmentIFChannelsFN = 'sifc.mat'; 
segmentIFChannels(mergeBlobsAcrossSlicesFN, cubecutout_psd, cubecutout_synapsin, cubecutout_nr1, cubecutout_vglut, segmentIFChannelsFN);
disp('segmentIFChannels');

downloadGroundTruthFN = 'dgt.mat'; 
downloadGroundTruth(downloadGroundTruthFN)
disp('Ground Truth Loaded');

getOverlapAndFeaturesFN = 'goaf.mat'; 
getOverlapAndFeatures(downloadGroundTruthFN, segmentIFChannelsFN, mergeBlobsAcrossSlicesFN, getOverlapAndFeaturesFN) 
disp('Features Generated');

loniclassifierFN = 'loniclass.mat';     
loniclassifier(getOverlapAndFeaturesFN, loniclassifierFN) 
disp('Accuracy Numbers Calculated');

uploadDetections(loniclassifierFN, mergeBlobsAcrossSlicesFN, getOverlapAndFeaturesFN, downloadGroundTruthFN) 
disp('Annotations Uploaded');

emailAnish; 
