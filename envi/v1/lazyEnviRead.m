function [ spc ] = lazyEnviRead( datafile,info,sample,line )
% [ spc ] = lazyEnviRead( datafile,info,sample,line )
% read one spectrum at specified location [sample, line]
%   Inputs:
%       datafile: file path to the image file
%       info: info object returned by envihdrread(hdrfile)
%       sample: coordinate in the cross-track direction, integer
%       line: coordinate in the along-track direction
%   Outputs:
%       spc: spectral signature at [sample, line], numerical array with
%       the size bands x 1. 

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
if strcmp(interleave,'bil')
    spc = zeros(bands,1);
    offset = s*(samples*(line-1)*bands+(sample-1));
    skip = s*(samples-1);
    fid = fopen(datafile);
    fseek(fid, offset, -1);
    for b = 1:bands
        spctmp = fread(fid,1,typeName,skip);
        spc(b) = spctmp;
    end
elseif strcmp(interleave,'bsq')
    spc = zeros(bands,1);
    skip = s*(lines*samples-1);
    offset = s*(sample-1)+s*(line-1)*samples;
    fid = fopen(datafile);
    fseek(fid, offset, -1);
    for b = 1:bands
        spctmp = fread(fid,1,typeName,skip);
        spc(b) = spctmp;
    end
end



end

