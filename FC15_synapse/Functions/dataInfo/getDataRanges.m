function [r, c, z] = getDataRanges(oo)
resolution = 0; %#FIXME
ranges = oo.imageInfo.DATASET.IMAGE_SIZE(resolution);
offset = oo.imageInfo.DATASET.OFFSET(resolution);

r = offset(1):ranges(2);
c = offset(2):ranges(1);
zrange = ranges(3);
z = offset(3):zrange;

% THIS IS FOR WEILER DATASET 
% r = 1250:1550; 
% c = 1250:1550; 
% z = 2:8; 

end 