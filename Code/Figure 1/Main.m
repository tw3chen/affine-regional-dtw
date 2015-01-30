clc;
clearvars;
close all;

Length = 120;

Hann1_1Width = 29;
Hann1_1Position = 20;
Hann1_2Width = 29;
Hann1_2Position = 40;
Hann1_3Width = 49;
Hann1_3Position = 70;

Signal1 = ones(1,Length);
Hann1_1 = hann(Hann1_1Width);
TempIndex = 1;
for i = (Hann1_1Position - floor(Hann1_1Width/2)):(Hann1_1Position + floor(Hann1_1Width/2))
    Signal1(i) = Signal1(i) - 0.2 * Hann1_1(TempIndex);
    TempIndex = TempIndex + 1;
end
Hann1_2 = hann(Hann1_2Width);
TempIndex = 1;
for i = (Hann1_2Position - floor(Hann1_2Width/2)):(Hann1_2Position + floor(Hann1_2Width/2))
    Signal1(i) = Signal1(i) + 0.1 * Hann1_2(TempIndex);
    TempIndex = TempIndex + 1;
end
Hann1_3 = hann(Hann1_3Width);
TempIndex = 1;
for i = (Hann1_3Position - floor(Hann1_3Width/2)):(Hann1_3Position + floor(Hann1_3Width/2))
    Signal1(i) = Signal1(i) - 0.1 * Hann1_3(TempIndex);
    TempIndex = TempIndex + 1;
end
plot(Signal1);

Hann2_1Width = 39;
Hann2_1Position = 35;
Hann2_2Width = 59;
Hann2_2Position = 60;
Hann2_3Width = 39;
Hann2_3Position = 85;

Signal2 = ones(1,Length);
Hann2_1 = hann(Hann2_1Width);
TempIndex = 1;
for i = (Hann2_1Position - floor(Hann2_1Width/2)):(Hann2_1Position + floor(Hann2_1Width/2))
    Signal2(i) = Signal2(i) - 0.2 * Hann2_1(TempIndex);
    TempIndex = TempIndex + 1;
end
Hann2_2 = hann(Hann2_2Width);
TempIndex = 1;
for i = (Hann2_2Position - floor(Hann2_2Width/2)):(Hann2_2Position + floor(Hann2_2Width/2))
    Signal2(i) = Signal2(i) + 0.1 * Hann2_2(TempIndex);
    TempIndex = TempIndex + 1;
end
Hann2_3 = hann(Hann2_3Width);
TempIndex = 1;
for i = (Hann2_3Position - floor(Hann2_3Width/2)):(Hann2_3Position + floor(Hann2_3Width/2))
    Signal2(i) = Signal2(i) - 0.1 * Hann2_3(TempIndex);
    TempIndex = TempIndex + 1;
end

hold on;
plot(Signal2, 'r');

Figure1 = figure(1);
set(Figure1, 'Position', [100, 100, 600, 200]);

subaxis(1, 2, 1, 'SpacingVertical', 0.1, 'SpacingHorizontal', 0.1, 'Padding', 0, 'PaddingTop', 0.1, 'Margin', 0.1);
PlotAlignment(Signal1, Signal2, [(1:Length)' (1:Length)'], 200, 540, 0, 5);
title('A. Vertical alignment');
subaxis(1, 2, 2, 'SpacingVertical', 0.1, 'SpacingHorizontal', 0.1, 'Padding', 0, 'PaddingTop', 0.1, 'Margin', 0.1);
[Distance RDTWPath] = RDTW(Signal1', Signal2', 1, 0);
PlotAlignment(Signal1, Signal2, RDTWPath, 200, 540, 0, 5);
title('B. DTW alignment');

set(gcf, 'Color', 'w');
set(findall(gcf,'type','text'),'FontSize',13);
export_fig( gcf, ...      % figure handle
    'DTWConcept',... % name of output file without extension
    '-painters', ...      % renderer
    '-jpg', ...           % file format
    '-r72' );             % resolution in dpi