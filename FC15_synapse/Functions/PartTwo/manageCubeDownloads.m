function manageCubeDownloads()
% Manage CubeDownloads

[serverLocation, token, channelList, resolution] = getSettings();



channel = channelList{1};
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

[r, c, ~] = getDataRanges(oo); 
numfiles = 11; 


%Each cube should be 1GB
zSpan = floor(numfiles /((length(r) * length(c) * numfiles) / (10^9)));

if (zSpan > numfiles)
    zSpan = numfiles;
end

listOfMatFiles = cell(length(channelList)*(numfiles/zSpan), 1);
%1250:1550
%xStart = 0;
xStart = 1250;
%xStop = M_cols;
xStop = 1550; 
% yStart = 0;
% yStop = N_rows;
yStart = 1250;
yStop = 1550;

zStart = 0;
zStop = numfiles;

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
        xStart, xStop, yStart, yStop, zStart, zStop,...
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


