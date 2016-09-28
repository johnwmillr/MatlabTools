function xScaled = normalize(x, newRange, dim)
% NORMALIZE returns 'x' normalized to range from the specified range (0 to 1 by default).
%
%	INPUT
%       x:   Single dimension vector to normalize (amplitude)
%       newRange: Specify the new min and max of 'x'(Optional, default: [0 1])
%       dim: Dimension to normalize (Optional, default: 1)       
%
%	OUTPUT
%       xScaled: Amplitude-normalized vector or matrix
%
%   TODO
%       Make it work for matrics of any orientation
%
% http://stackoverflow.com/questions/10364575/normalization-in-variable-range-x-y-in-matlab
%
% John W. Miller
% 2015-02-19

% RMS scaling
% n = 1.5;
% x(x>(rms(x)*n)) = rms(x)*n;

% Must be column vector
if size(x,2) > 1
    x = x';
end

% Varargin
if nargin == 1
    dim = 1;
    newRange = [0 1];
elseif nargin == 2
    dim = 1;
elseif nargin == 3
        % Check the specified dimension
    if dim > ndims(x)
        error('Specified dimension too large.')
    end    
end

% Subtract the minimum of each column and divide by the columns' range
x = bsxfun(@rdivide,bsxfun(@minus,x,min(x,[],dim)),range(x,dim));

% Then normalize to newRange:
scale_factor = range(newRange);
xScaled = (x*scale_factor) + newRange(1);

end