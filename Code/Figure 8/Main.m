clc;
clearvars;
close all;

SigmaAmplitudes = 0:0.5:2;
load(['../Obtain Component-Based Alignment Results/ResultsComponent.mat']);

NoiseLevels = 0:0.1:0.5;
ScoresAcrossAmplitudes = WidthAmplitudeScores{1,1};

Figure1 = figure(1);
set(Figure1, 'Position', [100, 100, 550, 350]);

plot(SigmaAmplitudes, ScoresAcrossAmplitudes(:,1), '.k');
hold on;
plot(SigmaAmplitudes, ScoresAcrossAmplitudes(:,2), 'ok');
plot(SigmaAmplitudes, ScoresAcrossAmplitudes(:,3), 'sk');
plot(SigmaAmplitudes, ScoresAcrossAmplitudes(:,4), 'xk');
plot(SigmaAmplitudes, ScoresAcrossAmplitudes(:,5), '*k');
xlim([SigmaAmplitudes(1) - 0.1, SigmaAmplitudes(end) + 0.1]);
ylabel('Alignment measure M^{avg}_c','FontSize',18);
xlabel('Scaling standard deviation \sigma_a','FontSize',18);
legend('DTW', 'ADTW', 'RDTW', 'GARDTW', 'LARDTW', 'Location', 'NorthWest');
set(gca, 'XTick', SigmaAmplitudes);
set(gcf, 'Color', 'w');
export_fig( gcf, ...      % figure handle
    'ComponentBasedAlignment',... % name of output file without extension
    '-painters', ...      % renderer
    '-jpg', ...           % file format
    '-r72' );             % resolution in dpi