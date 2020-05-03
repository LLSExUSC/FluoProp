function displayImageAutoscaled(imageMatrix,figureID)
% Displays image to figure handle given using the function 'imagesc'.
% The look-up-table (LUT) bounds are set 2 standard deviations above and
% below the mean of all the pixels. 
% Generally, if there are outlier pixels, this will greatly improve the
% display of the image.
% 
% imageMatrix - a 2 dimensional matrix that represents an image
% figureID    - input the figure handle ID, ie 1000 for figure(1000) 
% 
% To be added: allow Z (the number of standard deviations above and below 
% the mean) to be an input variable.
%

Z = 2;
stdDev = nanstd(imageMatrix(:));
meanVal = nanmean(imageMatrix(:));
minDisp = meanVal-Z*stdDev;
maxDisp = meanVal+Z*stdDev;

if figureID==-1
    figure;
else
    figure(figureID)
end
imagesc(imageMatrix,[minDisp,maxDisp]);


