function createOCPObject(outputFileName) 

% OCP Settings
resolution = 0;
server = 'http://openconnecto.me/';

bitmask_token = 'collman_silane_mask_anno';
anno_token = 'collman_silane_truthlabels'; 
upload_anno_token = 'silane_upload_test';
imageToken = 'collman15';
primaryIFChannel = {'PSD95_488'};

% Initialize API objects
oo = OCP();
oo.setDefaultResolution(resolution);

% Set server location and token
oo.setServerLocation(server);
oo.setImageToken(imageToken);
oo.setAnnoToken(anno_token);
oo.makeAnnoWritable();

% List of IF Channels names
channelList = oo.getChannelList;
% 5 - NR1
% 6 - PSDr
% 8 - VGluT1
% 11 - Synapsin
%channelList = channelList([5, 6, 8, 11]);
channelList = channelList([10, 11, 12, 13]);


save(outputFileName); 

end  
