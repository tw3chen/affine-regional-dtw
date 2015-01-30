clc;
clearvars;
close all;

load('../Obtain Difference Measure Results/DifferenceMeasureResult27.mat');
PathHalfConstraintPercents = 0:0.05:0.5;
RegionHalfWidthPercents = 0:0.05:0.5;

NumResults = size(Results,1) - 1;
Results([32],:) = [];

CompleteDTWResults = cell2mat(Results(1:NumResults,3));
CompleteADTWResults = cell2mat(Results(1:NumResults,7));
CompleteRDTWResults = cell2mat(Results(1:NumResults,9));
CompleteGARDTWResults = cell2mat(Results(1:NumResults,11));
CompleteLARDTWResults = cell2mat(Results(1:NumResults,13));
Indices = [2:11 13:16 1 38 17:27 29 28 30:33 39 34:36 40:42 43 37 44];%[2:7 11 13:16 38 17 20:25 29 28 30:33 39 34:36 43:44];
DTWResults = CompleteDTWResults(Indices);
ADTWResults = CompleteADTWResults(Indices);
RDTWResults = CompleteRDTWResults(Indices);
GARDTWResults = CompleteGARDTWResults(Indices);
LARDTWResults = CompleteLARDTWResults(Indices);
% Convert from error rate to accuracy
DTWResults = (1 - DTWResults) * 100;
ADTWResults = (1 - ADTWResults) * 100;
RDTWResults = (1 - RDTWResults) * 100;
GARDTWResults = (1 - GARDTWResults) * 100;
LARDTWResults = (1 - LARDTWResults) * 100;

% Results below are taken from the paper on "Time Series Classification with Ensembles of Elastic Distance Measures"
% DTWResults = [61.1253196931 66.6666666667 99.4444444444 62.5 92.8985507246 100 75.3846153846 79.4871794872 ...
%     82.3076923077 92.4836601307 80.0232288037 80.7692307692 89.7727272727 90.9268292683 76.4835164835 83.4285714286 ...
%     91.3333333333 40.5844155844 38.5454545455 96.1127308066 86.8852459016 71.2328767123 91.0021321962 73.9473684211 ...
%     86.5814696486 80.4071246819 86.7684478372 86.6666666667 59.9173553719 69.8835274542 85.7292759706 84.64 ...
%     93.0653266332 98.3333333333 99 85.0746268657 99.85 77.3590173088 69.8492462312 67.3366834171 99.5944192083 73.9811912226 ...
%     84.2666666667]';
WDTWResults = [60.6138107417 70 99.6666666667 62.734375 93.1884057971 100 76.4102564103 81.2820512821 ...
    81.2820512821 96.4052287582 75.493612079 79.4082840237 87.5 91.3170731707 77.1428571429 84.5714285714 ...
    98 39.2857142857 40.1818181818 94.2662779397 90.1639344262 76.7123287671 94.157782516 72.6315789474 ...
    85.8626198083 79.5419847328 85.7506361323 83.3333333333 62.3966942149 73.377703827 86.0440713536 ...
    87.36 94.472361809 99.3333333333 100 86.5671641791 100 77.4427694026 69.6817420436 66.4991624791 ...
    99.70798183 72.4137931034 85.3]';
DDTWResults = [67.0076726343 70 57.2222222222 64.8958333333 92.8985507246 96.4285714286 56.1538461538 ...
    51.7948717949 54.6153846154 90.8496732026 71.7770034843 88.1656804734 73.8636363636 84.7804878049 76.2637362637 ...
    92 100 40.9090909091 27.4545454545 97.2789115646 77.0491803279 69.8630136986 94.7974413646 65.9210526316 77.1565495208 ...
    59.5928753181 69.6183206107 83.3333333333 87.1900826446 69.0515806988 84.9947534103 90.4 91.256281407 56.6666666667 ...
    99 91.3959613696 99.675 73.003908431 62.3394751535 62.5348967058 99.70798183 68.4952978056 82.8666666667]';
