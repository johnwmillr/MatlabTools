function histrgb(im)
% HISTRGB plots a histogram of an RGB image's individual RGB components
%
%	INPUT
%       im: RGB image
%
%   See also HIST, IMHIST
%
% John W. Miller -- from online somewhere
% 12-Sep-2016

% Extract the RGB components
[Red, Green, Blue] = deal(im(:,:,1),im(:,:,2),im(:,:,3));

% Get histValues for each channel
[yRed,x] = imhist(Red);
yGreen = imhist(Green);
yBlue  = imhist(Blue);

% Plot them together in one plot
plot(x, yRed, 'Red', x, yGreen, 'Green', x, yBlue, 'Blue')

end % End of main