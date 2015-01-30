clc;
clearvars;
close all;

load('RecordTimeTaken.mat');
Symbols = ['.'; 'o'; '+'; 'x'; 'x'];

TimePlots = zeros(5, length(DatasetLength));
[SortedDatasetLength SortedIndices] = sort(DatasetLength);
for j = 1:5
    MethodRecordTime = TimeTaken{j};
    PlaceHolder = zeros(length(DatasetLength),1);
    for i = 1:length(DatasetLength)
        Points = MethodRecordTime(i,:);
        PlaceHolder(i) = mean(Points);
    end
    TimePlots(j,:) = PlaceHolder(SortedIndices);
end

Figure1 = figure(1);
set(Figure1, 'Position', [100, 100, 600, 600]);

subaxis(2, 2, 1, 'SpacingVertical', 0.15, 'SpacingHorizontal', 0.1, 'Padding', 0, 'Margin', 0.1);
plot(SortedDatasetLength, TimePlots(1,:), 'x', 'Color', 'k');
hold on;
plot(SortedDatasetLength, TimePlots(2,:), '+', 'Color', 'k');
xlabel('Time series length');
ylabel('Average time for pairwise alignment (s)');
title('ADTW vs DTW alignment time');
legend('DTW', 'ADTW');

subaxis(2, 2, 2, 'SpacingVertical', 0.15, 'SpacingHorizontal', 0.1, 'Padding', 0, 'Margin', 0.1);
plot(SortedDatasetLength, TimePlots(1,:), 'x', 'Color', 'k');
hold on;
plot(SortedDatasetLength, TimePlots(3,:), '+', 'Color', 'k');
xlabel('Time series length');
ylabel('Average time for pairwise alignment (s)');
title('RDTW vs DTW alignment time');
legend('DTW', 'RDTW');

subaxis(2, 2, 3, 'SpacingVertical', 0.15, 'SpacingHorizontal', 0.1, 'Padding', 0, 'Margin', 0.1);
plot(SortedDatasetLength, TimePlots(1,:), 'x', 'Color', 'k');
hold on;
plot(SortedDatasetLength, TimePlots(4,:), '+', 'Color', 'k');
xlabel('Time series length');
ylabel('Average time for pairwise alignment (s)');
title('GARDTW vs DTW alignment time');
legend('DTW', 'GARDTW');

subaxis(2, 2, 4, 'SpacingVertical', 0.15, 'SpacingHorizontal', 0.1, 'Padding', 0, 'Margin', 0.1);
plot(SortedDatasetLength, TimePlots(1,:), 'x', 'Color', 'k');
hold on;
plot(SortedDatasetLength, TimePlots(5,:), '+', 'Color', 'k');
xlabel('Time series length');
ylabel('Average time for pairwise alignment (s)');
title('LARDTW vs DTW alignment time');
legend('DTW', 'LARDTW');

set(gcf, 'Color', 'w');
export_fig( gcf, ...      % figure handle
    'TimeTaken',... % name of output file without extension
    '-painters', ...      % renderer
    '-jpg', ...           % file format
    '-r72' );             % resolution in dpi