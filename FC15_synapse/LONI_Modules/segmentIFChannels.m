function segmentIFChannels(inputMatFile1, psd_fn, synapsin_fn, nr1_fn, vglut_fn, outputFileName)
% This function extracts features from the other IF Channels

% Load CC into workspace
load(inputMatFile1);

%load list of mat files
%load(inputMatFile2);
[server, imgToken, channelList, resolution] = getSettings();
[signalthresh, ~, ~] = getSignalTreshold();
[mask_token, mask_anno] = getMaskToken();

useMask = false;
generateCC = false;

load(nr1_fn, 'downloadLocation');
if ~exist('downloadLocation')
    downloadLocation = nr1_fn; 
end 
listOfMatFiles{1} = downloadLocation; 

load(vglut_fn, 'downloadLocation');
if ~exist('downloadLocation')
    downloadLocation = vglut_fn; 
end 
listOfMatFiles{2} = downloadLocation; 

load(synapsin_fn, 'downloadLocation');
if ~exist('downloadLocation')
    downloadLocation = synapsin_fn; 
end 
listOfMatFiles{3} = downloadLocation; 

load(psd_fn, 'downloadLocation');
if ~exist('downloadLocation')
    downloadLocation = psd_fn; 
end 
listOfMatFiles{4} = downloadLocation; 


% Determine properties of other IF Channels
IF_CC_stats = cell(length(channelList), 1);

for n = 1:length(channelList)
    
    [~, CC_stats] = segment_vstack(channelList{n}, useMask,...
        server, mask_token, mask_anno, imgToken, signalthresh, ...
        resolution, listOfMatFiles{n}, ...
        channelList, generateCC, CC);
    
    IF_CC_stats{n} = CC_stats;
    
end

save(outputFileName, 'IF_CC_stats');


end

