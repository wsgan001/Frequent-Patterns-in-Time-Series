function [ avgCorr ] = EvaluateAccuracy_cvglmnet( fit )

addpath('/Users/Steven/Documents/GitHub/User-Study-Data/UserStudy');
addpath('../../lib/glmnet_matlab/');
load('./datasetForLinearRegression/TestSet.mat');

queryUserPairNum = 0;
corrSum = 0;
for i = 1:20 % query
    for j = 1:8 % user
        allViz = allDataPoint{i,j};
        testSetIndex = testSetIndexUnderEachQueryUserPair{i,j};
        %if ~isempty(testSetIndex) %empty test set makes no sense
        if size(testSetIndex,2) > 1 % empty or only 1-point test set make no sense
            TestSet = allViz(testSetIndex,:);
            TruthSimilarity = TestSet(:,end);
            features = TestSet(:,1:(end-1));
            
            CalculatedSimilarity = cvglmnetPredict(fit,features,'lambda_min');
            CalculatedSimilarity = round(CalculatedSimilarity); % select a nearest bucket based on predicted scores
            
            queryUserPairNum = queryUserPairNum + 1;
            corrSum = corrSum + spearman(TruthSimilarity, CalculatedSimilarity);
        end
    end
end
avgCorr = corrSum / queryUserPairNum;

end