WDDTWResults = [67.26342711 70 59.1111111111 65.078125 91.231884058 96.4285714286 58.4615384615 54.6153846154 ...
    59.2307692308 88.2352941176 69.5702671312 89.7041420118 71.5909090909 85.1219512195 76.9230769231 96 ...
    99.3333333333 40.5844155844 21.4545454545 94.5578231293 81.9672131148 68.4931506849 95.1812366738 ...
    66.4473684211 79.6325878594 60.1017811705 72.5699745547 86.6666666667 88.8429752066 73.2113144759 ...
    85.0996852046 89.28 91.4572864322 56.6666666667 100 91.5715539947 99.75 73.143495254 63.2049134562 ...
    62.2557230597 99.7404282933 69.7492163009 83.9666666667]';
LCSSResults = [25.0639386189 76.6666666667 99 55.8854166667 93.1884057971 100 75.1282051282 81.7948717949 ...
    78.4615384615 89.8692810458 76.6550522648 80.0591715976 96.5909090909 95.3658536585 79.7802197802 ...
    86.8571428571 97.3333333333 37.6623376623 41.2727272727 95.1409135083 77.0491803279 57.5342465753 90.8742004264 ...
    65.9210526316 86.9009584665 78.4732824427 83.0025445293 40 78.9256198347 68.0532445923 81.7418677859 88.8 ...
    94.9748743719 95.3333333333 97 79.7190517998 99.925 77.0798436628 66.8062534897 68.3137911781 98.9779364049 ...
    73.9811912226 86.0333333333]';
MSMResults = [62.6598465473 46.6666666667 97 61.796875 91.884057971 89.2857142857 75.8974358974 82.3076923077 75.1282051282 ...
    95.4248366013 77.0034843206 80.9467455621 94.3181818182 96.2926829268 81.3186813187 93.7142857143 97.3333333333 42.2077922078 ...
    42.3636363636 93.5860058309 81.9672131148 75.3424657534 93.3049040512 73.9473684211 87.2204472843 80.6615776081 88.2951653944 ...
    83.3333333333 77.2727272727 74.0432612313 87.40818468 89.6 96.6834170854 97.3333333333 93 94.0298507463 99.9 76.8285873814 ...
    69.793411502 69.932998325 99.7404282933 77.1159874608 86.5333333333]';
TWEResults = [63.4271099744 60 99.1111111111 62.0572916667 76.3043478261 100 75.8974358974 76.1538461538 77.9487179487 ...
    95.0980392157 77.9326364692 78.5798816568 85.2272727273 91.7073170732 79.3406593407 93.1428571429 95.3333333333 ...
    45.1298701299 42.3636363636 95.0437317784 83.606557377 73.9726027397 93.3049040512 70.1315789474 80.910543131 ...
    81.2213740458 87.1755725191 86.6666666667 77.6859504132 68.0532445923 86.149003148 89.12 96.9849246231 98.6666666667 ...
    99 95.9613696225 99.825 77.1077610274 68.6487995533 68.8163037409 99.561972745 74.6081504702 86.8]';
ERPResults = [60.8695652174 66.6666666667 99.7777777778 63.828125 88.1884057971 100 75.641025641 83.8461538462 82.0512820513 ...
    92.4836601307 80.2555168409 79.2899408284 86.3636363636 92.2926829268 71.2087912088 87.4285714286 94.6666666667 ...
    37.3376623377 41.0909090909 96.0155490768 86.8852459016 73.9726027397 91.0021321962 67.6315789474 86.9808306709 ...
    81.5267175573 87.9389312977 86.6666666667 60.3305785124 69.8835274542 82.0566631689 86.24 91.959798995 97.3333333333 ...
    95 89.8156277436 100 77.2473478504 68.1183696259 66.3874930207 99.561972745 67.868338558 84.7]';

FID = fopen('Table.txt', 'w');
fprintf(FID, '\\begin{table*}\n');
fprintf(FID, '\\caption{Win-loss ratios of 1-NN with proposed elastic measures against other elastic difference measures on the UCR database.}\n');
fprintf(FID, '\\label{Table:WinLossDifferenceMeasure}\n');
fprintf(FID, '\\centering\n');
fprintf(FID, '\\begin{tabular}{|c|c|c|c|c|}\n\\hline\n');
fprintf(FID, '\\multirow{2}{*}{Compared elastic difference measures} & \\multicolumn{4}{c|}{Proposed elastic difference measures}\\\\\n\\cline{2-5}\n');
fprintf(FID, ' & ADTW & RDTW & GARDTW & LARDTW \\\\\n\\hline\n');

