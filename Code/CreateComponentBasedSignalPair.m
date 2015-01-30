function [Signals, Matches1, Matches2, Contributions1, Contributions2, OverlapsCellArray, ComponentWidths, LocationsArray] = ...
    CreateComponentBasedSignalPair(NumComponents, Length, Amplitudes, UseFixedWidth)

NumSignals = 2;
Signals = zeros(NumSignals,Length);
MinWidth = ceil(Length/NumComponents/2);
WidthsArray = zeros(NumComponents,NumSignals);
LocationsArray = zeros(NumComponents,NumSignals);
StartLocationsArray = zeros(NumComponents,NumSignals);
Contributions1 = zeros(NumComponents,Length);
Contributions2 = zeros(NumComponents,Length);
PrevWidths = zeros(NumComponents,1);
NumComponentTypes = 4; % 1: Gaussian Window, 2: Rectangular Window, 3: Triangular Window, 4: Flat Top Window
ComponentTypeIndices = randsample(NumComponentTypes,NumComponents);
for n = 1:NumSignals
    Widths = randsample(floor(Length/NumComponents - MinWidth), NumComponents);
    Widths = Widths + MinWidth;
    if UseFixedWidth
        Widths(:) = MinWidth;
    end
    Locations = zeros(NumComponents,1);
    StartLocations = zeros(NumComponents,1);
    MinLocationStart = -1;
    if (mod(Widths(1),2) ~= 0) % odd case
        MinLocationStart = (Widths(1) - 1)/2 + 1;
    else % even case
        MinLocationStart = Widths(1)/2 + 1;
    end
    MaxLocationEnd = -1;
    if (mod(Widths(NumComponents),2) ~= 0) % odd case
        MaxLocationEnd = Length - (Widths(NumComponents) - 1)/2;
    else % even case
        MaxLocationEnd = Length - Widths(NumComponents)/2 - 1;
    end
    for i = 1:NumComponents
        MinLocation = 1 + Length/NumComponents*(i-1);
        MaxLocation = Length/NumComponents*i;
        if (i == 1)
            MinLocation = MinLocationStart;
        elseif (i == NumComponents)
            MaxLocation = MaxLocationEnd;
        end
        Locations(i) = floor(rand(1)*(MaxLocation-MinLocation)) + MinLocation;
    end
    Signal = zeros(1,Length);
    
    for i = 1:NumComponents
        Width = Widths(i);
        Hamming = [];
        if ComponentTypeIndices(i) == 1
            Hamming = parzenwin(Width);
        elseif ComponentTypeIndices(i) == 2
            Hamming = rectwin(Width);
        elseif ComponentTypeIndices(i) == 3
            Hamming = triang(Width);
        else
            Hamming = flattopwin(Width);
        end
        
        Location = Locations(i);
        StartIndex = -1;
        EndIndex = -1;
        if (mod(Width,2) ~= 0) % odd case
            StartIndex = Location - (Width - 1)/2;
            EndIndex = Location + (Width - 1)/2;
        else % even case
            StartIndex = Location - Width/2;
            EndIndex = Location + Width/2 - 1;
        end
        StartLocations(i) = StartIndex;
        for k = StartIndex:EndIndex
            Signal(k) = Signal(k) + Amplitudes(n,i) * Hamming(k-StartIndex+1);
            if (n == 1)
                Contributions1(i,k) = abs(Amplitudes(n,i) * Hamming(k-StartIndex+1));
            else
                Contributions2(i,k) = abs(Amplitudes(n,i) * Hamming(k-StartIndex+1));
            end
        end
    end
    Signals(n,:) = Signal;
    WidthsArray(:,n) = Widths;
    LocationsArray(:,n) = Locations;
    StartLocationsArray(:,n) = StartLocations;
end

for k = 1:Length
    Norm1 = sum(Contributions1(:,k));
    Norm2 = sum(Contributions2(:,k));
    if (Norm1 ~= 0)
        Contributions1(:,k) = Contributions1(:,k) / Norm1;
    end
    if (Norm2 ~= 0)
        Contributions2(:,k) = Contributions2(:,k) / Norm2;
    end
end

Matches1 = zeros(NumComponents,Length);
Matches2 = zeros(NumComponents,Length);
OverlapsCellArray = cell(2,Length);
for i = 1:NumComponents
    Match1 = 1:WidthsArray(i,1);
    X2 = linspace(1, WidthsArray(i,1), WidthsArray(i,2));
    Match2 = interp1(Match1, X2);
    Match2 = round(Match2);
    StartLocation1 = StartLocationsArray(i,1);
    StartLocation2 = StartLocationsArray(i,2);
    Matches1(i,StartLocation1:StartLocation1+WidthsArray(i,1)-1) = ...
        Match1 + StartLocation1 - 1;
    Matches2(i,StartLocation2:StartLocation2+WidthsArray(i,2)-1) = ...
        Match2 + StartLocation1 - 1;
    for m = StartLocation1:StartLocation1+WidthsArray(i,1)-1
        OverlapsCellArray{1,m} = [OverlapsCellArray{1,m} i];
    end
    for m = StartLocation2:StartLocation2+WidthsArray(i,2)-1
        OverlapsCellArray{2,m} = [OverlapsCellArray{2,m} i];
    end
end

ComponentWidths = WidthsArray;

end