function [samples, lines] = square_img( img_hdr_path, img_data_path, img_settings_path, sli_hdr_path, sli_data_path, img_type, interpolation_type )
% [ samples, lines ] = square_img( img_hdr_path, img_data_path, img_settings_path, sli_hdr_path, sli_data_path, img_type, interpolation_type )
% read a band image of hyperspectral data.
%   Inputs:
%       img_hdr_path: file path to the image header file
%       img_data_path: file path to the image data file
%       img_settings_path: file path to the camera settings file
%       sli_hdr_path: file path to SLI header file
%       sli_data_path: file path to the SLI data file
%       img_type: either 'vnir' or 'swir'
%       interpolation_type: can be 'nearest', 'bilinear', or 'bicubic'
%
%   Outputs:
%       The new dimensions of the square image
%       samples: number of samples in each column--this will be different
%       lines: number of lines in each row--this will be the unchanged

img_data_square_output_path = strcat( img_data_path, '_square' );

img_info = envihdrread_yuki( img_hdr_path );
img_settings = enviSettingsRead( img_settings_path );

if ~isfield( img_settings, 'Frame_period_ms' )
    error( 'Settings File does not contain field {Frame_period_ms}' );
end

if ~isfield( img_settings, 'Images_per_row' )
    error( 'Settings File does not contain field {Images_per_row}' );
end

if ~isfield( img_settings, 'Speed_degs' )
    error( 'Settings File does not contain field {Speed_degs}' );
end

% throw an error if image interleaving is not BSQ
if ~strcmp( lower( img_info.interleave ), 'bsq' )
    error( ['Image interleaving must be of type {bsq}. Received: {', img_info.interleave, '}'] );
end

fl = img_settings.Lens_EFL_mm;

switch img_type
    case {'vnir'}
        fpa = 10.4;
        
    case {'swir'}
        fpa = 9.216;
        
    otherwise
        error( ['Image type must be of type {vnir} or {swir}. Received: {', img_type, '}'] );
end

% calculate correction only for the vertical direction
fov = ( 360 / pi ) * atan( fpa / ( 2 * fl ) );
x_correction_factor = 1;
y_correction_factor = ( (1000 / ( img_settings.Frame_period_ms * img_settings.Images_per_row ) ) * ( 1 / img_settings.Speed_degs ) ) / ( img_info.samples / fov );

% we only want to downsample data, so correct in whichever direction
% involves interpolation
if y_correction_factor > 1
    x_correction_factor = ( 1 / y_correction_factor );
    y_correction_factor = 1;
end

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
        disp( '>> Sorry, Complex (2x32 bits)data currently not supported' );
        disp( '>> Importing as double-precision instead' );
        write_format= 'double';
    case {9}
        error( 'Sorry, double-precision complex (2x64 bits) data currently not supported' );
    case {12}
        write_format= 'uint16';
    case {13}
        write_format= 'uint32';
    case {14}
        write_format= 'int64';
    case {15}
        write_format= 'uint64';
    otherwise
        error( ['File type number: ',num2str( dtype ),' not supported'] );
end

switch img_info.byte_order
    case {0}
        write_machine = 'ieee-le';
    case {1}
        write_machine = 'ieee-be';
    otherwise
        write_machine = 'n';
end

% Get normalization factors from SLI data file
norm_factors = enviread( sli_data_path, sli_hdr_path );

% open new file to write to
write_file_id = fopen( img_data_square_output_path, 'a' );

for i = 1 : img_info.bands
    img_data = lazyEnviReadb( img_data_path, img_info, i );% / mean( norm_factors( :, i ) );
    
    lines   = uint32( size( img_data, 1 ) * y_correction_factor );
    samples = uint32( size( img_data, 2 ) * x_correction_factor );
    
    resized_img_data = imresize( img_data, [lines samples], interpolation_type )';
    resized_img_data = reshape( resized_img_data, ( lines * samples ), 1 );
    
    disp( ['writing band ' sprintf( '%d', i )] );
    fwrite( write_file_id, resized_img_data, write_format, 0, write_machine );
end

fclose( write_file_id );