for i = 1:8
    if (i == 1)
        ComparedResults = DTWResults;
    elseif (i == 2)
        ComparedResults = WDTWResults;
    elseif (i == 3)
        ComparedResults = DDTWResults;
    elseif (i == 4)
        ComparedResults = WDDTWResults;
    elseif (i == 5)
        ComparedResults = LCSSResults;
    elseif (i == 6)
        ComparedResults = MSMResults;
    elseif (i == 7)
        ComparedResults = TWEResults;
    elseif (i == 8)
        ComparedResults = ERPResults;
    end
    
    NumADTWBetter = length(find(ADTWResults > ComparedResults));
%    NumNormalizedDTWBetter = length(find(NormalizedDTWResults < ComparedResults));
    NumRDTWBetter = length(find(RDTWResults > ComparedResults));
    NumGARDTWBetter = length(find(GARDTWResults > ComparedResults));
    NumLARDTWBetter = length(find(LARDTWResults > ComparedResults));
    NumADTWWorse = length(find(ADTWResults < ComparedResults));
%     NumNormalizedDTWWorse = length(find(NormalizedDTWResults < ComparedResults));
    NumRDTWWorse = length(find(RDTWResults < ComparedResults));
    NumGARDTWWorse = length(find(GARDTWResults < ComparedResults));
    NumLARDTWWorse = length(find(LARDTWResults < ComparedResults));
    NumADTWEqual = length(find(ADTWResults == ComparedResults));
%     NumNormalizedDTWEqual = length(find(NormalizedDTWResults == ComparedResults));
    NumRDTWEqual = length(find(RDTWResults == ComparedResults));
    NumGARDTWEqual = length(find(GARDTWResults == ComparedResults));
    NumLARDTWEqual = length(find(LARDTWResults == ComparedResults));
    
    MethodName = 'DTW';
    if (i == 2)
		MethodName = 'WDTW';
    elseif (i == 3)
        MethodName = 'DDTW';
	elseif (i == 4)
		MethodName = 'WDDTW';
    elseif (i == 5)
        MethodName = 'LCSS';
    elseif (i == 6)
        MethodName = 'MSM';
    elseif (i == 7)
        MethodName = 'TWE';
    elseif (i == 8)
        MethodName = 'ERP';
    end
    
    fprintf(FID, [MethodName ' & $%1.1f$ ($%2.0f$,$%2.0f$,$%2.0f$) & $%1.1f$ ($%2.0f$,$%2.0f$,$%2.0f$) & $%1.1f$ ($%2.0f$,$%2.0f$,$%2.0f$) & $%1.1f$ ($%2.0f$,$%2.0f$,$%2.0f$) \\\\\n\\hline\n'], ...
        (NumADTWBetter+0.5*NumADTWEqual)/(NumADTWWorse+0.5*NumADTWEqual), NumADTWBetter, NumADTWEqual, NumADTWWorse, ...
        (NumRDTWBetter+0.5*NumRDTWEqual)/(NumRDTWWorse+0.5*NumRDTWEqual), NumRDTWBetter, NumRDTWEqual, NumRDTWWorse, ...
        (NumGARDTWBetter+0.5*NumGARDTWEqual)/(NumGARDTWWorse+0.5*NumGARDTWEqual), NumGARDTWBetter, NumGARDTWEqual, NumGARDTWWorse, ...
        (NumLARDTWBetter+0.5*NumLARDTWEqual)/(NumLARDTWWorse+0.5*NumLARDTWEqual), NumLARDTWBetter, NumLARDTWEqual, NumLARDTWWorse);
    %(NumNormalizedDTWBetter+0.5*NumNormalizedDTWEqual)/(NumNormalizedDTWWorse+0.5*NumNormalizedDTWEqual)
end

fprintf(FID, '\\end{tabular}\n');
fprintf(FID, '\\end{table*}');
fclose(FID);

ComprehensiveMatrix = [DTWResults ADTWResults RDTWResults ...
                                    GARDTWResults LARDTWResults ...
                                    WDTWResults DDTWResults WDDTWResults LCSSResults MSMResults TWEResults ERPResults];
