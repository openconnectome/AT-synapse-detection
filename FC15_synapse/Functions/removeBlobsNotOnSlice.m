function [CC, indToRemove] = removeBlobsNotOnSlice(CC, slice) 

indToRemove = zeros(length(CC.PixelIdxList), 1); 
ind = 1; 
for n=1:length(CC.PixelIdxList) 
    
    [~, ~, z] = ind2sub(CC.ImageSize, CC.PixelIdxList{n}); 
    
    if isempty(find(z == slice, 1))
        indToRemove(ind) = n; 
        ind = ind + 1; 
    end 
end

indToRemove(ind:end) = []; 
CC.PixelIdxList(indToRemove) = []; 
CC.NumObjects = length(CC.PixelIdxList); 


end
