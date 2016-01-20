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