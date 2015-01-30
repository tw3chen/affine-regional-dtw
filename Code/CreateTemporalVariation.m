function [NewTimeSeries MatchNewTimeSeries] = CreateTemporalVariation(TimeSeries, MatchProbability, InsertProbability, DeleteProbability)

Length = length(TimeSeries);
NewTimeSeries = [];
CurrentIndex = 1;
MatchNewTimeSeries = [];
while (CurrentIndex <= Length)
    RandomNumber = rand(1);
    NewTimeSeries = [NewTimeSeries TimeSeries(CurrentIndex)];
    MatchNewTimeSeries = [MatchNewTimeSeries CurrentIndex];
    if (RandomNumber < MatchProbability)
        CurrentIndex = CurrentIndex + 1;
    elseif (RandomNumber < MatchProbability + InsertProbability)
        CurrentIndex = CurrentIndex;
    else
        CurrentIndex = CurrentIndex + 2;
    end
end
XNew = linspace(1, length(NewTimeSeries), Length);
NewTimeSeries = interp1(NewTimeSeries, XNew);
MatchNewTimeSeries = interp1(MatchNewTimeSeries, XNew);
MatchNewTimeSeries = round(MatchNewTimeSeries);

end

