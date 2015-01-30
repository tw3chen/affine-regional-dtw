clc;
clearvars;
close all;

% set seed for error reproduction
Stream = RandStream('mt19937ar','Seed',0);
RandStream.setGlobalStream(Stream);

load('MUPSignalTemplates.mat');
SignalToNoiseRatio = 10;
Signal1 = ExtractedMUPs(1,:);
Signal2 = ExtractedMUPs(2,:);
Signal1WithoutNoise = Signal2;
Signal1 = awgn(Signal1, SignalToNoiseRatio, 'measured');
Length = length(Signal1);
XNew = linspace(1, Length, 2*Length);
Signal2 = interp1(Signal2, XNew);
Signal2WithoutNoise = Signal2;
Signal2 = awgn(Signal2, SignalToNoiseRatio, 'measured');
Signal4 = Signal2(396:1215);
Signal6 = Signal2(271:1090);
Signal2 = Signal2(381:1200);
Signal4WithoutNoise = Signal2WithoutNoise(396:1215);
Signal3 = Signal1 + Signal2;
Signal5 = Signal1 + Signal4;
Signal3 = Signal3(380:550)/500;
Signal5 = Signal5(380:550)/500;
Signal8 = Signal4WithoutNoise(380:550)/500;
Signal6 = Signal1 + Signal6;
Signal6 = Signal6(380:680)/500;
Signal7 = Signal1WithoutNoise(345:515)/500;

Figure1 = figure(1);
set(Figure1, 'Position', [100, 100, 1000, 250]);

subaxis(1, 3, 1, 'SpacingVertical', 0.15, 'SpacingHorizontal', 0.05, 'Padding', 0, 'Margin', 0.1);
% [Distance RDTWPath] = RDTW(Signal6', Signal6', 1, 0);
PlotAlignment(Signal7, Signal8, [], 200, 200, 0, 5);
title('A. Underlying components');
subaxis(1, 3, 2, 'SpacingVertical', 0.15, 'SpacingHorizontal', 0.05, 'Padding', 0, 'Margin', 0.1);
[Distance RDTWPath] = RDTW(Signal3', Signal5', 1, 0);
PlotAlignment(Signal3, Signal5, RDTWPath, 200, 200, 1, 5);
title('B. DTW');
subaxis(1, 3, 3, 'SpacingVertical', 0.15, 'SpacingHorizontal', 0.05, 'Padding', 0, 'Margin', 0.1);
[Distance RDTWPath] = RDTW(Signal3', Signal5', 1, 0.05);
PlotAlignment(Signal3, Signal5, RDTWPath, 200, 200, 1, 5);
title('C. RDTW');

set(gcf, 'Color', 'w');
set(findall(gcf,'type','text'),'FontSize',13);
export_fig( gcf, ...      % figure handle
    'RDTWApplyOnIntroductoryExample',... % name of output file without extension
    '-painters', ...      % renderer
    '-jpg', ...           % file format
    '-r72' );             % resolution in dpi