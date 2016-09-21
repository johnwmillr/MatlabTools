function varargout = dls(dirToList)
% DLS is a wrapper for disp(ls) to display a column of items in the current directory
%
%	INPUT
%       dirToList: Optional, lists the specified directory
%
% John W. Miller
% 2015-03-17
%

if nargin < 1
    dirToList = '.';
end

disp(pwd)
if ispc
    listing = ls(dirToList);
    
    if nargout > 0
        varargout{1} = listing;
    else
        disp(listing);
    end
else
    eval(sprintf('!ls -l %s',dirToList))
end

end