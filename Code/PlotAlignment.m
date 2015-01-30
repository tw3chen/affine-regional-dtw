function [] = PlotAlignment(Signal1, Signal2, Path, Offset, MultiplicationFactor, DisplaySAndT, ModAmount)

% Signal1 at bottom and Signal2 at top
Signal1 = MultiplicationFactor * Signal1;
Signal2 = MultiplicationFactor * Signal2;
ModifiedSignal2 = Signal2 + Offset;
plot(Signal1, 'k');
hold on;
if DisplaySAndT
    text(4,mean(Signal1(1:10)) + mean(Signal1(1:10)),'s');
end
plot(ModifiedSignal2, 'k');
if DisplaySAndT
    text(4,mean(ModifiedSignal2(1:10)) - mean(Signal1(1:10)),'t');
end
Margin = max(Signal1) * 0.1;
xlim([1, length(Signal1)]);
ylim([min(Signal1) - Margin, max(ModifiedSignal2) + Margin]);
if ~isempty(Path)
    for k = 1:size(Path,1)
        if (mod(k,ModAmount) == 0)
            plot([Path(k,2) Path(k,1)], [ModifiedSignal2(Path(k,2)) Signal1(Path(k,1))], 'k');
        end
    end
end
set(gca, 'YTick', [], 'YTicklabel', '');
set(gca, 'XTick', [], 'XTicklabel', '');

end