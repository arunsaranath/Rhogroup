function [ hsi_sub ] = lazyEnviReadx( datafile,info,sample_idxes,line_idxes,band_idxes)
% [ spc ] = lazyEnviReadx( datafile,info,sample,line,bands )
% read a subset of hyperspectral data. The spatial subset is defined by the
% samples and the lines and the spectral subset is defined by the bands. 
%   Inputs:
%       datafile: file path to the image file
%       info: info object returned by envihdrread(hdrfile)
%       sample_idxes: list of indices in the cross-track direction of the subset
%       lines_idxes: list of indices in the along-track direction of the subset
%       bands_idxes: list of indices in the spectral direction of the subset
%   Outputs:
%       hsi_sub: the subset of the hyperspectral data 
%                [lines x samples x bands]

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

nsample_idxes = length(sample_idxes);
nline_idxes = length(line_idxes);
nband_idxes = length(band_idxes);
hsi_sub = zeros([nline_idxes,nsample_idxes,bands],typeName);
if strcmp(interleave,'bil') % BIL type: sample -> band -> line
    hsi_sub = zeros([nline_idxes,nsample_idxes,bands],typeName);
    offset = s*(samples*bands*(line_idxes(1)-1)...
                +(sample_idxes(1)-1));
    skip_samples = s*(samples-nsample_idxes);
    fid = fopen(datafile);
    fseek(fid, offset, -1);
    for l=1:nline_idxes
        for b=1:bands
            hsi_sub(l,:,b) = fread(fid,nsample_idxes,typeName,0);
            fseek(fid,skip_samples,0);
        end
    end
elseif strcmp(interleave,'bsq') % sample -> line -> band
    hsi_sub = zeros([nline_idxes,nsample_idxes,bands],typeName);
    offset = s*(sample_idxes(1)-1)+s*(line_idxes(1)-1)*samples;
    skip_samples = s*(samples-nsample_idxes);
    skip_ls = s*(lines*samples-samples*nline_idxes);
    fid = fopen(datafile);
    fseek(fid, offset, -1);
    for b = 1:bands
        for l=1:nline_idxes
            hsi_sub(l,:,b) = fread(fid,nsample_idxes,typeName);
            fseek(fid,skip_samples,0);
        end
        fseek(fid, skip_ls, 0);
    end
end
% take spectral subset
hsi_sub = hsi_sub(:,:,band_idxes);
fclose(fid);
end
    


