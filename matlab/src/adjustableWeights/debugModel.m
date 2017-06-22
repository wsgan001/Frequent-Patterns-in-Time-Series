function [  ] = debugModel( queryIndex, userIndex, fit_f, fit_cv_f )
% for model debugging

lambda = 0.1;

%% load data
load('./datasetForLinearRegression/OriginalTS.mat');
query = allQueryTS{queryIndex, 1}; % query TS
vizTS = allVizTS{queryIndex, 1}; % all viz TS under this query
vizTotalNum = size(vizTS,1);

load('./datasetForLinearRegression/TestSet.mat');
allViz = allDataPoint{queryIndex, userIndex};
testSetIndex = testSetIndexUnderEachQueryUserPair{queryIndex, userIndex};
trainSetIndex = setdiff(1:vizTotalNum, testSetIndex);
TestSet = allViz(testSetIndex,:);
TrainSet = allViz(trainSetIndex,:);
TruthSimilarity = TestSet(:,end);
TruthSimilarity_Train = TrainSet(:,end);

%subjective feature list
%18 - Overall trend, 
%19 - Smoothness/noise, 
%20 - Seasonality, 
%21 - Number of peaks, 
%22 - Relative x, y positions of global maximum and minimum 
%23 - Global increasing or decreasing value
subjectiveFeatureSet = load('/Users/Steven/Documents/GitHub/User-Study-Data/UserStudy/UserResults/SubjectiveImportanceOrderOfObjectiveFeatures/FeatureKeyWordFrequency.csv');
subjectiveFeatures = subjectiveFeatureSet((queryIndex-1)*8+userIndex,:);
if sum(subjectiveFeatures) > 0 %normalize weights
    subjectiveFeatures = subjectiveFeatures/sum(subjectiveFeatures);
end
fprintf('Overall trend: %1.2f\n', subjectiveFeatures(1))
fprintf('Smoothness/noise: %1.2f\n', subjectiveFeatures(2))
fprintf('Seasonality: %1.2f\n', subjectiveFeatures(3))
fprintf('Number of peaks: %1.2f\n', subjectiveFeatures(4))
fprintf('Relative x, y positions of global maximum and minimum: %1.2f\n', subjectiveFeatures(5))
fprintf('Global increasing or decreasing value: %1.2f\n', subjectiveFeatures(6))

%% load algorithms for test (need training first)
%f
features_f = TestSet(:, [1, 5:end-1]);

%TruthSimilarity - one colume
CalculatedSimilarity_f = round(glmnetPredict(fit_f,features_f,lambda));
CalculatedSimilarity_cv_f = round(cvglmnetPredict(fit_cv_f,features_f,'lambda_min'));

% reorder testSetIndex according to similarity
[~,reorder] = sort(TruthSimilarity,'descend');
TruthOrder = testSetIndex(reorder);
[~,reorder] = sort(CalculatedSimilarity_f,'descend');
fOrder = testSetIndex(reorder);
[~,reorder] = sort(CalculatedSimilarity_cv_f,'descend');
cv_fOrder = testSetIndex(reorder);

%% present results (plot etc.)
% plot query
figure
plot(query)
title(['query - ', num2str(queryIndex)]);

% plot train set

figure
trainSetNum = length(trainSetIndex);
axisNumTrain = ceil(sqrt(trainSetNum));
for i = 1:trainSetNum
    subplot(axisNumTrain,axisNumTrain,i)
    plot(vizTS(trainSetIndex(i),:))
    title(['train-i',num2str(trainSetIndex(i)), '-s',num2str(TruthSimilarity_Train(i),3)])
end


% plot test set - truth
figure
testSetNum = length(testSetIndex);
axisNumTest = ceil(sqrt(testSetNum));
tmp = sort(TruthSimilarity,'descend');
for i = 1: testSetNum
    subplot(axisNumTest,axisNumTest,i)
    plot(vizTS(TruthOrder(i),:))
    title(['truth-i',num2str(TruthOrder(i)), '-s', num2str(tmp(i),3) ])
end

% plot test set - f
figure
tmp = sort(CalculatedSimilarity_f,'descend');
for i = 1: testSetNum
    subplot(axisNumTest,axisNumTest,i)
    plot(vizTS(fOrder(i),:))
    title(['fset-i',num2str(fOrder(i)), '-s', num2str(tmp(i),3)])
end

% plot test set - cv_f
%{
figure
for i = 1: testSetNum
    subplot(axisNumTest,axisNumTest,i)
    plot(vizTS(cv_fOrder(i),:))
    title(['test set(cv feature set)  - ',num2str(cv_fOrder(i))])
end
%}

end
