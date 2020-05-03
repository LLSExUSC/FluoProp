function filename = getFilenameInPath(path)
% Returns all characters after the last '\' character. 
%Usually this is the filename, including the extension.
%Example:
%    path = 'C:\Users\Andrew\Documents\MATLAB\general.txt'
%filename = 'general.txt'

delimiterI = strfind(path, filesep);
filename = path((delimiterI(end)+1):end);