% [SortedValues SortedIndices] = sort(ComprehensiveMatrix, 2, 'descend');
% FilteredValues = ones(size(SortedIndices,1),1);
% for i = 1:size(SortedIndices,1)
%     Index = 1;
%     for j = 1:9
%         if SortedIndices(i,j) == 1 || SortedIndices(i,j) >= 6
%             FilteredValues(i,Index) = SortedValues(i,j);
%             Index = Index + 1;
%         end
%     end
% end
% Indices = find(SortedIndices(:,1) == 1);
% disp(['Num DTW best: ' num2str(length(Indices))]);
% disp(['Mean Improvement: ' num2str(mean(SortedValues(Indices,1) - FilteredValues(Indices,2)))]);
% Indices = find(SortedIndices(:,1) == 2);
% disp(['Num ADTW best: ' num2str(length(Indices))]);
% disp(['Mean Improvement: ' num2str(mean(SortedValues(Indices,1) - FilteredValues(Indices,1)))]);
% Indices = find(SortedIndices(:,1) == 3);
% disp(['Num RDTW best: ' num2str(length(Indices))]);
% disp(['Mean Improvement: ' num2str(mean(SortedValues(Indices,1) - FilteredValues(Indices,1)))]);
% Indices = find(SortedIndices(:,1) == 4);
% disp(['Num GARDTW best: ' num2str(length(Indices))]);
% disp(['Mean Improvement: ' num2str(mean(SortedValues(Indices,1) - FilteredValues(Indices,1)))]);
% Indices = find(SortedIndices(:,1) == 5);
% disp(['Num LARDTW best: ' num2str(length(Indices))]);
% disp(['Mean Improvement: ' num2str(mean(SortedValues(Indices,1) - FilteredValues(Indices,1)))]);
% Indices = find(SortedIndices(:,1) == 6);
% disp(['Num DDTW best: ' num2str(length(Indices))]);
% disp(['Mean Improvement: ' num2str(mean(SortedValues(Indices,1) - FilteredValues(Indices,2)))]);
% Indices = find(SortedIndices(:,1) == 7);
% disp(['Num MSM best: ' num2str(length(Indices))]);
% disp(['Mean Improvement: ' num2str(mean(SortedValues(Indices,1) - FilteredValues(Indices,2)))]);
% Indices = find(SortedIndices(:,1) == 8);
% disp(['Num TWE best: ' num2str(length(Indices))]);
% disp(['Mean Improvement: ' num2str(mean(SortedValues(Indices,1) - FilteredValues(Indices,2)))]);
% Indices = find(SortedIndices(:,1) == 9);
% disp(['Num ERP best: ' num2str(length(Indices))]);
% disp(['Mean Improvement: ' num2str(mean(SortedValues(Indices,1) - FilteredValues(Indices,2)))]);

