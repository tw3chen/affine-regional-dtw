clc;
clear all;
close all;

% set seed for error reproduction
Stream = RandStream('mt19937ar','Seed',1);
RandStream.setGlobalStream(Stream);

NumVariationsPerTimeSeries = 10;
MatchProbability = 0.6;
InsertProbability = 0.2;
DeleteProbability = 0.2;
ScaleMin = 0.2;
ScaleMax = 5;

DataFolderPath = '../../Dataset/Alignment/';
DatasetFilesAndFolders = dir(DataFolderPath);
DatasetFolders = ExcludeFoldersFromFiles(DatasetFilesAndFolders);
NoiseProportion = 0;

for WarpProbability = 0:0.1:0.6
    MatchProbability = 1 - WarpProbability;
    InsertProbability = WarpProbability / 2;
    DeleteProbability = WarpProbability / 2;
    
    ResultsAbsolute = cell(length(DatasetFolders),6);
    PathHalfConstraintPercents = 0:0.05:0.5;
    RegionHalfWidthPercents = 0:0.05:0.5;
    NumConstraintPercents = length(PathHalfConstraintPercents);
    NumWidthPercents = length(RegionHalfWidthPercents);
    for DataIndex = 1:length(DatasetFolders)
        disp(DataIndex)
        DataFolder = DatasetFolders(DataIndex);
        Data.Name = strrep(DataFolder.name, ' ', '');
        disp(Data.Name);
        DataPath = [DataFolderPath DataFolder.name];
        load(DataPath);
        VerticalMatchScoresAbsolute = zeros(size(TimeSeriesArray,1) * NumVariationsPerTimeSeries,NumConstraintPercents,NumWidthPercents);
        DTWScoresAbsolute = zeros(size(TimeSeriesArray,1) * NumVariationsPerTimeSeries,NumConstraintPercents,NumWidthPercents);
        DTWNormScoresAbsolute = zeros(size(TimeSeriesArray,1) * NumVariationsPerTimeSeries,NumConstraintPercents,1);
        GARDTWScoresAbsolute = zeros(size(TimeSeriesArray,1) * NumVariationsPerTimeSeries,NumConstraintPercents,NumWidthPercents);
        LARDTWScoresAbsolute = zeros(size(TimeSeriesArray,1) * NumVariationsPerTimeSeries,NumConstraintPercents,NumWidthPercents);
        StdForOffset = std(TimeSeriesArray(:));
        for i = 1:10
            TimeSeries = TimeSeriesArray(i,:);
            Length = length(TimeSeries);
            for j = 1:NumVariationsPerTimeSeries
                RandomScale = rand(1) * (ScaleMax - ScaleMin) + ScaleMin;
                RandomOffset = rand(1) * 2 * StdForOffset - StdForOffset;
                ModifiedTimeSeries = RandomScale * TimeSeries + RandomOffset;
                ModifiedTimeSeries = ModifiedTimeSeries + randn(1,Length) * StdForOffset * NoiseProportion;
                [NewTimeSeries MatchNewTimeSeries] = CreateTemporalVariation(ModifiedTimeSeries, MatchProbability, InsertProbability, DeleteProbability);
                for p = 1:NumConstraintPercents
                    for r = 1
%                         VerticalMatchPath = [(1:Length)' (1:Length)'];
%                         VerticalMatchScoresAbsolute((i-1)*NumVariationsPerTimeSeries+j,p,r) = ComputeMatchScoreAbsoluteDifference(Length, MatchNewTimeSeries, VerticalMatchPath);
%                         [Distance DTWPath] = RDTW(TimeSeries', NewTimeSeries', PathHalfConstraintPercents(p), RegionHalfWidthPercents(r));
%                         DTWScoresAbsolute((i-1)*NumVariationsPerTimeSeries+j,p,r) = ComputeMatchScoreAbsoluteDifference(Length, MatchNewTimeSeries, DTWPath);
                        if r == 1
                            [Distance DTWPath] = RDTW(zscore(TimeSeries'), zscore(NewTimeSeries'), PathHalfConstraintPercents(p), RegionHalfWidthPercents(r));
                            DTWNormScoresAbsolute((i-1)*NumVariationsPerTimeSeries+j,p,r) = ComputeMatchScoreAbsoluteDifference(Length, MatchNewTimeSeries, DTWPath);
                        end
                        [Distance GARDTWPath Scaling Offset] = GARDTW(TimeSeries', NewTimeSeries', PathHalfConstraintPercents(p), RegionHalfWidthPercents(r), ...
                            1, 0, 10^-5, 0.2, 5);
                        GARDTWScoresAbsolute((i-1)*NumVariationsPerTimeSeries+j,p,r) = ComputeMatchScoreAbsoluteDifference(Length, MatchNewTimeSeries, GARDTWPath);
%                         [Distance LARDTWPath] = LARDTW(TimeSeries', NewTimeSeries', PathHalfConstraintPercents(p), RegionHalfWidthPercents(r), 0.2, 5);
%                         LARDTWScoresAbsolute((i-1)*NumVariationsPerTimeSeries+j,p,r) = ComputeMatchScoreAbsoluteDifference(Length, MatchNewTimeSeries, LARDTWPath);
                    end
                end
            end
        end
        ResultsAbsolute{DataIndex,1} = Data.Name;
        ResultsAbsolute{DataIndex,2} = VerticalMatchScoresAbsolute;
        ResultsAbsolute{DataIndex,3} = DTWScoresAbsolute;
        ResultsAbsolute{DataIndex,4} = DTWNormScoresAbsolute;
        ResultsAbsolute{DataIndex,5} = GARDTWScoresAbsolute;
        ResultsAbsolute{DataIndex,6} = LARDTWScoresAbsolute;
    end
    save(['ResultsAbsoluteWarp' num2str(WarpProbability) '.mat'], 'ResultsAbsolute');
end