function uploadDetections(inputMatFile, input2) 
% Upload detections 

load(inputMatFile); 
load(input2); 

% OCP Settings
syn_settings;

% Initialize API objects
oo = OCP();
oo.setDefaultResolution(resolution);

% Set server location and token
oo.setServerLocation(server);
oo.setImageToken(imageToken);
oo.setAnnoToken(upload_anno_token);
oo.makeAnnoWritable();

% Create RAMON Volumes
rvolume = getRamonVolumeFromIds(oo, psd_ids, CC, resolution);

cubeUploadVoxelList(server, upload_anno_token, rvolume, 'RAMONSynapse', false)


end 