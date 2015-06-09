function extractMainIFChannelBlobs(inputMatFile, outputFileName) 
% Get PSD Blobs

generateCC = true;
CC = [];
signalthresh = 0.025 * 256;

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

%load listOfMatFiles 
load(inputMatFile); 



[CC, CC_stats] = segment_vstack(oo, primaryIFChannel, ...
    bitmask_token, signalthresh, resolution, listOfMatFiles, channelList, generateCC, CC);

save(outputFileName, 'CC', 'CC_stats'); 

end 


