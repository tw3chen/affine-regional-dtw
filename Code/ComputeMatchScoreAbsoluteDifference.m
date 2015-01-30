function [Score] = ComputeMatchScoreAbsoluteDifference(Length, MatchNewTimeSeries, Path)

% TotalCorrect = 0;
NumCorrect = 0;
for k = 1:Length
    TrueIndices = find(MatchNewTimeSeries == k);
    EstimatedIndices = find(Path(:,1) == k);
    EstimatedIndices = Path(EstimatedIndices,2);
    for p = 1:length(TrueIndices)
        [Value Index] = min(abs(TrueIndices(p)-EstimatedIndices));
        NumCorrect = NumCorrect + Value;
        
%         if (find(EstimatedIndices == TrueIndices(p)) > 0)
%             NumCorrect = NumCorrect + 1;
%         end
%         TotalCorrect = TotalCorrect + 1;
    end
end
Score = NumCorrect / (0.5*(Length*(Length-1)));
% Score = NumCorrect/TotalCorrect;

end

