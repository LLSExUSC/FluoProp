function [breakIndexes] = breakIntoBeats(dataVector,samplingFreq)%periodicData
% This function takes a periodic dataVector and finds indexes to split the
% vector into separate cycles, breaking near the lowest part of the cycle.
% Is meant to work for calcium transient data from in vitro heart tissue
% 
% Code needs cleaning and could likely be optimized a lot
% 



if ~exist('samplingFreq','var')
    %default freq is 100 fps if none is given
    samplingFreq = 100;
end

% Show data
%%%figure(3927)
totalTime = (length(dataVector)-1)/samplingFreq;
samplingPeriod = 1/samplingFreq;
t = 0:samplingPeriod:totalTime;
%%%plot(t,dataVector)

size(mean(dataVector))

[freqs,psd] = getFFT(dataVector - mean(dataVector),samplingFreq);
%%%figure(123)
%%%semilogy(freqs,psd)
%indddd = find(psd>1,10)
%sortedFreqs = sortrows([psd(indddd);indddd;freqs(indddd)]')
[maxPsd, maxPsdIndex] = max(psd)
beatFreq = freqs(maxPsdIndex)
% 
% psdSize = size(psd)
% freqsSize = size(freqs)
% sortedFreqs = sortrows([psd,freqs']')
% sortedFreqs = flipud(sortedFreqs)
% sortedFreqs(1:5,3)


n = length(dataVector)
% beatFreq = sortedFreqs(1,3)
beatPeriod = 1/beatFreq;
maxPhase = beatPeriod
nPhaseIncrements = 50;
phaseRes = maxPhase/nPhaseIncrements
zxc = maxPhase/phaseRes
if round(zxc)~=50
    warning('maxPhase/phaseRes != 50')
elseif zxc~=50
    warning('maxPhase/phaseRes != 50, but is very close')
end
c1 = zeros(1,round(maxPhase/phaseRes));
c2 = c1;
c3 = c1;
for k = 1:maxPhase/phaseRes+1
    phaseShift = (k-1)*phaseRes;
    t2 = linspace(0,n/samplingFreq+0.0001,n);
    y = sin(beatFreq*2*pi*(t2 - phaseShift));
    
    ySize = size(y);
    dataVectorSize = size(dataVector);
    
    a1 = y.*dataVector;
    a2 = (y+0.5).*(dataVector - min(dataVector));
    a3 = y.*(dataVector - mean(dataVector));
    beatFreq;
    b1 = sum(a1);
    b2 = sum(a2);
    b3 = sum(a3);


    c1(k) = b1;
    c2(k) = b2;
    c3(k) = b3;

%     figure(3321)
%     hold on
%     plot(y)


%     figure(2345+numberOfBeats)
%      
%     hold on
%     plot(dataVector,'b')
%     plot(y,'r')
% %     plot(a1,'k')
%     plot(a2,'c')
%     title([num2str(numberOfBeats),' ',num2str(b2)])
%     plot(a3,'m')
%     legend('data','y','a1','a2','a3')
end

%beatsX = 0:beatsRes:maxBeatFreq;
phaseX = 0:phaseRes:maxPhase;
%%%figure(398)
%%%hold on
%%%plot(phaseX,c1,'or')
%%%plot(phaseX,c2,'+k')
%%%plot(phaseX,c3,'^b')

matchedIndex = find(max(c2)==c2,1)
matchedPhase = (matchedIndex/nPhaseIncrements)*beatPeriod

%%%figure(3927)
%%%hold on
y2 = 7*sin(2*pi*beatFreq*(t-matchedPhase));
%%%%plot(t,y2,'r')

derivative = diff(y2);
k=1;
for i=1:length(dataVector)-2
    if (derivative(i)<0 && derivative(i+1)>0)||(derivative(i)<0 && derivative(i+1)==0)
        valleyIndexes(k) = i+1;
        k=k+1;
    end
end
valleyIndexes
finalIndex = find(valleyIndexes, 1, 'last');
valleyIndexes = valleyIndexes(1:finalIndex);
%%%plot(valleyIndexes/samplingFreq,-6,'r*')
breakIndexes = [];
if derivative(1)>0
    %include first point
    breakIndexes = 1;
end
breakIndexes = [breakIndexes, valleyIndexes];
if derivative(end)<0
    %include last point
    breakIndexes = [breakIndexes, length(dataVector)];
end
breakIndexes
%%%plot(breakIndexes/samplingFreq,-7,'b*')
% 
% numPeaks = length(breakIndexes)-1;
% peakIndexes = zeros(1,numPeaks)-1;
% peaks =  zeros(1,numPeaks)-1;
% for i = 1:numPeaks
%     [peaks(i),peakIndexes(i)] = max(dataVector(breakIndexes(i):breakIndexes(i+1)));
%     peakIndexes(i) = peakIndexes(i) + breakIndexes(i) - 1;
% end
% peaks
% peakIndexes






%breakIndexes = -1;