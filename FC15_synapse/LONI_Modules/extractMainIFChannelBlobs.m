function extractMainIFChannelBlobs(inputMatFile, outputFileName)
% Get PSD Blobs

generateCC = true;
CC = [];

[server, imgToken, channelList, resolution] = getSettings();
[signalthresh, ~, ~] = getSignalTreshold();
[maskDownloadToken, maskDownloadChannel] = getMaskToken();

% In FC15, the 'focus' channel is PSD-95
focusChannel = channelList{end};
useMask = true;


load(inputMatFile, 'downloadLocation');
if ~exist('downloadLocation')
    downloadLocation = inputMatFile; 
end 


[CC, CC_stats] = segment_vstack(focusChannel, useMask,...
    server, maskDownloadToken, maskDownloadChannel, imgToken, signalthresh, ...
    resolution, downloadLocation, ...
    channelList, generateCC, CC);

save(outputFileName, 'CC', 'CC_stats');

end


