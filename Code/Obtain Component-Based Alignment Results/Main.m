clc;
clearvars;
close all;

% set seed for error reproduction
Stream = RandStream('mt19937ar','Seed',1);
RandStream.setGlobalStream(Stream);

WidthAmplitudeScores = cell(1,2);
WidthIndex = 1;
for UseFixedWidth = 0
    NumIterations = 100;
    ComponentBasedTimeSeriesCell = cell(NumIterations,2);
    SigmaAmplitudes = 0:0.5:2;
    ScoresAcrossAmplitudes = ones(length(SigmaAmplitudes),5);
    SelectedParameterIndices = ones(length(SigmaAmplitudes),8);
    AmplitudeIndex = 1;
    for SigmaAmplitude = SigmaAmplitudes

        for i = 1:NumIterations
            NumComponents = 4;
            Length = 400;
            Amplitudes = abs(randn(2,NumComponents) * SigmaAmplitude + 1);
            [Signals Matches1 Matches2 Contributions1 Contributions2 OverlapsCellArray ComponentWidths LocationsArray] ...
                = CreateComponentBasedSignalPair(NumComponents, Length, Amplitudes, UseFixedWidth);
            IdealPath = ObtainComponentBasedIdealPath(Matches1, Matches2, LocationsArray);
            ComponentBasedTimeSeriesCell{i,1} = Signals;
            ComponentBasedTimeSeriesCell{i,2} = IdealPath;
        end

        PathHalfConstraintPercents = 0.5;
        RegionHalfWidthPercents = 0:0.05:0.5;
        ScoresDTW = ones(length(PathHalfConstraintPercents), 1);
        ScoresADTW = ones(length(PathHalfConstraintPercents), 1);
        ScoresRDTW = ones(length(PathHalfConstraintPercents), length(RegionHalfWidthPercents));
        ScoresGARDTW = ones(length(PathHalfConstraintPercents), length(RegionHalfWidthPercents));
        ScoresLARDTW = ones(length(PathHalfConstraintPercents), length(RegionHalfWidthPercents));

        PathIndex = 1;
        for PathHalfConstraintPercent = PathHalfConstraintPercents
                PathIndex
                RegionIndex = 1;
                for RegionHalfWidthPercent = RegionHalfWidthPercents
                    RegionIndex
                    Scores = ones(NumIterations,5);
                    TempScoresDTW = ones(NumIterations, 1);
                    TempScoresADTW = ones(NumIterations, 1);
                    TempScoresRDTW = ones(NumIterations, 1);
                    TempScoresGARDTW = ones(NumIterations, 1);
                    TempScoresLARDTW = ones(NumIterations, 1);
                    for i = 1:NumIterations
                        Signals = ComponentBasedTimeSeriesCell{i,1};
                        IdealPath = ComponentBasedTimeSeriesCell{i,2};
                        if (RegionIndex == 1)
                            [Distance Path] = RDTW(Signals(1,:)', Signals(2,:)', PathHalfConstraintPercent, RegionHalfWidthPercent);
                            DTWScore = ComputeComponentMatchScoreAbsoluteDifference(Length, IdealPath, Path);
                            TempScoresDTW(i) = DTWScore;
                            [Distance Path] = ADTW(Signals(1,:)', Signals(2,:)', PathHalfConstraintPercent, 1, 0, 10^-5, 0.2, 5);
                            ADTWScore = ComputeComponentMatchScoreAbsoluteDifference(Length, IdealPath, Path);
                            TempScoresADTW(i) = ADTWScore;
                        else
                            [Distance Path] = RDTW(Signals(1,:)', Signals(2,:)', PathHalfConstraintPercent, RegionHalfWidthPercent);
                            RDTWScore = ComputeComponentMatchScoreAbsoluteDifference(Length, IdealPath, Path);
                            TempScoresRDTW(i) = RDTWScore;
                            [Distance Path] = GARDTW(Signals(1,:)', Signals(2,:)', PathHalfConstraintPercent, RegionHalfWidthPercent, 1, 0, 10^-5, 0.2, 5);
                            GARDTWScore = ComputeComponentMatchScoreAbsoluteDifference(Length, IdealPath, Path);
                            TempScoresGARDTW(i) = GARDTWScore;
                            [Distance Path] = LARDTW(Signals(1,:)', Signals(2,:)', PathHalfConstraintPercent, RegionHalfWidthPercent, 0.2, 5);
                            LARDTWScore = ComputeComponentMatchScoreAbsoluteDifference(Length, IdealPath, Path);
                            TempScoresLARDTW(i) = LARDTWScore;
                        end
                    end
                    if (RegionIndex == 1)
                        ScoresDTW(PathIndex) = mean(TempScoresDTW);
                        ScoresADTW(PathIndex) = mean(TempScoresADTW);
                    else
                        ScoresRDTW(PathIndex,RegionIndex) = mean(TempScoresRDTW);
                        ScoresGARDTW(PathIndex,RegionIndex) = mean(TempScoresGARDTW);
                        ScoresLARDTW(PathIndex,RegionIndex) = mean(TempScoresLARDTW);
                    end
                    AveragedScores = mean(Scores,1);
                    RegionIndex = RegionIndex + 1;
                end
                PathIndex = PathIndex + 1;
        end

        BestDTW = min(ScoresDTW);
        BestADTW = min(ScoresADTW);
        BestRDTW = min(min(ScoresRDTW));
        BestGARDTW = min(min(ScoresGARDTW));
        BestLARDTW = min(min(ScoresLARDTW));
        BestDTWPathIndex = find(ScoresDTW == BestDTW);
        BestDTWPathIndex = BestDTWPathIndex(1);
        BestADTWPathIndex = find(ScoresADTW == BestADTW);
        BestADTWPathIndex = BestADTWPathIndex(1);
        [BestRDTWPathIndex BestRDTWRegionIndex] = find(ScoresRDTW == BestRDTW);
        BestRDTWPathIndex = BestRDTWPathIndex(1);
        BestRDTWRegionIndex = BestRDTWRegionIndex(1);
        [BestGARDTWPathIndex BestGARDTWRegionIndex] = find(ScoresGARDTW == BestGARDTW);
        BestGARDTWPathIndex = BestGARDTWPathIndex(1);
        BestGARDTWRegionIndex = BestGARDTWRegionIndex(1);
        [BestLARDTWPathIndex BestLARDTWRegionIndex] = find(ScoresLARDTW == BestLARDTW);
        BestLARDTWPathIndex = BestLARDTWPathIndex(1);
        BestLARDTWRegionIndex = BestLARDTWRegionIndex(1);
        FinalScores = [BestDTW BestADTW BestRDTW BestGARDTW BestLARDTW];
        ParameterIndices = [PathHalfConstraintPercents(BestDTWPathIndex) PathHalfConstraintPercents(BestADTWPathIndex) ...
            PathHalfConstraintPercents(BestRDTWPathIndex) RegionHalfWidthPercents(BestRDTWRegionIndex) ...
            PathHalfConstraintPercents(BestGARDTWPathIndex) RegionHalfWidthPercents(BestGARDTWRegionIndex) ...
            PathHalfConstraintPercents(BestLARDTWPathIndex) RegionHalfWidthPercents(BestLARDTWRegionIndex)];
        
        ScoresAcrossAmplitudes(AmplitudeIndex,:) = FinalScores;
        SelectedParameterIndices(AmplitudeIndex,:) = ParameterIndices;
        AmplitudeIndex = AmplitudeIndex + 1;
    end
    WidthAmplitudeScores{WidthIndex,1} = ScoresAcrossAmplitudes;
    WidthAmplitudeScores{WidthIndex,2} = SelectedParameterIndices;
    WidthIndex = WidthIndex + 1;
end

save('ResultsComponent.mat', 'WidthAmplitudeScores');