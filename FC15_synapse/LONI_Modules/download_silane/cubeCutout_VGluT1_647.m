function cubeCutout_VGluT1_647(outputFileName)
% Only used for matlab testing, not LONI 

server = 'openconnecto.me';
token = 'collman15';
channel = 'VGluT1_647';
resolution = 0;

xStart = 0;
xStop = 6305;
xSpan = xStop - xStart;

yStart = 0;
yStop = 4517;
ySpan = yStop - yStart;

zStart = 31;
zStop = 58;
zSpan = 27;

cubeListFile = 'test.list';
mergeListFile = 'test2.list';
cubeOutputDir = pwd;
mergeOutputDir = pwd;
useSemaphore = 0;
objectType = 0;
print_flag = 0;
shuffleFilesFlag = 0;
padX = 0;
padY = 0;
padZ = 0;
alignXY = 0;
alignZ = 0;
computeOptions = 0;

computeBlock(server, token, channel, resolution, ...
    xStart, xStop, yStart, yStop, zStart, zStop,...
    xSpan, ySpan, zSpan, ...
    padX, padY, padZ,...
    alignXY, alignZ, computeOptions, shuffleFilesFlag, ...
    cubeListFile, cubeOutputDir,...
    mergeListFile, mergeOutputDir, print_flag)

fid = fopen(cubeListFile);
tline = fgets(fid);

downloadLocation = strcat(cubeOutputDir, filesep, channel);

% end-4 is to remove the ".mat" portion of the file name 
cubeCutout(token, channel, tline(1:end-4), downloadLocation, ...
    useSemaphore, objectType, server)

save(outputFileName, 'downloadLocation'); 