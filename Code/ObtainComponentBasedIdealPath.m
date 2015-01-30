function IdealPath = ObtainComponentBasedIdealPath(Matches1, Matches2, LocationsArray)

NumComponents = size(Matches1,1);
Length = size(Matches1,2);
RefinedMatches1 = zeros(1,Length);
RefinedMatches2 = zeros(1,Length);
for c = 1:NumComponents
    for k = 1:Length

        if (Matches1(c,k) ~= 0)
            CurComponentIndex = -1;
            CurDist = Inf;
            for cc = 1:NumComponents
                Value = abs(LocationsArray(cc,1) - k);
                if (Value < CurDist)
                    CurComponentIndex = cc;
                    CurDist = Value;
                end
            end
            if (CurComponentIndex == c)
                RefinedMatches1(k) = Matches1(c,k);
            end
        end

        if (Matches2(c,k) ~= 0)
            CurComponentIndex = -1;
            CurDist = Inf;
            for cc = 1:NumComponents
                Value = abs(LocationsArray(cc,2) - k);
                if (Value < CurDist)
                    CurComponentIndex = cc;
                    CurDist = Value;
                end
            end
            if (CurComponentIndex == c)
                RefinedMatches2(k) = Matches2(c,k);
            end
        end

    end
end

IdealPath = [];
for k = 1:Length
    if RefinedMatches1(k) ~= 0
        Indices = find(RefinedMatches2 == RefinedMatches1(k));
        if ~isempty(Indices)
            IdealPath = [IdealPath; k Indices(1)];
        end
    end
end

end

