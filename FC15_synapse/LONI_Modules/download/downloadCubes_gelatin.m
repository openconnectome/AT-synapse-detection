function downloadCubes_silane(outputFileName, qdownloadLocation)
% This function manages the downloading of the data cubes.


[serverLocation, token, channelList, resolution] = getSettings();

channel = channelList{end};
computeOptions = 0;
shuffleFilesFlag = 0;
cubeListFile = 'testcubelist.list';
cubeOutputDir = pwd;
mergeListFile = 'testmergelist.list';
mergeOutputDir = pwd;
print_flag = 0;

oo = OCP();
oo.setDefaultResolution(resolution);
oo.setServerLocation(serverLocation);
oo.setImageToken(token);
oo.setImageChannel(channel);

% Download dataset

[r, c, z] = getDataRanges(oo); 
numfiles = length(z); 


%Each cube should be 1GB
zSpan = floor(numfiles /((length(r) * length(c) * numfiles) / (10^9)));

if (zSpan > numfiles)
    zSpan = numfiles;
end

listOfMatFiles = cell(length(channelList)*(numfiles/zSpan), 1);

xStart = c(1);
xStop = c(end)-1; 

yStart = r(1);
yStop = r(end)-1;

zStart = z(1);
zStop = z(end);

xSpan = xStop - xStart;
ySpan = yStop - yStart;

%zSpan = numfiles;
padX = 0;
padY = 0;
padZ = 0;
alignXY = 0;
alignZ = 0;
useSemaphore = 0;
serviceLocation = serverLocation;
objectType = 0; %ramon
outputFile = 'testoutput';


k = 1;
for ch_ind = 1:length(channelList)
    channel = channelList{ch_ind};
    
    
    
    
    computeBlock(serverLocation, token, channel, resolution, ...
        xStart, xStop, yStart, yStop, zStart, zStop+1,...
        xSpan, ySpan, zSpan, ...
        padX, padY, padZ,...
        alignXY, alignZ, computeOptions, shuffleFilesFlag, ...
        cubeListFile, cubeOutputDir,...
        mergeListFile, mergeOutputDir, print_flag)
    
    
    fid = fopen(cubeListFile);
    tline = fgets(fid);
    n = 1;
    
    while ischar(tline)
        downloadLocation = strcat(qdownloadLocation, filesep, channel, num2str(n));
        cubeCutout(token, channel, tline(1:end-4), downloadLocation, useSemaphore, objectType, serviceLocation)
        
        tline = fgets(fid);
        n = n + 1;
        
        listOfMatFiles{k} = downloadLocation;
        k = k + 1;
    end
    
    
    fclose(fid);
    
end

save(outputFileName, 'listOfMatFiles'); 
end

