function downloadGroundTruth(outputFileName) 
% Download the truth labels 

[~, imgToken, channelList, resolution] = getSettings();

[server, token, channel] = getSynapseDownloadTokens();

[labels_CC, ~] = generateStatsFromLabels(server, resolution, imgToken,...
    channelList{1}, token, channel);

save(outputFileName, 'labels_CC'); 
end 