function [conduction,fitStats] = opticalMappingFit(act,micronToPixel,heatmapFigNum,pointPlotFigNum,fileID)
% This function fits a line to the input activation map by use of robust
% linear regression. 
% act - the input activation map, in milliseconds
% micronToPixel - the size of each pixel, in microns
% heatmapFigNum - the figure number to use for the heatmap figure
% pointPlotFigNum - the figure number to use for the point plot figure
% fileID - a header to add to the title of each figure for identification
% conduction - the calculated conduction velocity of the activation map, in cm/s
% fitStats - the statistics information for the fit line

% act = actMap;
actSize = size(act);
x1 = 1:actSize(2);
y1 = 1:actSize(1);
[xx,~] = meshgrid(x1,y1);

xxExpanded = xx(:);
actExpanded = act(:);

bls = regress(actExpanded,[ones(length(xxExpanded),1) xxExpanded]);
[brob,fitStats] = robustfit(xxExpanded,actExpanded);
conduction = micronToPixel/(brob(2)*10) %in cm/s

kept_ind = find(~(abs(fitStats.resid)>fitStats.mad_s));
outliers_ind = find(abs(fitStats.resid)>fitStats.mad_s);


% Plot Robust Regression Details with Heatmap
if heatmapFigNum==-1
    figure;
else
    figure(heatmapFigNum);clf;figure(heatmapFigNum)
end
hist3([xxExpanded(kept_ind),actExpanded(kept_ind)],[30,30])
set(get(gca,'child'),'FaceColor','interp','CDataMode','auto');
colormap(gcf,'hot')
cb = colorbar;
ylabel(cb, 'Pixel Count')
hold on
plot(x1,brob(1)+brob(2)*x1,'g','LineWidth',2)
title([sprintf('CV: %.1f cm/s, ',conduction),fileID],'Interpreter','none')
axisX = 'Pixel Column (pixels)';
axisY = 'Activation Time (ms)';
xhand = get(gca,'xlabel');
yhand = get(gca,'ylabel');
set(xhand,'string',axisX,'fontsize',18,'FontWeight','bold','FontName','Arial')
set(yhand,'string',axisY,'fontsize',18,'FontWeight','bold','FontName','Arial')
view([90 -90])

% Plot Regular vs Robust Regression with Points and Lines
if pointPlotFigNum~=0
    if pointPlotFigNum==-1
        figure;
    else
        figure(pointPlotFigNum)
    end
    hold off
    scatter(actExpanded(outliers_ind),xxExpanded(outliers_ind),'*r'); grid on; hold on
    scatter(actExpanded(kept_ind),xxExpanded(kept_ind),'*b')
    plot(bls(1)+bls(2)*x1,x1,'k','LineWidth',2);
    plot(brob(1)+brob(2)*x1,x1,'g','LineWidth',2)
    legend('Outliers','Data','Least Squares Linear Regression','Robust Regression','Location','northwest')
    title([sprintf('CV: %.1f cm/s, ',conduction),fileID],'Interpreter','none')
    axisY = 'Pixel Column (pixels)';
    axisX = 'Activation Time (ms)';
    xhand = get(gca,'xlabel');
    yhand = get(gca,'ylabel');
    set(xhand,'string',axisX,'fontsize',18,'FontWeight','bold','FontName','Arial')
    set(yhand,'string',axisY,'fontsize',18,'FontWeight','bold','FontName','Arial')
end