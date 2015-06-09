function downloadGroundTruth(outputFileName) 
% Download the truth labels 

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



[labels_CC, ~] = generateStatsFromLabels(oo, anno_token);

save(outputFileName, 'labels_CC'); 
end 