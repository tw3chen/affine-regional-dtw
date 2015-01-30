clc;
clearvars;
close all;

%% Construct test signals
% SignalToNoiseRatio = 30;
Length = 240;
MainWidth = 80;
MainWidth2 = 120;
MainWidth3 = 40;
MainOffset = 115;
MainOffset2 = 95;
SecondaryOffset = 25;
SecondaryOffset2 = 45;
Signals = zeros(2,Length);
MainHamming = hamming(MainWidth);
MainHamming = MainHamming - MainHamming(1);
MainHamming2 = hamming(MainWidth2);
MainHamming2 = MainHamming2 - MainHamming2(1);
MainHamming3 = hamming(MainWidth3);
MainHamming3 = MainHamming3 - MainHamming3(1);
Scale2 = 2;
Scale1 = 0.5;
IdealPath = [(1:size(Signals,2))' (1:size(Signals,2))'];
TIndicesForScalingCellArray = cell(4,1);
for i = MainOffset+1:(MainWidth+MainOffset-1)-1
    Signals(1,i) = Signals(1,i) + MainHamming(i-MainOffset+1);
end
Count = 1;
TIndicesForScaling = MainOffset2+1:(MainWidth2+MainOffset2-1)-1;
for i = MainOffset2+1:(MainWidth2+MainOffset2-1)-1
    if (i > (MainWidth+SecondaryOffset-1)-1)
        Signals(2,i) = Signals(2,i) + Scale1 * MainHamming2(i-MainOffset2+1);
        IdealPath(i,1) = MainOffset + ceil(Count*MainWidth/MainWidth2);
    end
    Count = Count + 1;
end
TIndicesForScalingCellArray{2,1} = TIndicesForScaling;
Count = 1;
for i = SecondaryOffset+1:(MainWidth+SecondaryOffset-1)-1
    Signals(1,i) = Signals(1,i) + MainHamming(i-SecondaryOffset+1);
    IdealPath(i,2) = SecondaryOffset2 + ceil(Count*MainWidth3/MainWidth);
    Count = Count + 1;
end
TIndicesForScaling = SecondaryOffset2+1:(MainWidth3+SecondaryOffset2-1)-1;
for i = SecondaryOffset2+1:(MainWidth3+SecondaryOffset2-1)-1
    Signals(2,i) = Signals(2,i) + Scale2 * MainHamming3(i-SecondaryOffset2+1);
end

Figure1 = figure(1);
set(Figure1, 'Position', [100, 100, 1000, 250]);
YLim = [min([min(Signals(1,:)), min(Signals(2,:))])-0.1, max([max(Signals(1,:)), max(Signals(2,:))])+0.1];
XLim = [1, length(Signals(1,:))];

subaxis(1, 3, 1, 'SpacingVertical', 0.05, 'SpacingHorizontal', 0.03, 'Padding', 0, 'Margin', 0.1, 'PaddingTop', 0.05);
[Distance Path] = ADTW(Signals(1,:)', Signals(2,:)', 1, 1, 0, 10^-5, 0.2, 5);
PlotAlignment(Signals(1,:), Signals(2,:), Path, 200, 200, 1, 7);
title('A. ADTW on s and t');
subaxis(1, 3, 2, 'SpacingVertical', 0.05, 'SpacingHorizontal', 0.03, 'Padding', 0, 'Margin', 0.1, 'PaddingTop', 0.05);
[Distance Path] = RDTW(Signals(1,:)', Signals(2,:)', 1, 0.1);
PlotAlignment(Signals(1,:), Signals(2,:), Path, 200, 200, 1, 7);
title('B. RDTW on s and t');
subaxis(1, 3, 3, 'SpacingVertical', 0.05, 'SpacingHorizontal', 0.03, 'Padding', 0, 'Margin', 0.1, 'PaddingTop', 0.05);
[Distance Path] = LARDTW(Signals(1,:)', Signals(2,:)', 1, 0.1, 0.2, 7);
PlotAlignment(Signals(1,:), Signals(2,:), Path, 200, 200, 1, 7);
title('C. LARDTW on s and t');

set(gcf, 'Color', 'w');
set(findall(gcf,'type','text'),'FontSize',13);
export_fig( gcf, ...      % figure handle
    'LARDTWConcept',... % name of output file without extension
    '-painters', ...      % renderer
    '-jpg', ...           % file format
    '-r72' );             % resolution in dpi