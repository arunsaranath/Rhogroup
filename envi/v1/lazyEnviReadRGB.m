function [ imrgb ] = lazyEnviReadRGB( datafile,info,rgb)
% [ spc ] = lazyEnviReadb( datafile,info,band )
% read a band image of hyperspectral data.
%   Inputs:
%       datafile: file path to the image file
%       info: info object returned by envihdrread(hdrfile)
%       rgb: RGB bands to be read [R,G,B]
%   Outputs:
%       imrgb: the rgb image of the hyperspectral data at bth band 
%                [lines x samples x 3]

interleave = info.interleave;
samples = info.samples;
lines = info.lines;
header_offset = info.header_offset;
bands = info.bands;
data_type = info.data_type;
if data_type==12
    % unsigned int16
    s=2;
    typeName = 'uint16';
elseif data_type==4
    s=4;
    typeName = 'single';
end

imrgb = zeros([lines,samples,3],typeName);

for bidx=1:3
    imrgb(:,:,bidx) = lazyEnviReadb(datafile,info,rgb(bidx));
end

end
    


