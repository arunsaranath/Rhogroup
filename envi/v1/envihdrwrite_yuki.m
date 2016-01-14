function envihdrwrite_yuki(info,hdrfile)
% ENVIHDRWRITE read and return ENVI image file header information.
%   INFO = ENVIHDRWRITE(info,'HDR_FILE') writes the ENVI header file
%   'HDR_FILE'. Parameter values are provided by the fields of structure
%   info.
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
%     info = enviwrite('my_envi_image2.hdr');
%
% Felix Totir

params=fieldnames(info);

fid = fopen(hdrfile,'w');
fprintf(fid,'%s\n','ENVI');

activeFieldList = {'description','samples','lines','bands','header offset',...
    'file type','data type','interleave','sensor type','byte order',...
    'map info','projection info','wavelength units','pixel size','band names','default bands'};
% the actveFieldList are created by Yuki Jan. 12,2015
% envihdrread_yuki.m

for idx=1:length(params)
    param = params{idx};
    value = getfield(info,param);
    param(findstr(param,'_')) = ' '; %automatic name
    
    if strcmp(param,'wavelength')
        val_str = sprintf('%f,\n',value);
        val_str = ['{' val_str(1:end-2) '}'];
        line=[param,' = ',val_str];
    elseif strcmp(param,'map info')
        val_str = sprintf('{%s,%d,%d,%2.13f,%2.13f,%1.15e,%1.15e,%s,units=%s}',...
            value.projection,value.image_coords(1),value.image_coords(2),...
            value.mapx,value.mapy,value.dx,value.dy,value.datum,value.units);
        line=[param,' = ',val_str];
    elseif any(strcmpi(param,activeFieldList))
        line=[param,' = ',num2str(value)];
    end
    % the cases are created by Yuki Jan. 12, 2015 for customized
    % envihdrread_yuki.m
    
    fprintf(fid,'%s\n',line);
    
end

fclose(fid);

