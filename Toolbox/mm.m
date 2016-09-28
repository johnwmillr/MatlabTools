function varargout = mm(x)
% MM returns the minimum and maximum value of the passed in array
%
%	INPUT
%       x: Any vector
%
%	OUTPUT
%       minAndMax: [min(x) max(x)]
%
% John W. Miller
% 2015-09-20

[minAndMax(1),idxs(1)] = min(x);
[minAndMax(2),idxs(2)] = max(x);

if nargout < 2
    varargout{1} = minAndMax;
elseif nargout == 2
    varargout{1} = minAndMax(1);
    varargout{2} = minAndMax(2);    
elseif nargout == 4
    [varargout{1}, varargout{2}] = deal(minAndMax(1), idxs(1));
    [varargout{3}, varargout{4}] = deal(minAndMax(2), idxs(2));
end

end % End of main