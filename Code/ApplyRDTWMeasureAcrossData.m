function ErrorRate = ApplyRDTWMeasureAcrossData(Train, Test, PathHalfConstraintPercent, RegionHalfWidthPercent)
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
        [Distance RDTWPath] = RDTW(TestTimeSeries', TrainTimeSeries', PathHalfConstraintPercent, RegionHalfWidthPercent);
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