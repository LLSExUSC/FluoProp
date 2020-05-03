function [rotatedImage,rotationAngle] = alignImage(inputImage,figureID,fileID)
% This function allows a user to manually rotate an image through a dialog 
% box to align it with an automatically generated grid of lines. Returns
% the rotated image alongside the angle of rotation. 
% 
% inputImage - a 2D matrix that represents an image
% figureID - the handle of the figure to be created
% fileID - a string to be put in the title of the generated figure
% rotatedImage - the image, rotated the same amount that the user rotated
% the rectangle, but in the opposite direction
% rotationAngle - the negative of the angle that the rectangle was rotated. 

Z = 2;
stdDev = nanstd(inputImage(:));
meanVal = nanmean(inputImage(:));
minDisp = meanVal-Z*stdDev;
maxDisp = meanVal+Z*stdDev;
imageSize = size(inputImage);

askForRotate = true;
figure(figureID)
clf
figure(figureID)
imagesc(inputImage,[minDisp,maxDisp]);
title('Rotate Rectangle to Align Image')
h = drawrectangle(gca,'Position',[1 1 imageSize(2) imageSize(1)],'Rotatable',true);
while(askForRotate)
    pause(10)
    
    answer = questdlg('Done Rotating Rectangle to Align Image?', ...
        'Align Image with Rectangle', ...
        'Yes','No, I need 10 more seconds','No, I need 10 more seconds');
    if strcmp(answer,'Yes')
        rotationAngle = -1*h.RotationAngle;
        rotatedImage = imrotate(inputImage,rotationAngle,'bilinear','crop');
        figure(figureID)
        clf
        figure(figureID)
        imagesc(rotatedImage,[minDisp,maxDisp]);
        
        answer2 = questdlg('Does Alignment Look Good?', ...
        'Done Rotating Rectangle to Align Image?', ...
        'Yes','No, Restart Rotation','No, Restart Rotation');
        
        if strcmp(answer2,'Yes')
            askForRotate = false;
        else
            figure(figureID)
            clf
            figure(figureID)
            imagesc(inputImage,[minDisp,maxDisp]);
            title('Rotate Rectangle to Align Image')
            h = drawrectangle(gca,'Position',[1 1 imageSize(2) imageSize(1)],'Rotatable',true);
        end
    end
    figure(figureID)
end
