function downloadCubes(outputFileName, qdownloadLocation) 
% This function manages the downloading of the data cubes. 


% OCP Settings
syn_settings;



cubeListFile = 'test.list'; 

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
channelList = channelList(channel_ids);


% Download entire dataset
ranges = oo.imageInfo.DATASET.IMAGE_SIZE(resolution);
N_rows = ranges(2);
M_cols = ranges(1);
zrange = double(oo.imageInfo.DATASET.SLICERANGE);
numfiles = zrange(2) - zrange(1) + 1;

%Each cube should be 1GB
zSpan = floor(numfiles /((N_rows * M_cols * numfiles) / (10^9)));

if (zSpan > numfiles) 
    zSpan = numfiles; 
end 

listOfMatFiles = cell(length(channelList)*(numfiles/zSpan), 1);

k = 1;
for m = 1:length(channelList)

    channelName = channelList(m);
    cubeCutoutPreprocess(server, imageToken, channelName, resolution, ...
        0, M_cols, 0, N_rows, zrange(1), zrange(2)+1,...
        M_cols, N_rows, zSpan, ...
        cubeListFile, qdownloadLocation, 0)
    
    fid = fopen(cubeListFile);
    tline = fgets(fid);
    n = 1;
    while ischar(tline)
        downloadLocation = strcat(qdownloadLocation, filesep, channelName{1}, num2str(n));
        cubeCutout(imageToken, tline(1:end-4), downloadLocation)
        tline = fgets(fid);
        n = n + 1;
        
        listOfMatFiles{k} = downloadLocation;
        k = k + 1;
    end
    fclose(fid);
    disp(m)
end

save(outputFileName, 'listOfMatFiles'); 

end 

