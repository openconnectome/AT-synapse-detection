function pixellist = ...
    getGlobalPixelIdList(s2, globalImageSize, zGlobalStartInd)
% This function manages the conversion from local to global coordinates 
% s2 - RAMONSyanpse 
% imageSize - vector, image dimensions 
% sliceOffset 


sydata = s2.data;
sydata = logical(sydata);
CC = bwconncomp(sydata, 4);

newpixelidlist = []; 
for n = 1:CC.NumObjects
    newpixelidlist = [newpixelidlist; CC.PixelIdxList{n}];
end 

[r, c, z] = ind2sub(CC.ImageSize, newpixelidlist);

%Bring synapse into global coordinates
c = s2.xyzOffset(1) + c; 
r = s2.xyzOffset(2) + r; 
z = s2.xyzOffset(3) + z - 1; 

pixellist = sub2ind(globalImageSize, r, c, z); 


end 
