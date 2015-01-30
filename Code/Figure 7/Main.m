clc;
clearvars;
close all;

NoiseLevels = 0:0.1:0.5;
MeanResultsNoiseIndexByMethod = [];
for NoiseIndex = 1:length(NoiseLevels)

    load(['../Obtain Global Alignment Results/ResultsAbsoluteNoise' num2str(NoiseLevels(NoiseIndex)) '.mat']);
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
set(Figure1, 'Position', [100, 100, 550, 350]);

plot(NoiseLevels, MeanResultsNoiseIndexByMethod(:,1), '.k');
hold on;
plot(NoiseLevels, MeanResultsNoiseIndexByMethod(:,3), 'ok');
plot(NoiseLevels, MeanResultsNoiseIndexByMethod(:,4), 'sk');
plot(NoiseLevels, MeanResultsNoiseIndexByMethod(:,5), 'xk');
plot(NoiseLevels, MeanResultsNoiseIndexByMethod(:,6), '*k');
xlim([NoiseLevels(1) - 0.03, NoiseLevels(end) + 0.03]);
ylabel('Alignment measure M^{avg}_g','FontSize',18);
xlabel('Noise level n_l','FontSize',18);
legend('DTW', 'ADTW', 'RDTW', 'GARDTW', 'LARDTW', 'Location', 'SouthEast');
set(gca, 'XTick', NoiseLevels);
set(gcf, 'Color', 'w');
export_fig( gcf, ...      % figure handle
    'GlobalAlignment',... % name of output file without extension
    '-painters', ...      % renderer
    '-jpg', ...           % file format
    '-r72' );             % resolution in dpi