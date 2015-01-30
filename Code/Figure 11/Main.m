clc;
clearvars;
close all;

Warpings = 0:0.1:0.6;
MeanResultsNoiseIndexByMethod = [];
for WarpIndex = 1:length(Warpings)

    load(['../Obtain Global Alignment Results - Vary Warpings/ResultsAbsoluteWarp' num2str(Warpings(WarpIndex)) '.mat']);
    PathHalfConstraintPercents = 0:0.05:0.5;
    RegionHalfWidthPercents = 0:0.05:0.5;
    NumConstraintPercents = length(PathHalfConstraintPercents);
    NumWidthPercents = length(RegionHalfWidthPercents);

    NumResults = size(ResultsAbsolute,1);
    ResultsToRecordAbsolute = cell(NumResults,7);
    MeanResultsByDatasetAndMethod = ones(NumResults,6);
    for i = 1:NumResults
        VerticalScoresAbsoluteByPR = ResultsAbsolute{i,2};
        RDTWScoresAbsoluteByPR = ResultsAbsolute{i,3};
        NormRDTWScoresAbsoluteByPR = ResultsAbsolute{i,4};
        GARDTWScoresAbsoluteByPR = ResultsAbsolute{i,5};
        LARDTWScoresAbsoluteByPR = ResultsAbsolute{i,6};

        VerticalScoresAbsolute = VerticalScoresAbsoluteByPR(:,1,1);
        ResultsToRecordAbsolute{i,1} = [mean(VerticalScoresAbsolute) std(VerticalScoresAbsolute)];

        DTWScoresAbsoluteByP = zeros(NumConstraintPercents,2);
        for p = 1:NumConstraintPercents
            r = 1;
            DTWScoresAbsolute = RDTWScoresAbsoluteByPR(:,p,r);
            DTWMean = mean(DTWScoresAbsolute);
            DTWStd = std(DTWScoresAbsolute);
            DTWScoresAbsoluteByP(p,1) = DTWMean;
            DTWScoresAbsoluteByP(p,2) = DTWStd;
        end
        [Value Index] = min(DTWScoresAbsoluteByP(:,1));
        DTWMean = Value;
        ResultsToRecordAbsolute{i,2} = [PathHalfConstraintPercents(Index) DTWScoresAbsoluteByP(Index,1) DTWScoresAbsoluteByP(Index,2)];

        NormDTWScoresAbsoluteByP = zeros(NumConstraintPercents,2);
        for p = 1:NumConstraintPercents
            r = 1;
            NormDTWScoresAbsolute = NormRDTWScoresAbsoluteByPR(:,p,r);
            NormDTWMean = mean(NormDTWScoresAbsolute);
            NormDTWStd = std(NormDTWScoresAbsolute);
            NormDTWScoresAbsoluteByP(p,1) = NormDTWMean;
            NormDTWScoresAbsoluteByP(p,2) = NormDTWStd;
        end
        [Value Index] = min(NormDTWScoresAbsoluteByP(:,1));
        NormDTWMean = Value;
        ResultsToRecordAbsolute{i,7} = [PathHalfConstraintPercents(Index) NormDTWScoresAbsoluteByP(Index,1) NormDTWScoresAbsoluteByP(Index,2)];

        ADTWScoresAbsoluteByP = zeros(NumConstraintPercents,2);
        for p = 1:NumConstraintPercents
            r = 1;
            ADTWScoresAbsolute = GARDTWScoresAbsoluteByPR(:,p,r);
            ADTWMean = mean(ADTWScoresAbsolute);
            ADTWStd = std(ADTWScoresAbsolute);
            ADTWScoresAbsoluteByP(p,1) = ADTWMean;
            ADTWScoresAbsoluteByP(p,2) = ADTWStd;
        end
        [Value Index] = min(ADTWScoresAbsoluteByP(:,1));
        ADTWMean = Value;
        ResultsToRecordAbsolute{i,3} = [PathHalfConstraintPercents(Index) ADTWScoresAbsoluteByP(Index,1) ...
            ADTWScoresAbsoluteByP(Index,2)];

        RDTWMeans = zeros(NumConstraintPercents,NumWidthPercents-1);
        RDTWStds = zeros(NumConstraintPercents,NumWidthPercents-1);
        for p = 1:NumConstraintPercents
            for r = 2:NumWidthPercents
                RDTWScoresAbsolute = RDTWScoresAbsoluteByPR(:,p,r);
                RDTWMean = mean(RDTWScoresAbsolute);
                RDTWStd = std(RDTWScoresAbsolute);
                RDTWMeans(p,r-1) = RDTWMean;
                RDTWStds(p,r-1) = RDTWStd;
            end
        end
        Value = min(min(RDTWMeans));
        RDTWMean = Value;
        [PIndices RIndices] = find(RDTWMeans == Value);
        ResultsToRecordAbsolute{i,4} = [PathHalfConstraintPercents(PIndices(1)) RegionHalfWidthPercents(RIndices(1)+1) ...
            RDTWMeans(PIndices(1),RIndices(1)) RDTWStds(PIndices(1),RIndices(1))];

        GARDTWMeans = zeros(NumConstraintPercents,NumWidthPercents-1);
        GARDTWStds = zeros(NumConstraintPercents,NumWidthPercents-1);
        for p = 1:NumConstraintPercents
            for r = 2:NumWidthPercents
                GARDTWScoresAbsolute = GARDTWScoresAbsoluteByPR(:,p,r);
                GARDTWMean = mean(GARDTWScoresAbsolute);
                GARDTWStd = std(GARDTWScoresAbsolute);
                GARDTWMeans(p,r-1) = GARDTWMean;
                GARDTWStds(p,r-1) = GARDTWStd;
            end
        end
        Value = min(min(GARDTWMeans));
        GARDTWMean = Value;
        [PIndices RIndices] = find(GARDTWMeans == Value);
        ResultsToRecordAbsolute{i,5} = [PathHalfConstraintPercents(PIndices(1)) RegionHalfWidthPercents(RIndices(1)+1) ...
            GARDTWMeans(PIndices(1),RIndices(1)) GARDTWStds(PIndices(1),RIndices(1))];

        LARDTWMeans = zeros(NumConstraintPercents,NumWidthPercents-1);
        LARDTWStds = zeros(NumConstraintPercents,NumWidthPercents-1);
        for p = 1:NumConstraintPercents
            for r = 2:NumWidthPercents
                LARDTWScoresAbsolute = LARDTWScoresAbsoluteByPR(:,p,r);
                LARRDTWMean = mean(LARDTWScoresAbsolute);
                LARDTWStd = std(LARDTWScoresAbsolute);
                LARDTWMeans(p,r-1) = LARRDTWMean;
                LARDTWStds(p,r-1) = LARDTWStd;
            end
        end
        Value = min(min(LARDTWMeans));
        LARDTWMean = Value;
        [PIndices RIndices] = find(LARDTWMeans == Value);

        ResultsToRecordAbsolute{i,6} = [PathHalfConstraintPercents(PIndices(1)) RegionHalfWidthPercents(RIndices(1)+1) ...
            LARDTWMeans(PIndices(1),RIndices(1)) LARDTWStds(PIndices(1),RIndices(1))];
        MeanResultsByDatasetAndMethod(i,:) = [DTWMean NormDTWMean ADTWMean RDTWMean GARDTWMean LARDTWMean];
    end
    
    MeanResultsNoiseIndexByMethod = [MeanResultsNoiseIndexByMethod; mean(MeanResultsByDatasetAndMethod,1)];
    
