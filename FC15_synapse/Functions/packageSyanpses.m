function synapses = packageSyanpses(CC, predicted_positive_detection, chan, res) 

pixelidlist = CC.PixelIdxList;

pixelidlist = pixelidlist(predicted_positive_detection);
synapses = cell(length(pixelidlist), 1);
synapses_list_ind = 1;

for n=1:length(pixelidlist)
    
    % Some indexes were skipped
    if (isempty(pixelidlist{n}))
        continue;
    end
    
    [r, c, z] = ind2sub(CC.ImageSize, pixelidlist{n});
    
    % Create bounding box
    rOffset = min(r);
    cOffset = min(c);
    zOffset = min(z);
    
    minR = min(r);
    minC = min(c);
    minZ = min(z);
    
    if (minR > 1)
        r = r - minR + 1;
    end
    if (minC > 1)
        c = c - minC + 1;
    end
    if (minZ > 1)
        z = z - minZ + 1;
    end
    
    % Create bounding box
    minR = min(r); maxR = max(r);
    minC = min(c); maxC = max(c);
    minZ = min(z); maxZ = max(z);
    
    
    box = zeros(maxR, maxC, maxZ);
    for i=1:length(r)
        box(r(i), c(i), z(i)) = 255;
    end
    
    offsetvector = [cOffset - 1, rOffset - 1, zOffset + 30];
    temp_synapse = RAMONSynapse();
    temp_synapse.setChannelType(eRAMONChannelType.annotation); %define channel type
    temp_synapse.setDataType(eRAMONChannelDataType.uint32); %define data type
    temp_synapse.setChannel(chan); %pick a channel
    temp_synapse.setCutout(box); %set the annotation data
    temp_synapse.setXyzOffset(offsetvector); %set the offset (i.e. where the data is placed)
    temp_synapse.setResolution(res);
    
    temp_synapse.setSynapseType(eRAMONSynapseType.excitatory);
    
    synapses{synapses_list_ind} = temp_synapse;
    synapses_list_ind = synapses_list_ind + 1;
    
end

synapses(synapses_list_ind:end) = [];

end
