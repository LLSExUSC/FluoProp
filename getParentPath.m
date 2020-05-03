function parentPath = getParentPath(path)
% Gives the parent to the given directory. Equivalent to '..', but does not
% change the current directory, operates on the given string path.
%Example:
%      path = 'C:\Users\Andrew\Documents\MATLAB\general'
%parentPath = 'C:\Users\Andrew\Documents\MATLAB'

delimiterI = strfind(path, filesep);
parentPath = path(1:(delimiterI(end)-1));