[Values Indices] = max(ComprehensiveMatrix');
Indices = Indices';
disp(['Num DTW best: ' num2str(length(find(Indices == 1)))]);
disp(['Num ADTW best: ' num2str(length(find(Indices == 2)))]);
disp(['Num RDTW best: ' num2str(length(find(Indices == 3)))]);
disp(['Num GARDTW best: ' num2str(length(find(Indices == 4)))]);
disp(['Num LARDTW best: ' num2str(length(find(Indices == 5)))]);
disp(['Num WDTW best: ' num2str(length(find(Indices == 6)))]);
disp(['Num DDTW best: ' num2str(length(find(Indices == 7)))]);
disp(['Num WDDTW best: ' num2str(length(find(Indices == 8)))]);
disp(['Num LCSS best: ' num2str(length(find(Indices == 9)))]);
disp(['Num MSM best: ' num2str(length(find(Indices == 10)))]);
disp(['Num TWE best: ' num2str(length(find(Indices == 11)))]);
disp(['Num ERP best: ' num2str(length(find(Indices == 12)))]);

RankMatrix = zeros(size(ComprehensiveMatrix));
[SortedValues SortedIndices] = sort(ComprehensiveMatrix, 2, 'descend');
for i = 1:size(RankMatrix,1)
    for j = 1:size(RankMatrix,2)
        RankMatrix(i,SortedIndices(i,j)) = j;
    end
end
MeanRank = mean(RankMatrix,1);

[Temp Indices] = sort(MeanRank);
ClassifierNames = {'DTW', 'ADTW', 'RDTW', 'GARDTW', 'LARDTW', 'WDTW', 'DDTW', 'WDDTW', 'LCSS', 'MSM', 'TWE', 'ERP'};
NumClassifiers = length(MeanRank);

Figure1 = figure(1);
set(Figure1, 'Position', [100, 100, 900, 400]);

line([1 NumClassifiers],[0 0], 'Color', 'k');
hold on;
for i = 1:NumClassifiers
    line([i i], [0 0.1], 'Color', 'k');
    text(i-0.1, 0.15, num2str(i));
end
plot(MeanRank , zeros(size(MeanRank)),'*', 'Color', 'k');
xlim([1-0.2 NumClassifiers+0.3]);
ylim([-1.5 0.35]);

% RDTW
line([Temp(1) Temp(1)], [0 -0.4], 'Color', 'k');
line([Temp(1) 2], [-0.4 -0.4], 'Color', 'k');
text(1, -0.4, 'RDTW');

% GARDTW
line([Temp(2) Temp(2)], [0 -0.6], 'Color', 'k');
line([Temp(2) 3], [-0.6 -0.6], 'Color', 'k');
text(1.5, -0.6, 'GARDTW');

% MSM
line([Temp(3) Temp(3)], [0 -0.8], 'Color', 'k');
line([Temp(3) 4], [-0.8 -0.8], 'Color', 'k');
text(3.1, -0.8, 'MSM');

% LARDTW
line([Temp(4) Temp(4)], [0 -1], 'Color', 'k');
line([Temp(4) 5], [-1 -1], 'Color', 'k');
text(3.5, -1, 'LARDTW');

% WDTW
line([Temp(5) Temp(5)], [0 -1.2], 'Color', 'k');
line([Temp(5) 5.7], [-1.2 -1.2], 'Color', 'k');
text(4.5, -1.2, 'WDTW');

% ADTW
line([Temp(6) Temp(6)], [0 -1.4], 'Color', 'k');
line([Temp(6) 6], [-1.4 -1.4], 'Color', 'k');
text(5, -1.4, 'ADTW');

% TWE
line([Temp(7) Temp(7)], [0 -1.4], 'Color', 'k');
line([Temp(7) 6.7], [-1.4 -1.4], 'Color', 'k');
text(6.7, -1.4, 'TWE');

% DTW
line([Temp(8) Temp(8)], [0 -1.2], 'Color', 'k');
line([Temp(8) 7], [-1.2 -1.2], 'Color', 'k');
text(7.1, -1.2, 'DTW');

% ERP
line([Temp(9) Temp(9)], [0 -1], 'Color', 'k');
line([Temp(9) 8], [-1 -1], 'Color', 'k');
text(8.1, -1, 'ERP');

% LCSS
line([Temp(10) Temp(10)], [0 -0.8], 'Color', 'k');
line([Temp(10) 9], [-0.8 -0.8], 'Color', 'k');
text(9.1, -0.8, 'LCSS');

% WDDTW
line([Temp(11) Temp(11)], [0 -0.6], 'Color', 'k');
line([Temp(11) 9.5], [-0.6 -0.6], 'Color', 'k');
text(9.6, -0.6, 'WDDTW');

% DDTW
line([Temp(12) Temp(12)], [0 -0.4], 'Color', 'k');
line([Temp(12) 10.5], [-0.4 -0.4], 'Color', 'k');
text(10.6, -0.4, 'DDTW');

CriticalDifference = 2.356;
line([1 1], [0.3 0.35], 'Color', 'k', 'LineWidth', 2);
line([1+CriticalDifference 1+CriticalDifference], [0.3 0.35], 'Color', 'k', 'LineWidth', 2);
line([1 1+CriticalDifference], [0.325 0.325], 'Color', 'k', 'LineWidth', 2);
text(1, 0.4, ['critical difference = ' num2str(CriticalDifference)]);

line([Temp(1) Temp(1)+CriticalDifference], [-0.1 -0.1], 'Color', 'k', 'LineWidth', 10);
line([Temp(4) Temp(4)+CriticalDifference], [-0.2 -0.2], 'Color', 'k', 'LineWidth', 10);
line([Temp(6) Temp(6)+CriticalDifference], [-0.3 -0.3], 'Color', 'k', 'LineWidth', 10);

set(gcf, 'Color', 'w');
axis off;
export_fig( gcf, ...      % figure handle
    'ClassifierRank',... % name of output file without extension
    '-painters', ...      % renderer
    '-jpg', ...           % file format
    '-r72' );             % resolution in dpi

close all;

% Convert to error rates
DTWResults = 1 - DTWResults * 0.01;
RDTWResults = 1 - RDTWResults * 0.01;
ADTWResults = 1 - ADTWResults * 0.01;
GARDTWResults = 1 - GARDTWResults * 0.01;
LARDTWResults = 1 - LARDTWResults * 0.01;

Figure1 = figure(1);
set(Figure1, 'Position', [100, 100, 600, 600]);
Limits = [0 0.65];
OtherTextShifts = [-0.35 0.07];
DTWTextShifts = [0.03 -0.08];

subaxis(2, 2, 1, 'SpacingVertical', 0.15, 'SpacingHorizontal', 0.1, 'Padding', 0, 'Margin', 0.1);
DTW_vs_ADTW_Points = [DTWResults ADTWResults];
plot(Limits,Limits, 'Color', 'k');
hold on;
plot(DTW_vs_ADTW_Points(:,1),DTW_vs_ADTW_Points(:,2),'*', 'Color', 'k');
xlabel('DTW error rate');
ylabel('ADTW error rate');
title('ADTW error rate vs DTW error rate');
xlim(Limits);
ylim(Limits);
text(Limits(1) + DTWTextShifts(1), Limits(2) + DTWTextShifts(2), {'In this area,' 'DTW is better'});
text(Limits(2) + OtherTextShifts(1), Limits(1) + OtherTextShifts(2), {'In this area,' 'ADTW is better'});

subaxis(2, 2, 2, 'SpacingVertical', 0.15, 'SpacingHorizontal', 0.1, 'Padding', 0, 'Margin', 0.1);
DTW_vs_RDTW_Points = [DTWResults RDTWResults];
plot(Limits,Limits, 'Color', 'k');
hold on;
plot(DTW_vs_RDTW_Points(:,1),DTW_vs_RDTW_Points(:,2),'*', 'Color', 'k');
xlabel('DTW error rate');
ylabel('RDTW error rate');
title('RDTW error rate vs DTW error rate');
xlim(Limits);
ylim(Limits);
text(Limits(1) + DTWTextShifts(1), Limits(2) + DTWTextShifts(2), {'In this area,' 'DTW is better'});
text(Limits(2) + OtherTextShifts(1), Limits(1) + OtherTextShifts(2), {'In this area,' 'RDTW is better'});

subaxis(2, 2, 3, 'SpacingVertical', 0.15, 'SpacingHorizontal', 0.1, 'Padding', 0, 'Margin', 0.1);
DTW_vs_GARDTW_Points = [DTWResults GARDTWResults];
plot(Limits,Limits, 'Color', 'k');
hold on;
plot(DTW_vs_GARDTW_Points(:,1),DTW_vs_GARDTW_Points(:,2),'*', 'Color', 'k');
xlabel('DTW error rate');
ylabel('GARDTW error rate');
title('GARDTW error rate vs DTW error eate');
xlim(Limits);
ylim(Limits);
text(Limits(1) + DTWTextShifts(1), Limits(2) + DTWTextShifts(2), {'In this area,' 'DTW is better'});
text(Limits(2) + OtherTextShifts(1), Limits(1) + OtherTextShifts(2), {'In this area,' 'GARDTW is better'});

subaxis(2, 2, 4, 'SpacingVertical', 0.15, 'SpacingHorizontal', 0.1, 'Padding', 0, 'Margin', 0.1);
DTW_vs_LARDTW_Points = [DTWResults LARDTWResults];
plot(Limits,Limits, 'Color', 'k');
hold on;
plot(DTW_vs_LARDTW_Points(:,1),DTW_vs_LARDTW_Points(:,2),'*', 'Color', 'k');
xlabel('DTW error rate');
ylabel('LARDTW error rate');
title('LARDTW error rate vs DTW error rate');
xlim(Limits);
ylim(Limits);
text(Limits(1) + DTWTextShifts(1), Limits(2) + DTWTextShifts(2), {'In this area,' 'DTW is better'});
text(Limits(2) + OtherTextShifts(1), Limits(1) + OtherTextShifts(2), {'In this area,' 'LARDTW is better'});

set(gcf, 'Color', 'w');
export_fig( gcf, ...      % figure handle
    'ProposedVariantsVSDTW',... % name of output file without extension
    '-painters', ...      % renderer
    '-jpg', ...           % file format
    '-r72' );             % resolution in dpi