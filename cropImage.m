function [croppedImage,boundingBox,boundingBoxWidths] = cropImage(inputImage,figureID,fileID)
% This function allows a user to manually crop an image by clicking and
% dragging around a rectangle in a figure. The function outputs the cropped
% image, the 4 points that bound the cropped image, and the upper left
% point plus the width of the box as the thrid output.
% 


figure(figureID)
Z = 2;
stdDev = nanstd(inputImage(:));
meanVal = nanmean(inputImage(:));
minDisp = meanVal-Z*stdDev;
maxDisp = meanVal+Z*stdDev;
inputImageSize = size(inputImage);

imshow((inputImage-minDisp)./(maxDisp-minDisp))
title('Click and drag rectangle to crop image. Double click to continue.')
imageSize = size(inputImage);

h = imrect(gca,[1 1 imageSize(2) imageSize(1)]);
addNewPositionCallback(h,@(p) title([mat2str(p,3),' - ',fileID],'Interpreter','none'));
fcn = makeConstrainToRectFcn('imrect',get(gca,'XLim'),get(gca,'YLim'));
setPositionConstraintFcn(h,fcn); 
position = wait(h);
pos = floor(position); %[y1,yLen,x1,xLen]
pos(pos<1) = 1;
if (pos(2)+pos(4)-1)>inputImageSize(1)
    pos(4) = inputImageSize(2)-pos(2)+1;
end
if (pos(1)+pos(3)-1)>inputImageSize(2)
    pos(1) = inputImageSize(1)-pos(4)+1;
end

boundingBox = [pos(2),pos(2)+pos(4)-1,pos(1),pos(1)+pos(3)-1]; %[x1,x2,y1,y2]
boundingBoxWidths = pos;
croppedImage = inputImage(boundingBox(1):boundingBox(2),boundingBox(3):boundingBox(4));

