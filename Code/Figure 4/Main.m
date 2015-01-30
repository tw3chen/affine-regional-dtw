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

Signals = zeros(2,length(Signal3));
Signals(1,:) = Signal3;
Signals(2,:) = Signal5;

% %% Construct test signals
% Length = 240;
% HammingWidth = 60;
% HammingOffset = 35;
% Hamming2Offset = 54;
% Hamming3Offset = 5;
% MainWidth = 120;
% MainOffset = 75;
% Signals = zeros(3,Length);
% Hamming = hamming(HammingWidth);
% Hamming = Hamming - Hamming(1);
% MainHamming = hamming(MainWidth);
% MainHamming = MainHamming - MainHamming(1);
% for i = HammingOffset+1:(HammingWidth+HammingOffset-1)-1
%     Signals(1,i) = Hamming(i-HammingOffset+1) * 0.7;
% end
% for i = Hamming2Offset+1:(HammingWidth+Hamming2Offset-1)-1
%     Signals(2,i) = Signals(2,i) + Hamming(i-Hamming2Offset+1) * 0.7;
% end
% for i = Hamming3Offset+1:(HammingWidth+Hamming3Offset-1)-1
%     Signals(3,i) = Signals(3,i) + Hamming(i-Hamming3Offset+1) * 0.7;
% end
% for i = MainOffset+1:(MainWidth+MainOffset-1)-1
%     Signals(1,i) = Signals(1,i) + MainHamming(i-MainOffset+1);
%     Signals(2,i) = Signals(2,i) + MainHamming(i-MainOffset+1);
%     Signals(3,i) = Signals(3,i) + MainHamming(i-MainOffset+1);
% end
Figure1 = figure(1);
set(Figure1, 'Position', [100, 100, 1000, 250]);

HalfRegionWidths = [0, 0.05, 0.5];
PlotIndex = 1;
for HalfRegionWidth = HalfRegionWidths
    subaxis(1, 3, PlotIndex, 'SpacingVertical', 0.05, 'SpacingHorizontal', 0.03, 'Padding', 0, 'Margin', 0.1, 'PaddingTop', 0.05);
    [Distance RDTWPath] = RDTW(Signals(1,:)', Signals(2,:)', 1, HalfRegionWidth);
    PlotAlignment(Signals(1,:), Signals(2,:), RDTWPath, 200, 200, 0, 5);
    PlotIndex = PlotIndex + 1;
    title(['$\frac{w_h}{n}=' num2str(HalfRegionWidth) '$'],'Interpreter','LaTex','FontSize',14,'FontName','Medium Roman');
end

set(gcf, 'Color', 'w');
set(findall(gcf,'type','text'),'FontSize',18);
export_fig( gcf, ...      % figure handle
    'RDTWEffectsOfWidth',... % name of output file without extension
    '-painters', ...      % renderer
    '-jpg', ...           % file format
    '-r72' );             % resolution in dpi