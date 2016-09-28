function [croppedData, windowTime] = cropOnEvents(data, eventIdxs, fs, window)
% CROPONEVENTS splits up a data vector into a time window around event indices
%
%   INPUT
%       data:      Row or column vector of data
%       eventIdxs: Indicies in 'data', corresponding to events to crop around
%       fs:        Sampling rate of 'data'
%       window:    Crop window around events, -- [pre post] (ms)
%
%   OUTPUT
%       croppedData: [length(window) x n_events]
%       windowTime:  [length(window) x 1] -- time vector for 'croppedData'
%
%   Usage:
%       For example, extract each action potential from a spike train data vector.
%       Or, could be used to isolate a region of EMG activity around each nerve
%       stimulus.
%
%   John W. Miller
%   2015-01-23

%%
    % Create the time vector
fs = fs/1000;    % Convert Hz to miliHz b/c 'window' is in ms
pre  = window(1);
post = window(2);
region = (round(-pre*fs):round(post*fs))';
windowTime = (region/fs);

% Throw out nans
eventIdxs(isnan(eventIdxs)) = [];

% Crop the data
mask_region  = bsxfun(@plus,eventIdxs',region);
try croppedData = data(mask_region);
catch
    mask_region = mask_region(:,1:end-1);    
    croppedData = data(mask_region);
end


end