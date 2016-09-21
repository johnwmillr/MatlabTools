function varargout = go(selectedDir,varargin)
%% GO cd's to specified (abbreviated) directory
%
%   INPUT
%       selectedDir: a nick name for a directory, Ex: "GO home"
%
%   OUTPUT
%       If an output is called, GO returns full path to selectedDir w/o CDing
%
%   Call GO without any inputs to see a list of valid abbreviations.
%
%  John W. Miller
%  2015-01-22 (ver_1)
%  2015-09-02 (ver_2)

%% Define your paths specific to Mac of PC
homeDir = fileparts(userpath);
if ismac
    homeDir = fullfile(homeDir,'Matlab');
    userDir = getenv('HOME');            
elseif ispc    
    userDir = [getenv('HOMEDRIVE') getenv('HOMEPATH')];    
else
    error('What kind of computer are you using??')
end

%% Define paths that work on both Mac and PC
%
%   THESE ARE JUST EXAMPLES, MUST BE SPECIFIED FOR EACH USER
%
matDir  = fullfile('Dropbox','Code','Matlab');
dataDir = fullfile(userDir,'Research','Data');              % Data drive
deskDir = fullfile(userDir,'Desktop');                      % Desktop
downDir = fullfile(userDir,'Downloads');                    % Downloads
utilDir = fullfile(userDir, matDir,'Utilities');            % Utilities
toolDir = fullfile(userDir, matDir, 'Toolbox');             % Matlab toolbox

%% Define the directory abbreviations
dirNames = struct();
dirNames = assignDir(dirNames,'home',homeDir,'Home');
dirNames = assignDir(dirNames,'data',dataDir);
dirNames = assignDir(dirNames,'desk',deskDir);
dirNames = assignDir(dirNames,'down',downDir);
dirNames = assignDir(dirNames,'util',utilDir);
dirNames = assignDir(dirNames,'tool',toolDir);

%% Check if user actually supplied a path
if nargin < 1
    fprintf('Must specify a directory.\n');
    fprintf('Options:\n');
    disp(fieldnames(dirNames))
    return
else
    selectedDir = lower(selectedDir);
end

% Find the correct directory
if ~any(strcmp(selectedDir,fieldnames(dirNames)))
    fprintf('Unrecognized directory abbreviation\n')
    fprintf('Options:\n');
    disp(fieldnames(dirNames))
    return
else
    targetDir = dirNames.(selectedDir).path;
    dirName   = dirNames.(selectedDir).name;
end

% Varargin -- Allow user to extend destination path with multiple inputs
nextDir = '';
if nargin > 1
    for n = 1:nargin-1;
        nextDir = [nextDir filesep varargin{n}]; %#ok<AGROW>
        dirName = [dirName nextDir];
    end
end
targetDir = [targetDir nextDir];

% Change Directories
if nargout == 0
    cd(targetDir);
    fprintf('Whoosh!\n')
    pause(0.2), home % Clear the command prompt
    disp([dirName ': ' pwd])
else
    varargout{1} = targetDir;
end
end % End of main function

%% --------------------------------------------
%               Internal Functions
%  --------------------------------------------

function s = assignDir(s,abrv,fullPath,varargin)
% ASSIGNDIR returns a modified struct to contain a directory name and path
%
%   Usage: dirNames = assignDir(dirNames,'down','C:\Users\John\Downloads')

% Allow user to specify a name
if nargin == 4
    fullName = varargin{1};
else
    [~,fullName]  = fileparts(fullPath);
end

s.(abrv).name = fullName;
s.(abrv).path = fullPath;
end