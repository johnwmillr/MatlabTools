function m = cell2num(C,EmptyString)
% M = CELL2NUM(C) converts a monodimensional cell array containing numeric and string
% values to a matrix containing only the numeric values. String values are converted
% to NaNs.
%
%	INPUT
%       c: Monodimensional cell to convert to a numerical matrix.
%       EmptyString: (optional) Specifies what the empty string marker is. Defaults
%       to '-';
%
%	OUTPUT
%       m: Numeric vector, values in 'c' matching 'EmptyString' are set to NaN
%
% Created by John W. Miller
% 2015-03-03
%
%   See also CELL2MAT, MAT2CELL, NUM2CELL

% Error out if there is no input argument
if nargin==0
    error(message('MATLAB:cell2mat:NoInputs'));
elseif nargin==1
    EmptyString = '-';
end

% Make sure 'C' is a column vector
if size(C,2) ~= 1
    C = C';
end

if isfloat(C)
    %warning('Matrix "c" is already a double')
    m = C;
    return
else
        % Identify the 'EmptyString' elements in 'c' which will be converted into NaNs
    n_elements = numel(C);
    nanMask = cellfun(@strcmp,C,repmat({EmptyString},n_elements,1));
    numMask = ~nanMask;
        % Assign values to 'm'
    m(nanMask,1) = NaN;
        % TODO: Fix this
    try m(numMask,1) = cellfun(@str2num,C(numMask));
    catch
        m(numMask,1) = cell2mat(C(numMask));
    end
end

end