function [ imb ] = lazyEnviReadb( datafile,info,band)
% [ spc ] = lazyEnviReadb( datafile,info,band )
% read a band image of hyperspectral data.
%   Inputs:
%       datafile: file path to the image file
%       info: info object returned by envihdrread(hdrfile)
%       band: band to be read
%   Outputs:
%       imb: the band image of the hyperspectral data at bth band 
%                [lines x samples]

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

fid = fopen(datafile);

imb = zeros([lines,samples],typeName);
if strcmp(interleave,'bil') % BIL type: sample -> band -> line
    offset = s*(samples*(band-1));
    skips = s*samples*(bands-1);
    fseek(fid, offset, -1);
    for l=1:lines
        imb(l,:) = fread(fid,samples,typeName,0);
        fseek(fid,skips,0);
    end
elseif strcmp(interleave,'bsq') % sample -> line -> band
    offset = s*(samples*lines*(band-1));
    fseek(fid, offset, -1);
    imb = fread(fid,samples*lines,typeName);
    imb = reshape(imb,[samples,lines])';
end

fclose(fid);

end
    


