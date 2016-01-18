function [ flg ] = lazyEnviWriteb( dataFilePath, imgb,info,band,mode)
% [ spc ] = lazyEnviReadb( datafile,info,band )
% read a band image of hyperspectral data.
%   Inputs:
%       dataFilePath: file path to the image file
%       info: info object returned by envihdrread(hdrfile)
%       band: band to be read
%       mode: {'a','m'} 'a' append the data and 'm': modify the data
%             currently only 'a' is supported
%   Outputs:
%       flg: flag

switch info.data_type
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

switch info.byte_order
    case {0}
        write_machine = 'ieee-le';
    case {1}
        write_machine = 'ieee-be';
    otherwise
        write_machine = 'n';
end

% open new file to write to a file
imgb1d = reshape(imgb',[1 info.samples*info.lines]);
if strcmp(mode,'a')
    write_file_id = fopen(dataFilePath, 'a');
    fwrite(write_file_id, imgb1d, write_format, 0, write_machine);
    flg=1;
elseif strcmp(mode,'m')
    disp('>> mode "m" is currently not supported');
end
fclose(write_file_id);
end

