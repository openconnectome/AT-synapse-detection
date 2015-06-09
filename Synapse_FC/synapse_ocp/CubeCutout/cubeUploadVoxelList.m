function cubeUploadVoxelList(server, token, rvolume, protoRAMON, useSemaphore)

% W. Gray Roncal

% Function to upload objects in a RAMON volume as a voxelList

% Requires that all objects begin from a common prototype, and that
% RAMONVolume has appropriate fields (in particular resolution and XYZ
% offset)
% This only supports anno32 data for now and the preserve anno option

if useSemaphore
    oo = OCP('semaphore');
else
    oo = OCP;
end

oo.setServerLocation(server);
oo.setAnnoToken(token);

% Load data volume
if ischar(rvolume)
    load(rvolume) %should be saved as cube
else
    cube = rvolume.clone;
end

zz = relabel_id(cube.data);

rp = regionprops(zz,'PixelIdxList');

%% Upload RAMON objects as voxel lists with preserve write option
fprintf('Creating RAMON Objects...');
objects = cell(length(rp),1);
numberOfObj = length(rp); 
for ii = 1:length(rp)
    
    s = eval(protoRAMON);
    s.clearDynamicMetadata; %TODO Clone issue
    s.setDataType([]); %TODO Clone issue
    
    s.setDataType(eRAMONDataType.anno32);
    s.setXyzOffset(cube.xyzOffset);
    s.setResolution(cube.resolution);
    
    [r,c,z] = ind2sub(size(cube.data),rp(ii).PixelIdxList);
    voxel_list = cat(2,c,r,z);
    
    s.setVoxelList(cube.local2Global(voxel_list));
    
    % Approximate absolute centroid
    approxCentroid = cube.local2Global(round(mean(voxel_list,1)));
    
    %metadata - for convenience
    s.addDynamicMetadata('approxCentroid', approxCentroid);
    
    disp([ii, numberOfObj]); 
    
    objects{ii} = s;
    clear s
end
%%
if ~isempty(rp)
    
    fprintf('Uploading %d objects\n\n',length(objects));
    
    for n = 2:length(objects) 
    ids = oo.createAnnotation(objects{1}, eOCPConflictOption.preserve);
    
        fprintf('Uploaded object id: %d\n',ids);
    
    end 

else
    fprintf('No Objects Detected\n');
end