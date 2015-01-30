function [Score] = ComputeComponentMatchScoreAbsoluteDifference(Length, IdealPath, Path)

NumCorrect = 0;
for k = 1:size(IdealPath,1)
    Index1 = IdealPath(k,1);
    MatchedIndex2 = IdealPath(k,2);
    TempIndices = find(Path(:,1) == Index1);
    TestMatchedIndices2 = Path(TempIndices,2);
    for p = 1:length(TestMatchedIndices2)
        [Value Index] = min(abs(TestMatchedIndices2(p)-MatchedIndex2));
        NumCorrect = NumCorrect + Value;
    end
end
Score = NumCorrect / (0.5*(Length*(Length-1)));

% % TotalCorrect = 0;
% NumCorrect = 0;
% for k = 1:Length
%     TrueIndices = find(MatchNewTimeSeries == k);
%     EstimatedIndices = find(Path(:,1) == k);
%     EstimatedIndices = Path(EstimatedIndices,2);
%     for p = 1:length(TrueIndices)
%         [Value Index] = min(abs(TrueIndices(p)-EstimatedIndices));
%         NumCorrect = NumCorrect + Value;
%         
% %         if (find(EstimatedIndices == TrueIndices(p)) > 0)
% %             NumCorrect = NumCorrect + 1;
% %         end
% %         TotalCorrect = TotalCorrect + 1;
%     end
% end
% Score = NumCorrect / (0.5*(Length*(Length-1)));
% % Score = NumCorrect/TotalCorrect;

end

