clc;
clearvars;
close all;

load('../Obtain Difference Measure Results/DifferenceMeasureResult27.mat');
PathHalfConstraintPercents = 0:0.05:0.5;
RegionHalfWidthPercents = 0:0.05:0.5;

NumResults = 45 - 1;%size(Results,1);
Results([32],:) = [];

RDTWErrorRateRange = ones(NumResults,2);
for i = 1:NumResults
    RDTWErrorRates = Results{i,8};
    MinErrorRate = min(min(RDTWErrorRates));
    [IndexI IndexJ] = find(RDTWErrorRates == MinErrorRate);
    PathIndex = IndexI(1);
    MaxErrorRate = max(RDTWErrorRates(PathIndex,2:end));
    MinErrorRate = min(RDTWErrorRates(PathIndex,2:end));
    if (i == 26 || i == 27) %Thorax1, Thorax2 or Starlight datasets
        MaxErrorRate = max(RDTWErrorRates(PathIndex,1:2));
        MinErrorRate = min(RDTWErrorRates(PathIndex,1:2));
    end
    RDTWErrorRateRange(i,:) = [MinErrorRate MaxErrorRate];
end
Temp =  RDTWErrorRateRange(:,2) - RDTWErrorRateRange(:,1);
[Values Indices] = sort(Temp, 'ascend');
RDTWErrorRateRange = RDTWErrorRateRange(Indices,:);

HorizontalStartEndSpacingPercent = 0.05;
VerticalAnnotationSpacing = 0.6;
VerticalPosition = 1;
Figure1 = figure(1);
set(Figure1, 'Position', [100, 100, 550, 350]);
for i = 1:NumResults
    LowerBound = RDTWErrorRateRange(i,1);
    UpperBound = RDTWErrorRateRange(i,2);
    line([LowerBound UpperBound],[VerticalPosition VerticalPosition], 'Color', 'k');
    line([LowerBound LowerBound], ...
                [VerticalPosition-VerticalAnnotationSpacing VerticalPosition+VerticalAnnotationSpacing], 'Color', 'k');
    line([UpperBound UpperBound], ...
        [VerticalPosition-VerticalAnnotationSpacing VerticalPosition+VerticalAnnotationSpacing], 'Color', 'k');
    
    VerticalPosition = VerticalPosition + 1;
end

ylim([0 NumResults+1]);
MaxValue = max(RDTWErrorRateRange(:,2));
MinValue = min(RDTWErrorRateRange(:,1));
Range = MaxValue - MinValue;
Spacing = Range * HorizontalStartEndSpacingPercent;
xlim([(MinValue-Spacing) (MaxValue+Spacing)]);

ylabel('Dataset index','FontSize',18);
xlabel('1-NN RDTW error rate','FontSize',18);
set(gcf, 'Color', 'w');
export_fig( gcf, ...      % figure handle
    'RDTWRegionWidthSensitivity',... % name of output file without extension
    '-painters', ...      % renderer
    '-jpg', ...           % file format
    '-r72' );             % resolution in dpi