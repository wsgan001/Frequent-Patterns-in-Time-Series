function [  ] = debugModel( queryIndex, userIndex )
% for model debugging

%% load data
load('./datasetForLinearRegression/OriginalTS.mat');
query = allQueryTS(queryIndex, :); % query TS
vizTS = allVizTS{queryIndex, 1}; % all viz TS under this query
vizTotalNum = size(vizTS,1);

load('./datasetForLinearRegression/TestSet.mat');
testSetIndex = testSetIndexUnderEachQueryUserPair{queryIndex, userIndex};
trainSetIndex = setdiff(1:vizTotalNum, testSetIndex);

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

%% load algorithms for test (need training first)



%% present results (plot etc.)


end
