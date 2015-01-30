function [Distance Path Scaling Offset] = ADTW(SignalS, SignalT, BandHalfWidthPercent, ...
    InitialC, InitialE, StoppingDistDifference, MinScaling, MaxScaling)

CurrentScaling = InitialC;
CurrentOffset = InitialE;
PrevDistance = Inf;

ASDTWIterationNum = 0;
while(1)
    ASDTWIterationNum = ASDTWIterationNum + 1;
    ScaledSignalT = CurrentScaling * SignalT + CurrentOffset;
    [Distance Path] = RDTW(SignalS, ScaledSignalT, BandHalfWidthPercent, 0);
    PathLength = length(Path);
    PathS = SignalS(Path(:,1));
	PathT = SignalT(Path(:,2));
	CurrentScaling = (sum(PathS.*PathT) - 1/PathLength*sum(PathS)*sum(PathT)) / ...
		(sum(PathT.^2) - 1/PathLength*(sum(PathT))^2);
	if (CurrentScaling < MinScaling)
		CurrentScaling = MinScaling;
	elseif (CurrentScaling > MaxScaling)
		CurrentScaling = MaxScaling;
	end
	CurrentOffset = 1/PathLength * sum(PathS - CurrentScaling*PathT);
    
    % Check if the previous and current distances are close enough
    if (PrevDistance - Distance < StoppingDistDifference)
        break;
    end
    
    PrevDistance = Distance;
end

Scaling = CurrentScaling;
Offset = CurrentOffset;

end