end

Figure1 = figure(1);
set(Figure1, 'Position', [100, 100, 850, 350]);

subaxis(2, 2, 1, 1, 1, 2, 'SpacingVertical', 0.1, 'SpacingHorizontal', 0.1, 'Padding', 0, 'PaddingTop', 0.1, 'PaddingBottom', 0.1, 'PaddingLeft', 0.1, 'Margin', 0.1);
plot(Warpings, MeanResultsNoiseIndexByMethod(:,2), '.k');
hold on;
plot(Warpings, MeanResultsNoiseIndexByMethod(:,3), 'ok');
xlim([Warpings(1) - 0.03, Warpings(end) + 0.03]);
ylabel('Alignment measure M^{avg}_g','FontSize',16);
xlabel('Warping probability P_w','FontSize',16);
legend('Normalize before DTW', 'ADTW', 'Location', 'SouthEast');
title('A. ADTW vs normalize before DTW');

Length = 120;

Hann1_1Width = 39;
Hann1_1Position = 20;
Hann1_2Width = 39;
Hann1_2Position = 80;
Hann1_3Width = 39;
Hann1_3Position = 85;

Signal1 = zeros(1,Length);
Hann1_1 = hann(Hann1_1Width);
TempIndex = 1;
for i = (Hann1_1Position - floor(Hann1_1Width/2)):(Hann1_1Position + floor(Hann1_1Width/2))
    Signal1(i) = Signal1(i) + 0.1 * Hann1_1(TempIndex);
    TempIndex = TempIndex + 1;
