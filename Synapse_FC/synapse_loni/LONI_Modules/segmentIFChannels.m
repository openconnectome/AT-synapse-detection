function segmentIFChannels(inputMatFile1, inputMatFile2, outputFileName) 
% This function extracts features from the other IF Channels 
% Load CC into workspace 
load(inputMatFile1); 

%load list of mat files 
load(inputMatFile2); 

signalthresh = 0.025 * 256;

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


% Determine properties of other IF Channels
IF_CC_stats = cell(length(channelList), 1);

generateCC = false;
for n = 1:length(channelList)
    
    [~, CC_stats] = segment_vstack(oo, channelList(n), ...
        bitmask_token, signalthresh, resolution, listOfMatFiles, channelList, generateCC, CC);
    IF_CC_stats{n} = CC_stats;
    
end

save(outputFileName, 'IF_CC_stats'); 


end 

