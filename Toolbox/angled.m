function p = angled(h)
%ANGLED  Phase angle (in degrees).
%   ANGLE(H) returns the phase angles, in degrees, of a matrix with
%   complex elements.  
%
%   Input:
%       Elements of H should be in RADIANS
%
%   Class support for input X:
%      float: double, single
%
%   See also ANGLE, ABS, UNWRAP.

%   Copyright 1984-2010 The MathWorks, Inc. 
%   John W. Miller
%   2016_04_01

p = (180/pi)*atan2(imag(h), real(h));


end % End of main