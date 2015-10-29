function  pixellist = globalToLocalPixelList(pixellist, offset, ...
    globalVolSize, localVolSize)

[r, c, z] = ind2sub(globalVolSize, pixellist);

c = c - offset(1); % xOffset
r = r - offset(2); % yOffset
z = z - offset(3) + 1; % zOffset

%truncate synapses outside downloaded data
indC = find(c == globalVolSize(2));
indR = find(r == globalVolSize(1));

if ~isempty(indC)
    c(indC) = [];
    r(indC) = [];%FIXME
    z(indC) = [];
end

if ~isempty(indR)
    c(indR) = [];
    r(indR) = [];
    z(indR) = [];
end


pixellist = sub2ind(localVolSize, r, c, z);

end


