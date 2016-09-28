function matZeroMean = submean(A,mew)
% SUBMEAN subtracts the mean from the supplied matrix. I know, one line, blah blah blah.
%
%	INPUT
%       A: matrix to subtract mean from
%       mew: (optional) A value to subtract from A, instead of A's mean    
%
%	OUTPUT
%       matZeroMean: 'A' with a mean of zero
%
%   TODO
%       Add support for arrays
%
% John W. Miller
% 2015-05-26
%

if sum(any(isnan(A))) > 0
    warning('Using NaNmean in submean() function.')
    valToSubtract = nanmean(A);
else
    valToSubtract = mean(A);
end

% Allow user to specify a value to subtract instead of A's mean
if nargin > 1
    if size(mew) == size(valToSubtract)
        valToSubtract = mew;        
    else
        valToSubtract = repmat(mew,size(nanmean(A)));
    end
end
matZeroMean = bsxfun(@minus,A,valToSubtract);

end