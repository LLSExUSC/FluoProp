function [actMap]= calculateActivationMap(videoMatrix)
% calculateActivationMap.m takes in a video of a single calcium activation 
% wave of in the form of a 3-dimensional matrix and calculates the frame at 
% which the activation wave reached each pixel in the video, then creates a 
% 2D representation of it. 
% 
% Input Arguments:
% videoMatrix - the x by y by t matrix (3D) that holds the video data.  
% 
% Output Arguments:
% actMap - the activation map calculated from the video, units are in frames
% 
% Megan McCain 2014
% Andrew Petersen  2015 Mar 02
% Andrew Petersen  2015 Jun 03
% Andrew Petersen  2016 Aug 24
% Andrew Petersen  2020 Jan 27-Feb 5
% 

%Get pixel height, pixel width, and time length of video
sizeOfData = size(videoMatrix);

% Run a 2D Gaussian filter in space 
filteredData = videoMatrix; %allocating space for the output of the 2D gaussian filter
h = fspecial('gaussian', 10, 5); %create Gaussian filter
for i=1:sizeOfData(3)
    filteredData(:,:,i) = imfilter(videoMatrix(:,:,i), h); %run Gaussian filter on each frame of the video
end

means = mean(filteredData,3); % Calculate mean per pixel
stds = std(filteredData,0,3); % Calculate standard deviation per pixel

Z=0.5; %Number of standard deviations above the mean to set as the activation threshold
stdThresh = means+Z*stds; %Calculate the activation threshold per pixel

badPixelCounter = 0;
activationMap = zeros(sizeOfData(1),sizeOfData(2));
for col = 1:sizeOfData(2)
    for row = 1:sizeOfData(1) 
        activatedFrame = find(filteredData(row,col,:)>=stdThresh(row,col),1);%for each pixel, find the first instance where the data rises above the threshold
        if isempty(activatedFrame) %if the pixel is saturated, it may never rise above the threshold, giving an empty value
            activationMap(row,col) = NaN;
            badPixelCounter = badPixelCounter + 1;
        else
            activationMap(row,col)= activatedFrame; 
        end
    end
end

if badPixelCounter~=0
    warning('%d Bad Pixels. These pixels are likely oversaturated and have no signal.',badPixelCounter)
end
if sum(sum(activationMap<0))>0 %if any activation times are negative
    error('Activation map has negative activation times. This should never happen. Error! Error!') 
end
if sum(sum(isnan(activationMap)))>0 %if any activation times were nans
    warning('Activation map has NaNs. Bad pixels in the activation map are stored as NaNs.') 
end

actMap = activationMap-min(min(activationMap)); % subtract the smallest activation time so that the first frame starts at zero
