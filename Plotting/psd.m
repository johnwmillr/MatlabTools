function psd(x,fs,varargin)
% PSD trys to simplify the pwelch() function to quickly plot a power spectrum
%
%	INPUT
%       x:  The vector to make a power spectrum of
%       fs: The sampling rate of 'x'.
%       (Optional)
%           segment_length: Specified as percentage (decimal) of length of 'x'.
%
%   http://www.mathworks.com/help/signal/ref/pwelch.html
%
%   See also, PWELCH
%
% John W. Miller
% 2015-07-22

%% Parse varargin
optional_inputs = {'segment_length'}; default_values  = {0.75};
segment_length = parseKeyValuePairs(varargin,optional_inputs,default_values);
segment_length = round(length(x)*segment_length);
    % High freq. resolution inversely proportional to segment_length   (?)
    % Increase the segment length for greater low frequency resolution (?)

%NFFT = round(segment_length*0.8);
NFFT = []; % (Default)
n_overlap = round((0.5)*segment_length);

% Calculate the power spectrum
[pxx, freqs] = pwelch(x,segment_length,n_overlap,NFFT,fs);

% Plot the power spectrum
figure
plot(freqs,10*log10(pxx))
xlabel('Frequency (Hz)','fontsize',FS-4)
ylabel('Magnitude (dB)','fontsize',FS-4)
title(sprintf('Power spectral density\nSegment: %d%% of total length',...
    round(segment_length./length(x)*100)),'fontsize',FS-4)

end % End of main function