function [onset_times, offset_times] = detectOnsets(raw_dat,raw_fs)
% DETECTONSETS returns the onset and offset times (in seconds) of a signal rising
% above a low baseline level.
%
%   INPUT:
%       raw_dat: Raw data to detect onsets/offsets. (Double)
%       raw_fs:  Sampling rate of raw_dat
%
%   OUTPUT:
%       onset_times:  Onset  times of each stimulus in raw_dat (sec)
%       offset_times: Offset times of each stimulus in raw_dat (sec)
%
%   Written for Phil Gander and Jeremy Greenlee
%
%   See also FINDPEAKS, BSXFUN
%
% John W. Miller
% 20-Jul-2016

% Obtain the envelope of the raw signal (this takes awhile, maybe unnecessary)
% y = hilbert(raw_dat);
% env = abs(y);
env = raw_dat;

% Downsample and low-pass filter the envelope
target_fs = 1000;
if raw_fs > target_fs
    scale = round(raw_fs/target_fs);
    dat = resample(max(env,0),1,scale); fs = raw_fs/scale;
end
dat = max(lowpass(dat,fs,50),0);

%% Perform the onset detection
threshold = rms(dat);
threshold_crossings = dat > threshold; % Data over the threshold
pos_idxs = find(diff([threshold_crossings; 0])>0); % Onset
neg_idxs = find(diff([threshold_crossings; 0])<0); % Offset

% Discard crossings that came too soon after a positive crossing
deadtime_after_pos = 0.4; % sec
idxs_after_pos = bsxfun(@plus,pos_idxs,1:fix(deadtime_after_pos*fs));
good_onset_idxs  = setdiff(pos_idxs,  idxs_after_pos);
good_offset_idxs = intersect(neg_idxs,idxs_after_pos);

% If there were a bunch of negative crossings, event was probably an artifact
bad_idxs = find(diff(good_offset_idxs)<100);
deadtime_around_artifact = fix(fs*0.3);
idxs_around_artifact = bsxfun(@plus,good_offset_idxs(bad_idxs),-deadtime_around_artifact:deadtime_around_artifact); %#ok<FNDSB>
good_onset_idxs  = setdiff(good_onset_idxs,  idxs_around_artifact);
good_offset_idxs = setdiff(good_offset_idxs, idxs_around_artifact);

% Convert idxs to time
[onset_times, offset_times] = deal(good_onset_idxs/fs,good_offset_idxs/fs);

%% Visualize
show_plot = 0;
if show_plot
    raw_t = ((0:length(raw_dat)-1)/raw_fs)';
    t = ((0:length(dat)-1)/fs)';
    figure, hold on, lw = 2;
    axs(1) = plot(raw_t,raw_dat,'k','linewidth',0.1);
    axs(2) = line(xlim,threshold*[1 1],'color','m','linewidth',lw);
    Xon  = t([good_onset_idxs good_onset_idxs]');   Yon  = repmat([0 max(raw_dat)],length(good_onset_idxs),1)';
    Xoff = t([good_offset_idxs good_offset_idxs]'); Yoff = repmat([0 max(raw_dat)],length(good_offset_idxs),1)';
    line(Xon,Yon,'color','g','linewidth',lw), line(Xoff,Yoff,'color','b','linewidth',lw)
    axs(3) = plot(t,dat,'r--','linewidth',2);
    xlabel('Time (s)','fontsize',18)    
    legend(axs,{'Raw data','Threshold','Envelope'},'location','best','fontsize',8)
end
end

%% ---------------------------------------------------------------------------
%                             Internal functions
%  ---------------------------------------------------------------------------
function xFilt = lowpass(x,fs,cutoff)
% LOWPASS performs a 4th order zero lag Butterworth filter
%
%	INPUT
%       x:  Data to be filtered
%       fs: Sampling frequency of data
%       cutoff: Cutoff frequency for the Butterworth filter (default = 7 Hz)
%
%	OUTPUT
%       xFilt: The filtered data
%
% John W. Miller
% 2015-09-11

x = double(x);

% Check for NaNs
if any(sum(isnan(x)))
    warning('Detected NaNs in x, replacing w/ nanmean.')
    mask_nans = any(isnan(x));
    sub_val = nanmean(nanmean(x(:,mask_nans)));
    x((isnan(x))) = sub_val; % Kludge
end

Wn = cutoff/(fs/2);
[b,a] = butter(4,Wn,'low');
xFilt = filtfilt(b,a,x);

end % End of lowpass()












