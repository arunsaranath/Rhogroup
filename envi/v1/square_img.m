function [samples, lines] = square_img(img_hdr_path, img_data_path, img_settings_path, img_type, interpolation_type)
% [ samples, lines ] = square_img( img_hdr_path, img_data_path, img_settings_path, img_type, interpolation_type )
% read a band image of hyperspectral data.
%   Inputs:
%       img_hdr_path: file path to the image header file
%       img_data_path: file path to the image data file
%       img_settings_path: file path to the camera settings file
%       img_type: either 'vnir' or 'swir'
%       interpolation_type: can be 'nearest', 'bilinear', or 'bicubic'
%
%   Outputs:
%       The new dimensions of the square image
%       samples: number of samples in each column--this will be different
%       lines: number of lines in each row--this will be the unchanged

img_data_square_output_path = strcat(img_data_path, '_square');

img_info = envihdrread_yuki(img_hdr_path);
img_settings = enviSettingsRead(img_settings_path);

if ~isfield(img_settings, 'Frame_periodms')
    error('Settings File does not contain field {Frame_periodms}');
end

if ~isfield(img_settings, 'Images_per_row')
    error('Settings File does not contain field {Images_per_row}');
end

if ~isfield(img_settings, 'Speed_degs')
    error('Settings File does not contain field {Speed_degs}');
end

% throw an error if image interleaving is not BSQ
if ~strcmp(lower(img_info.interleave), 'bsq')
    error(['Image interleaving must be of type {bsq}. Received: {', img_info.interleave, '}']);
end

switch img_type
    case {'vnir'}
        fl = 22.5;
        fpa = 10.4;
        
    case {'swir'}
        fl = 25.0;
        fpa = 9.216;
        
    otherwise
        error(['Image type must be of type {vnir} or {swir}. Received: {', img_type, '}']);
end

% calculate correction only for the vertical direction
fov = (360/pi)*atan(fpa/(2*fl));
y_correction_factor = ((1000/(img_settings.Frame_periodms*img_settings.Images_per_row))*(1/img_settings.Speed_degs)) / (img_info.samples/fov);

switch img_info.data_type
    case {1}
        write_format = 'int8';
    case {2}
        write_format= 'int16';
    case{3}
        write_format= 'int32';
    case {4}
        write_format= 'float'; %maybe necessary float32
        format2='single';
    case {5}
        write_format= 'double';
    case {6}
        disp('>> Sorry, Complex (2x32 bits)data currently not supported');
        disp('>> Importing as double-precision instead');
        write_format= 'double';
    case {9}
        error('Sorry, double-precision complex (2x64 bits) data currently not supported');
    case {12}
        write_format= 'uint16';
    case {13}
        write_format= 'uint32';
    case {14}
        write_format= 'int64';
    case {15}
        write_format= 'uint64';
    otherwise
        error(['File type number: ',num2str(dtype),' not supported']);
end

switch img_info.byte_order
    case {0}
        write_machine = 'ieee-le';
    case {1}
        write_machine = 'ieee-be';
    otherwise
        write_machine = 'n';
end

% open new file to write to
write_file_id = fopen(img_data_square_output_path, 'a');

for i = 1 : img_info.bands
    img_data = lazyEnviReadb(img_data_path, img_info, i);
    
    lines = uint32(size(img_data, 1));
    samples = uint32(size(img_data, 2)*y_correction_factor);
    
    resized_img_data = imresize(img_data, [lines samples], interpolation_type)';
    resized_img_data = reshape(resized_img_data, (lines*samples), 1);
    
    disp(['writing band ' sprintf('%d', i)]);
    fwrite(write_file_id, resized_img_data, write_format, 0, write_machine);
end

fclose(write_file_id);


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


function info = enviSettingsRead(settings_file)
% ENVISETTINGSREAD reads settings data for HEADWALL cameras
%   INFO = ENVISETTINGSREAD('HDR_FILE') reads the ASCII settings file and 
%   returns all the information in a structure of parameters.
%
%   Example:
%   >> info = enviSettingsRead('settings.txt')
%   info =
%          description: [1x101 char]
%

