function ErrorRate = ApplyLARDTWMeasureAcrossData(Train, Test, PathHalfConstraintPercent, RegionHalfWidthPercent, MinScale, MaxScale)
TrainClassLabels = Train(:,1);
Train(:,1) = [];
TestClassLabels = Test(:,1);
Test(:,1) = [];

NumCorrect = 0;
for i = 1 : length(TestClassLabels)
    TestTimeSeries = Test(i,:);
    TestClass= TestClassLabels(i);
    
    BestSoFar = Inf;
    PredictedClass = Inf;
    for j = 1 : length(TrainClassLabels)
        TrainTimeSeries = Train(j,:);
        [Distance Path] = LARDTW(TestTimeSeries', TrainTimeSeries', PathHalfConstraintPercent, RegionHalfWidthPercent, ...
            MinScale, MaxScale);
        if Distance < BestSoFar
            PredictedClass = TrainClassLabels(j);
            BestSoFar = Distance;
        end
    end
    
    if PredictedClass == TestClass
        NumCorrect = NumCorrect + 1;
    end
end

ErrorRate = (length(TestClassLabels) - NumCorrect)/length(TestClassLabels);

end