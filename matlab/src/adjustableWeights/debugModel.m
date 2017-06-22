function [  ] = debugModel( queryIndex, userIndex, fit_f, fit_cv_f, fit_cv_d, fit_cv_k, fit_cv_m, fit_cv_o )
% for model debugging
addpath('/Users/Steven/Documents/GitHub/User-Study-Data/UserStudy');

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
%feature
features_f = TestSet(:, [1, 5:end-1]);
features_d = TestSet(:, 2);
features_k = TestSet(:, 4);
features_m = TestSet(:, 1);
features_o = TestSet(:, [1, 5:end-7]);

%TruthSimilarity - one colume
CalculatedSimilarity_f = round(glmnetPredict(fit_f,features_f,lambda));
accuracy_f = spearman(TruthSimilarity, CalculatedSimilarity_f)
CalculatedSimilarity_cv_f = round(cvglmnetPredict(fit_cv_f,features_f,'lambda_min'));
accuracy_cv_f = spearman(TruthSimilarity, CalculatedSimilarity_cv_f)
CalculatedSimilarity_cv_d = round(cvglmnetPredict(fit_cv_d,features_d,'lambda_min'));
accuracy_cv_d = spearman(TruthSimilarity, CalculatedSimilarity_cv_d)
CalculatedSimilarity_cv_k = round(cvglmnetPredict(fit_cv_k,features_k,'lambda_min'));
accuracy_cv_k = spearman(TruthSimilarity, CalculatedSimilarity_cv_k)
CalculatedSimilarity_cv_m = round(cvglmnetPredict(fit_cv_m,features_m,'lambda_min'));
accuracy_cv_m = spearman(TruthSimilarity, CalculatedSimilarity_cv_m)
CalculatedSimilarity_cv_o = round(cvglmnetPredict(fit_cv_o,features_o,'lambda_min'));
accuracy_cv_o = spearman(TruthSimilarity, CalculatedSimilarity_cv_o)

% reorder testSetIndex according to similarity
[~,reorder] = sort(TruthSimilarity,'descend');
TruthOrder = testSetIndex(reorder);
[~,reorder] = sort(CalculatedSimilarity_f,'descend');
fOrder = testSetIndex(reorder);
[~,reorder] = sort(CalculatedSimilarity_cv_f,'descend');
cv_fOrder = testSetIndex(reorder);
[~,reorder] = sort(CalculatedSimilarity_cv_d,'descend');
cv_dOrder = testSetIndex(reorder);
[~,reorder] = sort(CalculatedSimilarity_cv_k,'descend');
cv_kOrder = testSetIndex(reorder);
[~,reorder] = sort(CalculatedSimilarity_cv_m,'descend');
cv_mOrder = testSetIndex(reorder);
[~,reorder] = sort(CalculatedSimilarity_cv_o,'descend');
cv_oOrder = testSetIndex(reorder);

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
figure
tmp = sort(CalculatedSimilarity_cv_f,'descend');
for i = 1: testSetNum
    subplot(axisNumTest,axisNumTest,i)
    plot(vizTS(cv_fOrder(i),:))
    %title(['test set(cv feature set)  - ',num2str(cv_fOrder(i))])
    title(['cv\_f-i',num2str(cv_fOrder(i)), '-s', num2str(tmp(i),3)])
end

% plot test set - cv_d
figure
tmp = sort(CalculatedSimilarity_cv_d,'descend');
for i = 1: testSetNum
    subplot(axisNumTest,axisNumTest,i)
    plot(vizTS(cv_dOrder(i),:))
    title(['cv\_d-i',num2str(cv_dOrder(i)), '-s', num2str(tmp(i),3)])
end

% plot test set - cv_k
figure
tmp = sort(CalculatedSimilarity_cv_k,'descend');
for i = 1: testSetNum
    subplot(axisNumTest,axisNumTest,i)
    plot(vizTS(cv_kOrder(i),:))
    title(['cv\_k-i',num2str(cv_kOrder(i)), '-s', num2str(tmp(i),3)])
end

% plot test set - cv_m
figure
tmp = sort(CalculatedSimilarity_cv_m,'descend');
for i = 1: testSetNum
    subplot(axisNumTest,axisNumTest,i)
    plot(vizTS(cv_mOrder(i),:))
    title(['cv\_m-i',num2str(cv_mOrder(i)), '-s', num2str(tmp(i),3)])
end

% plot test set - cv_o
figure
tmp = sort(CalculatedSimilarity_cv_o,'descend');
for i = 1: testSetNum
    subplot(axisNumTest,axisNumTest,i)
    plot(vizTS(cv_oOrder(i),:))
    title(['cv\_o-i',num2str(cv_oOrder(i)), '-s', num2str(tmp(i),3)])
end


end
