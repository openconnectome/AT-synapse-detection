function listOfMatFiles = downloadCubeData(oo,  server, imageToken, ...
    channelList, qdownloadLocation, downloadLocationBase, resolution)
% Manages the downloading of IF Channels as 'data cubes'
% INPUTS
% oo - ocp object
% server - string of oo server location
% imageToken - string of image token
% channelList - cell array of strings (names of channels)
% qdownloadLocation - string, query download location
% downloadLocationBase - string, location to download cubes
% resolution - int, OCP data resolution
% OUTPUTS
% listOfMatFiles - cell array of strings, location of each data cube

cubeListFile = 'test.list';

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
        downloadLocation = strcat(downloadLocationBase, channelName{1}, num2str(n));
        cubeCutout(imageToken, tline(1:end-4), downloadLocation)
        tline = fgets(fid);
        n = n + 1;
        
        listOfMatFiles{k} = downloadLocation;
        k = k + 1;
    end
    fclose(fid);
    
end
