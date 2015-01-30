clc;
clearvars;
close all;

DataFolderPath = '../../Dataset/Classification/';

DatasetFilesAndFolders = dir(DataFolderPath);
DatasetFolders = ExcludeFilesFromFolders(DatasetFilesAndFolders);

Results = cell(length(DatasetFolders),3);
PathHalfConstraintPercent = 0.2;
RegionHalfWidthPercent = 0.2;
NumPairsTimeSeries = 10;
TimeTaken = cell(5,1);

for i = 1:5
	TimeTaken{i} = zeros(length(DatasetFolders),NumPairsTimeSeries);
end
DatasetLength = zeros(length(DatasetFolders),1);
for DataIndex = 1:length(DatasetFolders)
	Stream = RandStream('mt19937ar','Seed',0);
	RandStream.setGlobalStream(Stream);

    disp(DataIndex)
    DataFolder = DatasetFolders(DataIndex);
    Data.Name = strrep(DataFolder.name, ' ', '');
    DataPath = [DataFolderPath DataFolder.name];
    TrainDataName = [DataPath '\' Data.Name '_TRAIN'];
    TestDataName = [DataPath '\' Data.Name '_TEST'];
    disp(Data.Name);
	
    TrainData = load(TrainDataName);
    TestData  = load(TestDataName);
    
	Data = [TrainData(:,2:end); TestData(:,2:end)];
	Indices = randsample(size(Data,1), NumPairsTimeSeries*2);
	Data = Data(Indices,:);
	DatasetLength = size(Data,2);
	
	for i = 1:NumPairsTimeSeries
		TimeSeries1 = Data(2*(i-1)+1,:);
		TimeSeries2 = Data(2*(i-1)+2,:);
		
		tStart = tic;
		[Distance Path] = RDTW(TimeSeries1', TimeSeries2', PathHalfConstraintPercent, 0);
		tElapsed = toc(tStart);
		TimeTaken{1}(DataIndex,i) = tElapsed;
		
		tStart = tic;
		[Distance Path] = ADTW(TimeSeries1', TimeSeries2', PathHalfConstraintPercent, 1, 0, 10^-5, 0.2, 5);
		tElapsed = toc(tStart);
		TimeTaken{2}(DataIndex,i) = tElapsed;
		
		tStart = tic;
		[Distance Path] = RDTW(TimeSeries1', TimeSeries2', PathHalfConstraintPercent, RegionHalfWidthPercent);
		tElapsed = toc(tStart);
		TimeTaken{3}(DataIndex,i) = tElapsed;
		
		tStart = tic;
		[Distance Path] = GARDTW(TimeSeries1', TimeSeries2', PathHalfConstraintPercent, RegionHalfWidthPercent, ...
								1, 0, 10^-5, 0.2, 5);
		tElapsed = toc(tStart);
		TimeTaken{4}(DataIndex,i) = tElapsed;
		
		tStart = tic;
		[Distance Path] = LARDTW(TimeSeries1', TimeSeries2', PathHalfConstraintPercent, RegionHalfWidthPercent, 0.2, 5);
		tElapsed = toc(tStart);
		TimeTaken{5}(DataIndex,i) = tElapsed;
	end
	
    save(['RecordTimeTaken' num2str(DataIndex) '.mat'], 'TimeTaken', 'DatasetLength');
end

save('RecordTimeTaken.mat', 'TimeTaken', 'DatasetLength');