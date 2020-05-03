function [rawData,dataSize] = readFluoMovie(pathAndFile)
% Opens an ND2 file with bioformats' bfopen, then reorganizes the video
% data into an 3 dimensional matrix with the first and second dimensions
% for the pixel locations and the third dimension for frame of the video. 
% pathAndFile example for PC:
%  pathAndFile = 'C:\Users\Andrew Petersen\Desktop\Data\Calcium Imaging Raw\20160620\HigherFrameRates\CS13_roi8_int20_1hz_8binning_fast50pxhigh_075.nd2';
% rawData - the reorganized 3 dimensional image data in a matrix
% dataSize - size(rawData)

nd2Data = bfopen(pathAndFile);

if size(nd2Data)~=[1,4]
    warning('Incorrect File Size')
end

rowSize = length(nd2Data{1}{1,1}(:,1))
colSize = length(nd2Data{1}{1,1}(1,:))
tSize = size(nd2Data{1},1)
numDigits = numel(num2str(tSize));
% startIndex = floor(tSize/2);
% midIndex = startIndex+1;
% endIndex = midIndex+1;
% 
% startTime = nd2Data{2}.get(sprintf(['timestamp #%0',sprintf('%d',numDigits),'d'],startIndex));
% midTime = nd2Data{2}.get(sprintf(['timestamp #%0',sprintf('%d',numDigits),'d'],midIndex));
% endTime = nd2Data{2}.get(sprintf(['timestamp #%0',sprintf('%d',numDigits),'d'],endIndex));
% 
% frameRate = ((1/(midTime-startTime)) + (1/(endTime-midTime)))/2

dataSize = [rowSize,colSize,tSize]
rawData = zeros(rowSize,colSize,tSize);
for i=1:tSize
    rawData(:,:,i) = nd2Data{1}{i,1};
end

