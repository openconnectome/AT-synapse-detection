function maskimg = downloadMasks(oo, slicenum, resolution) 
% Download Masks

% Settings

ranges = oo.imageInfo.DATASET.IMAGE_SIZE(resolution);
xrange = [0, ranges(1)-1]; %FIXME
yrange = [0, ranges(2)-1];
zrange = [slicenum, slicenum+1]; 

q = OCPQuery(eOCPQueryType.annoDense);
q.setResolution(resolution);
q.addIdListPredicate(eOCPPredicate.type, eRAMONAnnoType.generic);

% specify the image cube to download
q.setXRange(xrange);
q.setYRange(yrange);
q.setZRange(zrange);

maskimg = oo.query(q); 
maskimg = double(maskimg.data);
maskimg = im2bw(maskimg, graythresh(maskimg));

end 
