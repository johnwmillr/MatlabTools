function [mew,sig] = mewsig(x)
% MEWSIG returns the mean and standard deviation of x.
%
%	INPUT
%       x: Vector
%
%	OUTPUT
%       mew: Mean of x.
%       sig: Standard deviation of x.
%   
%   See also MEAN, STD
%
% John W. Miller
% 15-Jun-2016

[mew,sig] = deal(mean(x),std(x));

end % End of main