cmout = '^;.*$';
fid = fopen(settings_file);
while true
    line = fgetl(fid);
    if line == -1
        break
    else
        line = strrep(line, ')', '');
        line = strrep(line, '(', '');
        line = strrep(line, '/', '');
        line = strrep(line, '\', '');
        
        eqsn = findstr(line,'=');
        if ~isempty(eqsn)
            if isempty(regexp(line,cmout))
                param = strtrim(line(1:eqsn-1));
                param(findstr(param,' ')) = '_';
                value = strtrim(line(eqsn+1:end));
                if isempty(str2num(value))
                    if ~isempty(findstr(value,'{')) && isempty(findstr(value,'}'))
                        while isempty(findstr(value,'}'))
                            line = fgetl(fid);
                            value = [value,strtrim(line)];
                        end
                    end
                    info.(param)=value;
    %                 eval(['info.',param,' = ''',value,''';'])
                else
                    eval(['info.',param,' = ',value,';']);
                end
            end
        end
    end
end
fclose(fid);


function info = envihdrread_yuki(hdrfile)
% ENVIHDRREAD Reads header of ENVI image.
%   INFO = ENVIHDRREAD('HDR_FILE') reads the ASCII ENVI-generated image
%   header file and returns all the information in a structure of
%   parameters.
%
%   Example:
%   >> info = envihdrread('my_envi_image.hdr')
%   info =
%          description: [1x101 char]
%              samples: 658
%                lines: 749
%                bands: 3
%        header_offset: 0
%            file_type: 'ENVI Standard'
%            data_type: 4
%           interleave: 'bsq'
%          sensor_type: 'Unknown'
%           byte_order: 0
%             map_info: [1x1 struct]
%      projection_info: [1x102 char]
%     wavelength_units: 'Unknown'
%           pixel_size: [1x1 struct]
%           band_names: [1x154 char]
%
%   NOTE: This function is used by ENVIREAD to import data.

% Ian M. Howat, Applied Physics Lab, University of Washington
% ihowat@apl.washington.edu
% Version 1: 19-Jul-2007 00:50:57
% Modified by Felix Totir
cmout = '^;.*$';
fid = fopen(hdrfile);
while true
    line = fgetl(fid);
    if line == -1
        break
    else
        eqsn = findstr(line,'=');
        if ~isempty(eqsn)
            if isempty(regexp(line,cmout))
                param = strtrim(line(1:eqsn-1));
                param(findstr(param,' ')) = '_';
                value = strtrim(line(eqsn+1:end));
                if isempty(str2num(value))
                    if ~isempty(findstr(value,'{')) && isempty(findstr(value,'}'))
                        while isempty(findstr(value,'}'))
                            line = fgetl(fid);
                            value = [value,strtrim(line)];
                        end
                    end
                    info.(param)=value;
    %                 eval(['info.',param,' = ''',value,''';'])
                else
                    eval(['info.',param,' = ',value,';'])
                end
            end
        end
    end
end
fclose(fid);

if isfield(info,'map_info')
    line = info.map_info;
    line(line == '{' | line == '}') = [];
    
    %originally: line = strtrim(split(line,','));
    %replaced by
    line=textscan(line,'%s','Delimiter',','); %behavior is not quite the same if "line" ends in ','
    % the above line is modified by Yuki.
    line=line{:};
    line=strtrim(line);
    %
    
    info.map_info = [];
    info.map_info.projection = line{1};
    info.map_info.image_coords = [str2num(line{2}),str2num(line{3})];
    info.map_info.mapx = str2num(line{4});
    info.map_info.mapy = str2num(line{5});
    info.map_info.dx  = str2num(line{6});
    info.map_info.dy  = str2num(line{7});
    if length(line) == 9
        info.map_info.datum  = line{8};
        info.map_info.units  = line{9}(7:end);
    elseif length(line) == 11
        info.map_info.zone  = str2num(line{8});
        info.map_info.hemi  = line{9};
        info.map_info.datum  = line{10};
        info.map_info.units  = line{11}(7:end);
    end
    
    %part below comes form the original enviread
    %% Make geo-location vectors
    xi = info.map_info.image_coords(1);
    yi = info.map_info.image_coords(2);
    xm = info.map_info.mapx;
    ym = info.map_info.mapy;
    %adjust points to corner (1.5,1.5)
    if yi > 1.5
        ym =  ym + ((yi*info.map_info.dy)-info.map_info.dy);
    end
    if xi > 1.5
        xm = xm - ((xi*info.map_info.dy)-info.map_info.dx);
    end
    
    info.x= xm + ((0:info.samples-1).*info.map_info.dx);
    info.y = ym - ((0:info.lines-1).*info.map_info.dy);
end

if isfield(info,'pixel_size')
    line = info.pixel_size;
    line(line == '{' | line == '}') = [];
    
    %originally: line = strtrim(split(line,','));
    %replaced by:
    line=textscan(line,'%s',','); %behavior is not quite the same if "line" ends in ','
    line=line{:};
    line=strtrim(line);
    
    info.pixel_size = [];
    info.pixel_size.x = str2num(line{1});
    info.pixel_size.y = str2num(line{2});
    info.pixel_size.units = line{3}(7:end);
end

if isfield(info,'wavelength')
    info.wavelength = sscanf(info.wavelength(2:end-1),'%f,')';
end









