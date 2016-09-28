function varargout = printcell(cell_to_print,delim)
% PRINTCELL 
%
%	INPUT
%
%
%
%	OUTPUT
%
%
% John W. Miller
% 02-Jul-2016

if nargin < 2
    delim = sprintf('\n');    
else
    delim = sprintf(delim);
end

clear cell_as_string
cell_as_string = cell_to_print{1};
for i = 2:length(cell_to_print)
    cell_as_string = [cell_as_string sprintf('%s%s',delim,cell_to_print{i})];    
end

if nargout > 0
    varargout{1} = cell_as_string;
else
    disp(cell_as_string)
end
end % End of main