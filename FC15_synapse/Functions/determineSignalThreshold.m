% Determine signal threshold


%load('PSD95_11');
load('psdtest'); 

data = cube.data;


for st = 500:10:700
    CC = bwconncomp(data > st, 4);
    
    CC_stats = regionprops(CC, data, 'Area');
    
    areaVec = zeros(length(CC_stats), 1);
    
    for n = 1:length(CC_stats)
        
        areaVec(n) = CC_stats(n).Area;
        
    end
    
    fprintf('st: %d area: %f \n', st, .1*0.1*median(areaVec))
    
end
