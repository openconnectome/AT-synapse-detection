function rvolume = getRamonVolumeFromIds(oo, psd_ids, CC, resolution) 
% Create RAMON Volume from a given set of punctas 
% INPUTS 
% psd_ids - vector, indexes to use 
% CC - Connected components object 
% OUTPUTS 
% rvolume - RAMON Volume with puncta's labeled 

data = zeros(CC.ImageSize); 

for n=1:length(psd_ids) 
    
[r, c, z] = ind2sub(CC.ImageSize, CC.PixelIdxList{psd_ids(n)});
for i=1:length(r)
        data(r(i), c(i), z(i)) = psd_ids(n);
end

end

ranges = double(oo.imageInfo.DATASET.SLICERANGE);
rvolume = RAMONVolume(); 
rvolume.setResolution(resolution); 
rvolume.setCutout(data); 
rvolume.setXyzOffset([0, 0, ranges(1)]); 

end
