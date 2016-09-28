function newfun(fileName,useKeyValuePairs)
% NEWFUN - Creates a new .m file, following a pre-made template
%
%   INPUT (Optional)
%       fileName: Name of the new file to be created 
%       useKeyValuePairs: 1 or 0, decide whether you'll want to use key value pairs
%
%   OUTPUT
%       Writes a new Matlab function (.m file) in the current directory.
%
% John W. Miller
% 2015-01-27

if nargin < 2
    useKeyValuePairs = 0;
else
    if ischar(useKeyValuePairs)
        useKeyValuePairs = str2double(useKeyValuePairs);
    end
end

% Ask for a filename if none is supplied
if ~exist('fileName','var')
    fileName = input('Filename?\n','s');
end

% Strip .m if 'fileName' contains that ending
if strcmp(fileName(end-1:end),'.m')
    fileName = fileName(1:end-2);
end

% Check if file already exists
while or(exist(fileName,'file')==2,exist(fileName,'builtin')) ~= 0
    warning('The specified filename already exists.')
    create_anyway = strcmpi(input('Create file anyway? (y/n) ','s'),'y');
    if create_anyway
        break
    else
        disp('No file created.')
        return
    end    
end

%% Write the file
fileID = fopen([fileName '.m'],'w');
if useKeyValuePairs == 1
    fprintf(fileID,'function [] = %s(,varargin)\n',fileName);
else
    fprintf(fileID,'function [] = %s()\n',fileName);
end
fprintf(fileID,'%% %s \n',upper(fileName));
fprintf(fileID,'%%\n');
fprintf(fileID,'%%\tINPUT\n%%\n%%\n');
if useKeyValuePairs    
    fprintf(fileID,'%%\t\tOPTIONAL\n');
    fprintf(fileID,'%%\t\tvarName1:\n');
end
fprintf(fileID,'%%\n');
fprintf(fileID,'%%\tOUTPUT\n');
fprintf(fileID,'%%\n%%\n');
fprintf(fileID,'%% John W. Miller\n');
fprintf(fileID,'%% %s\n',date);
if useKeyValuePairs
    fprintf(fileID,repmat('\n',1,2));
    fprintf(fileID,'%% Key-value pair varargin\n');
    fprintf(fileID,'keys = {''varName1''}; default_values = {[]};\n');
    fprintf(fileID,'[var1] = parseKeyValuePairs(varargin,keys,default_values);');    
end
fprintf(fileID,repmat('\n',1,30));
fprintf(fileID,'end %% End of main');
fclose(fileID);

% Open the file for editing
edit(fileName)

end