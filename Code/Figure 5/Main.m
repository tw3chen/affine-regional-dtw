clc;
clearvars;
close all;

% set seed for error reproduction
Stream = RandStream('mt19937ar','Seed',0);
RandStream.setGlobalStream(Stream);

%% Construct test signals
Length = 240;
HammingWidth = 60;
HammingOffset = 45;
Hamming2Offset = 54;
Hamming3Offset = 5;
MainWidth = 120;
MainOffset = 75;
Signals = zeros(4,Length);
Hamming = hamming(HammingWidth);
Hamming = Hamming - Hamming(1);
MainHamming = hamming(MainWidth);
MainHamming = MainHamming - MainHamming(1);
Scale1 = 1;
Scale2 = 2;
for i = HammingOffset+1:(HammingWidth+HammingOffset-1)-1
    Signals(1,i) = Hamming(i-HammingOffset+1) * 0.7 * Scale1;
end
for i = Hamming2Offset+1:(HammingWidth+Hamming2Offset-1)-1
    Signals(2,i) = Signals(2,i) + Hamming(i-Hamming2Offset+1) * 0.7 * Scale2;
end
for i = Hamming3Offset+1:(HammingWidth+Hamming3Offset-1)-1
    Signals(3,i) = Signals(3,i) + Hamming(i-Hamming3Offset+1) * 0.7 * Scale1;
    Signals(4,i) = Signals(4,i) + Hamming(i-Hamming3Offset+1) * 0.7 * Scale2;
end
for i = MainOffset+1:(MainWidth+MainOffset-1)-1
    Signals(1,i) = Signals(1,i) + MainHamming(i-MainOffset+1) * Scale1;
    Signals(2,i) = Signals(2,i) + MainHamming(i-MainOffset+1) * Scale2;
    Signals(3,i) = Signals(3,i) + MainHamming(i-MainOffset+1) * Scale1;
    Signals(4,i) = Signals(4,i) + MainHamming(i-MainOffset+1) * Scale2;
end
Signals(2,:) = Signals(2,:) + 0.2;
Signals(4,:) = Signals(4,:) + 0.2;
Noise = 0.05*randn(size(Signals));
Signals = Signals + Noise;

Figure1 = figure(1);
set(Figure1, 'Position', [100, 100, 1000, 250]);

subaxis(1, 3, 1, 'SpacingVertical', 0.05, 'SpacingHorizontal', 0.03, 'Padding', 0, 'Margin', 0.1, 'PaddingTop', 0.05);
[Distance Path] = ADTW(Signals(1,:)', Signals(2,:)', 1, 1, 0, 10^-5, 0.2, 5);
PlotAlignment(Signals(1,:), Signals(2,:), Path, 200, 200, 1, 10);
title('A. ADTW on s and t');
subaxis(1, 3, 2, 'SpacingVertical', 0.05, 'SpacingHorizontal', 0.03, 'Padding', 0, 'Margin', 0.1, 'PaddingTop', 0.05);
[Distance Path] = RDTW(Signals(1,:)', Signals(2,:)', 1, 0.05);
PlotAlignment(Signals(1,:), Signals(2,:), Path, 200, 200, 1, 10);
title('B. RDTW on s and t');
subaxis(1, 3, 3, 'SpacingVertical', 0.05, 'SpacingHorizontal', 0.03, 'Padding', 0, 'Margin', 0.1, 'PaddingTop', 0.05);
[Distance Path Scaling Offset] = GARDTW(Signals(1,:)', Signals(2,:)', 1, 0.05, ...
    1, 0, 10^-5, 0.2, 5);
PlotAlignment(Signals(1,:), Signals(2,:), Path, 200, 200, 1, 10);
title('E. GARDTW on s and t');

set(gcf, 'Color', 'w');
set(findall(gcf,'type','text'),'FontSize',13);
export_fig( gcf, ...      % figure handle
    'GARDTWConcept',... % name of output file without extension
    '-painters', ...      % renderer
    '-jpg', ...           % file format
    '-r72' );             % resolution in dpi