function fftplot(x,fs)
% FFTPLOT 
%
%	INPUT
%       x: column or row vector to plot the Fast Fourier Transform of
%      fs: sampling rate of x.
%
% John W. Miller
% 2015-12-16

% Calculate the FFT
FreqResolution = fs/length(x); % Freq = Fs/N
freqs = 0:FreqResolution:(fs-FreqResolution);

DFT = fft(x);
[reDFT,imDFT] = deal(real(DFT),imag(DFT));
reDFT = fftshift(reDFT);

if any(imDFT ~= 0)        
    % Real component
    figure, subplot(1,2,1)
    plot(freqs,reDFT), xlim([0 fs/2])
    xlabel('Frequency (Hz)','fontsize',FS)
    title('Re{FFT}','fontsize',FS)    
        
    % Imaginary component
    subplot(1,2,2)
    plot(freqs,imDFT), xlim([0 fs/2])    
    xlabel('Frequency (Hz)','fontsize',FS)
    title('Im{FFT}','fontsize',FS)
    
    linkaxes
else
    % Plot only the real component
    figure, plot(freqs,reDFT), xlim([0 fs/2])    
    xlabel('Frequency (Hz)','fontsize',FS)
    title('Re{FFT}','fontsize',FS)    
end
       

end % End of main