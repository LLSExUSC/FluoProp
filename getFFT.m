function [freq,psdx,freq2,phase] = getFFT(data1D,sampling_freq)
%Fourier transform 
N = length(data1D);
if mod(N,2)==1
    data1D = [data1D,data1D(end)];
end
N = length(data1D);
Fs = sampling_freq;
x = data1D;
xdft = fft(x);
xdft = xdft(1:N/2+1);
psdx = (1/(Fs*N)) * abs(xdft).^2;
psdx(2:end-1) = 2*psdx(2:end-1);
freq = 0:Fs/length(x):Fs/2;




xdft2 = fft(x);
phase = unwrap(angle(xdft2));
lxdft = length(xdft2);
freq2 = (0:lxdft-1)/lxdft*Fs;

% plot(freq2,phase/pi)