end
Hann1_2 = hann(Hann1_2Width);
TempIndex = 1;
for i = (Hann1_2Position - floor(Hann1_2Width/2)):(Hann1_2Position + floor(Hann1_2Width/2))
    Signal1(i) = Signal1(i) + 0.1 * Hann1_2(TempIndex);
    TempIndex = TempIndex + 1;
end
Hann1_3 = hann(Hann1_3Width);

Hann2_1Width = 39;
Hann2_1Position = 20;
Hann2_2Width = 71;
Hann2_2Position = 80;
Hann2_3Width = 39;
Hann2_3Position = 85;

Signal2 = zeros(1,Length);
Hann2_1 = hann(Hann2_1Width);
TempIndex = 1;
for i = (Hann2_1Position - floor(Hann2_1Width/2)):(Hann2_1Position + floor(Hann2_1Width/2))
    Signal2(i) = Signal2(i) + 0.1 * Hann2_1(TempIndex);
    TempIndex = TempIndex + 1;
end
Hann2_2 = hann(Hann2_2Width);
TempIndex = 1;
for i = (Hann2_2Position - floor(Hann2_2Width/2)):(Hann2_2Position + floor(Hann2_2Width/2))
    Signal2(i) = Signal2(i) + 0.1 * Hann2_2(TempIndex);
    TempIndex = TempIndex + 1;
end
Hann2_3 = hann(Hann2_3Width);

Signal2 = Signal2 * 2;
subaxis(2, 2, 2, 'SpacingVertical', 0.02, 'SpacingHorizontal', 0.05, 'Padding', 0, 'PaddingTop', 0.1, 'Margin', 0.1);
[Distance ADTWPath Scaling Offset] = ADTW(Signal1', Signal2', 1, 1, 0, 10^-5, 0.2, 5);
PlotAlignment(Signal1, Signal2, ADTWPath, 0.1, 1, 0, 5);
title('B. ADTW');
subaxis(2, 2, 4, 'SpacingVertical', 0.02, 'SpacingHorizontal', 0.05, 'Padding', 0, 'PaddingTop', 0.1, 'Margin', 0.1);
[Distance RDTWPath] = RDTW(zscore(Signal1'), zscore(Signal2'), 1, 0);
PlotAlignment(Signal1, Signal2, RDTWPath, 0.1,1, 0, 5);
title('C. Normalize before DTW');

set(gcf, 'Color', 'w');
export_fig( gcf, ...      % figure handle
    'ADTWvsNormalizeDTW',... % name of output file without extension
    '-painters', ...      % renderer
    '-jpg', ...           % file format
    '-r72' );             % resolution in dpi