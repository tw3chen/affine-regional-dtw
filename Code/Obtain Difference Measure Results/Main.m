clc;
clearvars;
close all;

DataFolderPath = '../../Dataset/Classification/';

DatasetFilesAndFolders = dir(DataFolderPath);
DatasetFolders = ExcludeFilesFromFolders(DatasetFilesAndFolders);

Results = cell(length(DatasetFolders),3);
PathHalfConstraintPercents = 0:0.05:0.5;
RegionHalfWidthPercents = 0:0.05:0.5;
for DataIndex = 1:length(DatasetFolders)
    disp(DataIndex)
    DataFolder = DatasetFolders(DataIndex);
    Data.Name = strrep(DataFolder.name, ' ', '');
    DataPath = [DataFolderPath DataFolder.name];
    TrainDataName = [DataPath '\' Data.Name '_TRAIN'];
    TestDataName = [DataPath '\' Data.Name '_TEST'];
    disp(Data.Name);
	
    TrainData = load(TrainDataName);
    TestData  = load(TestDataName);
    
    % Divide training data into 2 sets for tuning parameters
    Fraction = 0.5;
    Classes = unique(TrainData(:,1));
    NumTrainingData = size(TrainData,1);
    NumClasses = length(Classes);
    SampledIndices = [];
    for ii = 1:NumClasses
        Indices = find(TrainData(:,1) == Classes(ii));
        NumSamples = round(length(Indices) * Fraction);
        SampledIndices = [SampledIndices; randsample(Indices, NumSamples)];
    end
    TrainData1 = TrainData(SampledIndices,:);
    TrainData2 = TrainData;
    TrainData2(SampledIndices,:) = [];
    
    ErrorRatesDTWTune = ones(length(PathHalfConstraintPercents), 1);
    ErrorRatesNormDTWTune = ones(length(PathHalfConstraintPercents), 1);
    ErrorRatesADTWTune = ones(length(PathHalfConstraintPercents), 1);
    ErrorRatesRDTWTune = ones(length(PathHalfConstraintPercents), length(RegionHalfWidthPercents));
    ErrorRatesGARDTWTune = ones(length(PathHalfConstraintPercents), length(RegionHalfWidthPercents));
    ErrorRatesLARDTWTune = ones(length(PathHalfConstraintPercents), length(RegionHalfWidthPercents));
    PathIndex = 1;
    for PathHalfConstraintPercent = PathHalfConstraintPercents
        PathIndex
        RegionIndex = 1;
        for RegionHalfWidthPercent = RegionHalfWidthPercents
            RegionIndex
            
            if (RegionIndex == 1)
                DTWErrorRate1 = ApplyRDTWMeasureAcrossData(TrainData1, TrainData2, PathHalfConstraintPercent, RegionHalfWidthPercent);
                DTWErrorRate2 = ApplyRDTWMeasureAcrossData(TrainData2, TrainData1, PathHalfConstraintPercent, RegionHalfWidthPercent);
                ErrorRatesDTWTune(PathIndex,RegionIndex) = (DTWErrorRate1 + DTWErrorRate2) / 2;
                NormDTWErrorRate1 = ApplyNormRDTWMeasureAcrossData(TrainData1, TrainData2, PathHalfConstraintPercent, RegionHalfWidthPercent);
                NormDTWErrorRate2 = ApplyNormRDTWMeasureAcrossData(TrainData2, TrainData1, PathHalfConstraintPercent, RegionHalfWidthPercent);
                ErrorRatesNormDTWTune(PathIndex,RegionIndex) = (NormDTWErrorRate1 + NormDTWErrorRate2) / 2;
                ADTWErrorRate1 = ApplyGARDTWMeasureAcrossData(TrainData1, TrainData2, PathHalfConstraintPercent, RegionHalfWidthPercent, ...
                                                        1, 0, 10^-5, 0.25, 5);
                ADTWErrorRate2 = ApplyGARDTWMeasureAcrossData(TrainData2, TrainData1, PathHalfConstraintPercent, RegionHalfWidthPercent, ...
                                                        1, 0, 10^-5, 0.25, 5);
                ErrorRatesADTWTune(PathIndex,RegionIndex) = (ADTWErrorRate1 + ADTWErrorRate2) / 2;
            else
                RDTWErrorRate1 = ApplyRDTWMeasureAcrossData(TrainData1, TrainData2, PathHalfConstraintPercent, RegionHalfWidthPercent);
                RDTWErrorRate2 = ApplyRDTWMeasureAcrossData(TrainData2, TrainData1, PathHalfConstraintPercent, RegionHalfWidthPercent);
                ErrorRatesRDTWTune(PathIndex,RegionIndex) = (RDTWErrorRate1 + RDTWErrorRate2) / 2;
                GARDTWErrorRate1 = ApplyGARDTWMeasureAcrossData(TrainData1, TrainData2, PathHalfConstraintPercent, RegionHalfWidthPercent, ...
                                                        1, 0, 10^-5, 0.25, 5);
                GARDTWErrorRate2 = ApplyGARDTWMeasureAcrossData(TrainData2, TrainData1, PathHalfConstraintPercent, RegionHalfWidthPercent, ...
                                                        1, 0, 10^-5, 0.25, 5);
                ErrorRatesGARDTWTune(PathIndex,RegionIndex) = (GARDTWErrorRate1 + GARDTWErrorRate2) / 2;
            end
            LARDTWErrorRate1 = ApplyLARDTWMeasureAcrossData(TrainData1, TrainData2, ...
                                                    PathHalfConstraintPercent, RegionHalfWidthPercent, 0.25, 5);
            LARDTWErrorRate2 = ApplyLARDTWMeasureAcrossData(TrainData2, TrainData1, ...
                                                    PathHalfConstraintPercent, RegionHalfWidthPercent, 0.25, 5);
            ErrorRatesLARDTWTune(PathIndex,RegionIndex) = (LARDTWErrorRate1 + LARDTWErrorRate2) / 2;
            RegionIndex = RegionIndex + 1;
        end
        PathIndex = PathIndex + 1;
    end
    
    [Value Index] = min(ErrorRatesDTWTune);
    [RowsOfMins] = find(ErrorRatesDTWTune == Value);
    DTWPathIndex = RowsOfMins(1);
    ErrorRateDTW = ApplyRDTWMeasureAcrossData(TrainData, TestData, ... 
                                            PathHalfConstraintPercents(DTWPathIndex), 0);
    
    [Value Index] = min(ErrorRatesNormDTWTune);
    [RowsOfMins] = find(ErrorRatesNormDTWTune == Value);
    NormDTWPathIndex = RowsOfMins(1);
    ErrorRateNormDTW = ApplyNormRDTWMeasureAcrossData(TrainData, TestData, ... 
                                            PathHalfConstraintPercents(NormDTWPathIndex), 0);
    
    [Value Index] = min(ErrorRatesADTWTune);
    [RowsOfMins] = find(ErrorRatesADTWTune == Value);
    ADTWPathIndex = RowsOfMins(1);
    ErrorRateADTW = ApplyGARDTWMeasureAcrossData(TrainData, TestData, ... 
                                            PathHalfConstraintPercents(ADTWPathIndex), 0, ...
                                                        1, 0, 10^-5, 0.25, 5);
    
    [Value Index] = min(ErrorRatesRDTWTune(:));
    [RowsOfMins ColsOfMins] = find(ErrorRatesRDTWTune == Value);
    RDTWPathIndex = RowsOfMins(1);
    RDTWRegionIndex = ColsOfMins(1);
    ErrorRateRDTW = ApplyRDTWMeasureAcrossData(TrainData, TestData, ...
                                PathHalfConstraintPercents(RDTWPathIndex), RegionHalfWidthPercents(RDTWRegionIndex));
    
    [Value Index] = min(ErrorRatesGARDTWTune(:));
    [RowsOfMins ColsOfMins] = find(ErrorRatesGARDTWTune == Value);
    GARDTWPathIndex = RowsOfMins(1);
    GARDTWRegionIndex = ColsOfMins(1);
    ErrorRateGARDTW = ApplyGARDTWMeasureAcrossData(TrainData, TestData, ...
                                PathHalfConstraintPercents(GARDTWPathIndex), RegionHalfWidthPercents(GARDTWRegionIndex), ...
                                                        1, 0, 10^-5, 0.25, 5);
    
    [Value Index] = min(ErrorRatesLARDTWTune(:));
    [RowsOfMins ColsOfMins] = find(ErrorRatesLARDTWTune == Value);
    LARDTWPathIndex = RowsOfMins(1);
    LARDTWRegionIndex = ColsOfMins(1);
    ErrorRateLARDTW = ApplyLARDTWMeasureAcrossData(TrainData, TestData, ...
                                                    PathHalfConstraintPercents(LARDTWPathIndex), RegionHalfWidthPercents(LARDTWRegionIndex), 0.25, 5);

    Results{DataIndex,1} = Data.Name;
    Results{DataIndex,2} = ErrorRatesDTWTune;
    Results{DataIndex,3} = ErrorRateDTW;
    Results{DataIndex,4} = ErrorRatesNormDTWTune;
    Results{DataIndex,5} = ErrorRateNormDTW;
    Results{DataIndex,6} = ErrorRatesADTWTune;
    Results{DataIndex,7} = ErrorRateADTW;
    Results{DataIndex,8} = ErrorRatesRDTWTune;
    Results{DataIndex,9} = ErrorRateRDTW;
    Results{DataIndex,10} = ErrorRatesGARDTWTune;
    Results{DataIndex,11} = ErrorRateGARDTW;
    Results{DataIndex,12} = ErrorRatesLARDTWTune;
    Results{DataIndex,13} = ErrorRateLARDTW;
    save(['DifferenceMeasureResult' num2str(DataIndex) '.mat'], 'Results');
end

save('DifferenceMeasureResult.mat', 'Results');