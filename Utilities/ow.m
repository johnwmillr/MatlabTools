function ow(varargin)
%% OW - Open current directory in Windows Explorer or Finder
%
%   INPUT (Optional):
%       Max inputs: 1 (pick A or B)
%       A) Input a specific directory to open in the OS file browser
%       B) Input a .m Mat file and open to its enclosing folder (a function or script)
%
% John W. Miller
% 2014-10-2

% Determine which directory we'll be opening
if nargin
    userArg = varargin{1};
    if regexp(userArg,'built-in\ (') == 1
        userArg = fileparts(userArg(11:end-1));
    end
    if isdir(userArg)
        dirToOpen = userArg;
    elseif ~isempty(which(userArg))
        dirToOpen = fileparts(which(userArg));
    else
        fprintf('The directory or file ''%s'' does not exist.\n',userArg)
        return
    end
else
    dirToOpen = pwd;
end

% Open in OS's file browser
if ispc
    winopen(dirToOpen)
elseif ismac
    dirToOpen = strrep(dirToOpen,' ','\ ');
    eval(sprintf('!open %s', dirToOpen));
else
    disp('What kind of computer are you using??')
end

end