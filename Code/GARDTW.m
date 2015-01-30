function [Distance Path Scaling Offset] = GARDTW(SignalS, SignalT, BandHalfWidthPercent, RegionHalfWidthPercent, ...
    InitialC, InitialE, StoppingDistDifference, MinScaling, MaxScaling)

CurrentScaling = InitialC;
CurrentOffset = InitialE;
PrevDistance = Inf;

GARDTWIterationNum = 0;
while(1)
    GARDTWIterationNum = GARDTWIterationNum + 1;
    ScaledSignalT = CurrentScaling * SignalT + CurrentOffset;
    [Distance Path] = RDTW(SignalS, ScaledSignalT, BandHalfWidthPercent, RegionHalfWidthPercent);
    [CurrentScaling CurrentOffset] = ComputeGARDTWParam(SignalS, SignalT, Path-1, RegionHalfWidthPercent, MinScaling, MaxScaling);
    
    % Check if the previous and current distances are close enough
    if (PrevDistance - Distance < StoppingDistDifference)
        break;
    end
    
    PrevDistance = Distance;
end

Scaling = CurrentScaling;
Offset = CurrentOffset;

end