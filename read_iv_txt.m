function [vg,id] = read_iv_txt(filename, startRow, endRow)
%IMPORTFILE Import numeric data from a text file as column vectors.
%   [VARNAME1,VARNAME2] = IMPORTFILE(FILENAME) Reads data from text file
%   FILENAME for the default selection.
%
%   [VARNAME1,VARNAME2] = IMPORTFILE(FILENAME, STARTROW, ENDROW) Reads data
%   from rows STARTROW through ENDROW of text file FILENAME.
%
% Example:
%   [VarName1,VarName2] = importfile('171103_ndi_tol_along_test-21_J9.txt',22, 122);
%
%    See also TEXTSCAN.

% Auto-generated by MATLAB on 2017/11/06 09:46:07

%% Initialize variables.
delimiter = '\t';
if nargin<=2
    startRow = 22;
    endRow = inf;
end

%% Format for each line of text:
%   column1: double (%f)
%	column2: double (%f)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%f%f%*s%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to the format.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
textscan(fileID, '%[^\n\r]', startRow(1)-1, 'WhiteSpace', '', 'ReturnOnError', false);
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'TextType', 'string', 'ReturnOnError', false, 'EndOfLine', '\r\n');
for block=2:length(startRow)
    frewind(fileID);
    textscan(fileID, '%[^\n\r]', startRow(block)-1, 'WhiteSpace', '', 'ReturnOnError', false);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'TextType', 'string', 'ReturnOnError', false, 'EndOfLine', '\r\n');
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

%% Allocate imported array to column variable names
vg = dataArray{:, 1};
id = dataArray{:, 2};


