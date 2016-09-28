function subsets = randsubs(x,K)
% RANDSUBS returns K randomly selected subsets of the data in x.
%
%   Just learned that this already exists... datasample()
%
%	INPUT
%       x: Data vector.
%       k: Number of subsets to break x into. Default is 2.
%
%	OUTPUT
%       subsets: [sub_len x K] Matrix of the values randomly selected from 'x'
%
%   With tips from:
%   http://www.mathworks.com/matlabcentral/answers/202708-how-to-generate-two-subsets-randomly-from-a-matrix-without-repetition
%
%   See also DATASAMPLE
%
% John W. Miller
% 2015-08-25

% Divide into 2 subgroups by default
if nargin == 1
   K = 2; 
end

% Length(x)/K must be an integer
x_len = length(x);
sub_len = floor(x_len/K);
remainder = mod(x_len,sub_len);
if remainder ~= 0   
    warning('Removing last %d element(s) of x to fit into %d subdivisions.',mod(x_len,sub_len),K)    
    x = x(1:(end-mod(x_len,sub_len)));
    x_len = length(x);
end

% Reshape 'x' in order to be split into subsets
x = reshape(x,[sub_len,K]);

% Matrix same size as the new 'x', masking out the random indices
subidxs = reshape(randperm(x_len),[sub_len,K]);

% Split up 'x'
subsets = x(subidxs);

end % End of main